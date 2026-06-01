// Copyright 2023 Google LLC
// SPDX-License-Identifier: BSD-2-Clause

#include "avif/internal.h"
#include <assert.h>
#include <float.h>
#include <math.h>
#include <string.h>

static void avifGainMapSetDefaults(avifGainMap * gainMap)
{
    for (int i = 0; i < 3; ++i) {
        gainMap->gainMapMin[i] = (avifSignedFraction) { 1, 1 };
        gainMap->gainMapMax[i] = (avifSignedFraction) { 1, 1 };
        gainMap->baseOffset[i] = (avifSignedFraction) { 1, 64 };
        gainMap->alternateOffset[i] = (avifSignedFraction) { 1, 64 };
        gainMap->gainMapGamma[i] = (avifUnsignedFraction) { 1, 1 };
    }
    gainMap->baseHdrHeadroom = (avifUnsignedFraction) { 0, 1 };
    gainMap->alternateHdrHeadroom = (avifUnsignedFraction) { 1, 1 };
    gainMap->useBaseColorSpace = AVIF_TRUE;
}

static float avifSignedFractionToFloat(avifSignedFraction f)
{
    if (f.d == 0) {
        return 0.0f;
    }
    return (float)f.n / f.d;
}

static float avifUnsignedFractionToFloat(avifUnsignedFraction f)
{
    if (f.d == 0) {
        return 0.0f;
    }
    return (float)f.n / f.d;
}

// ---------------------------------------------------------------------------
// Apply a gain map.

// Returns a weight in [-1.0, 1.0] that represents how much the gain map should be applied.
static float avifGetGainMapWeight(float hdrHeadroom, const avifGainMap * gainMap)
{
    const float baseHdrHeadroom = avifUnsignedFractionToFloat(gainMap->baseHdrHeadroom);
    const float alternateHdrHeadroom = avifUnsignedFractionToFloat(gainMap->alternateHdrHeadroom);
    if (baseHdrHeadroom == alternateHdrHeadroom) {
        // Do not apply the gain map if the HDR headroom is the same.
        // This case is not handled in the specification and does not make practical sense.
        return 0.0f;
    }
    const float w = AVIF_CLAMP((hdrHeadroom - baseHdrHeadroom) / (alternateHdrHeadroom - baseHdrHeadroom), 0.0f, 1.0f);
    return (alternateHdrHeadroom < baseHdrHeadroom) ? -w : w;
}

// Linear interpolation between 'a' and 'b' (returns 'a' if w == 0.0f, returns 'b' if w == 1.0f).
static inline float lerp(float a, float b, float w)
{
    return (1.0f - w) * a + w * b;
}

#define SDR_WHITE_NITS 203.0f

avifResult avifRGBImageApplyGainMap(const avifRGBImage * baseImage,
                                    avifColorPrimaries baseColorPrimaries,
                                    avifTransferCharacteristics baseTransferCharacteristics,
                                    const avifGainMap * gainMap,
                                    float hdrHeadroom,
                                    avifColorPrimaries outputColorPrimaries,
                                    avifTransferCharacteristics outputTransferCharacteristics,
                                    avifRGBImage * toneMappedImage,
                                    avifContentLightLevelInformationBox * clli,
                                    avifDiagnostics * diag)
{
    avifDiagnosticsClearError(diag);

    if (hdrHeadroom < 0.0f) {
        avifDiagnosticsPrintf(diag, "hdrHeadroom should be >= 0, got %f", hdrHeadroom);
        return AVIF_RESULT_INVALID_ARGUMENT;
    }
    if (baseImage == NULL || gainMap == NULL || toneMappedImage == NULL) {
        avifDiagnosticsPrintf(diag, "NULL input image");
        return AVIF_RESULT_INVALID_ARGUMENT;
    }
    AVIF_CHECKRES(avifGainMapValidateMetadata(gainMap, diag));

    const uint32_t width = baseImage->width;
    const uint32_t height = baseImage->height;

    const avifBool useBaseColorSpace = gainMap->useBaseColorSpace;
    const avifColorPrimaries gainMapMathPrimaries =
        (useBaseColorSpace || (gainMap->altColorPrimaries == AVIF_COLOR_PRIMARIES_UNSPECIFIED)) ? baseColorPrimaries
                                                                                                : gainMap->altColorPrimaries;
    const avifBool needsInputColorConversion = (baseColorPrimaries != gainMapMathPrimaries);
    const avifBool needsOutputColorConversion = (gainMapMathPrimaries != outputColorPrimaries);

    avifImage * rescaledGainMap = NULL;
    avifRGBImage rgbGainMap;
    // Basic zero-initialization for now, avifRGBImageSetDefaults() is called later on.
    memset(&rgbGainMap, 0, sizeof(rgbGainMap));

    avifResult res = AVIF_RESULT_OK;
    toneMappedImage->width = width;
    toneMappedImage->height = height;
    AVIF_CHECKRES(avifRGBImageAllocatePixels(toneMappedImage));

    // --- After this point, the function should exit with 'goto cleanup' to free allocated pixels.

    const float weight = avifGetGainMapWeight(hdrHeadroom, gainMap);

    // Early exit if the gain map does not need to be applied and the pixel format is the same.
    if (weight == 0.0f && outputTransferCharacteristics == baseTransferCharacteristics &&
        outputColorPrimaries == baseColorPrimaries && baseImage->format == toneMappedImage->format &&
        baseImage->depth == toneMappedImage->depth && baseImage->isFloat == toneMappedImage->isFloat) {
        assert(baseImage->rowBytes == toneMappedImage->rowBytes);
        assert(baseImage->height == toneMappedImage->height);
        // Copy the base image.
        memcpy(toneMappedImage->pixels, baseImage->pixels, baseImage->rowBytes * baseImage->height);
        goto cleanup;
    }

    avifRGBColorSpaceInfo baseRGBInfo;
    avifRGBColorSpaceInfo toneMappedPixelRGBInfo;
    if (!avifGetRGBColorSpaceInfo(baseImage, &baseRGBInfo) || !avifGetRGBColorSpaceInfo(toneMappedImage, &toneMappedPixelRGBInfo)) {
        avifDiagnosticsPrintf(diag, "Unsupported RGB color space");
        res = AVIF_RESULT_NOT_IMPLEMENTED;
        goto cleanup;
    }

    const avifTransferFunction gammaToLinear = avifTransferCharacteristicsGetGammaToLinearFunction(baseTransferCharacteristics);
    const avifTransferFunction linearToGamma = avifTransferCharacteristicsGetLinearToGammaFunction(outputTransferCharacteristics);

    // Early exit if the gain map does not need to be applied.
    if (weight == 0.0f) {
        const avifBool primariesDiffer = (baseColorPrimaries != outputColorPrimaries);
        double conversionCoeffs[3][3];
        if (primariesDiffer && !avifColorPrimariesComputeRGBToRGBMatrix(baseColorPrimaries, outputColorPrimaries, conversionCoeffs)) {
            avifDiagnosticsPrintf(diag, "Unsupported RGB color space conversion");
            res = AVIF_RESULT_NOT_IMPLEMENTED;
            goto cleanup;
        }
        // Just convert from one rgb format to another.
        for (uint32_t j = 0; j < height; ++j) {
            for (uint32_t i = 0; i < width; ++i) {
                float basePixelRGBA[4];
                avifGetRGBAPixel(baseImage, i, j, &baseRGBInfo, basePixelRGBA);
                if (outputTransferCharacteristics != baseTransferCharacteristics || primariesDiffer) {
                    for (int c = 0; c < 3; ++c) {
                        basePixelRGBA[c] = gammaToLinear(basePixelRGBA[c]);
                    }
                    if (primariesDiffer) {
                        avifLinearRGBConvertColorSpace(basePixelRGBA, conversionCoeffs);
                    }
                    for (int c = 0; c < 3; ++c) {
                        basePixelRGBA[c] = AVIF_CLAMP(linearToGamma(basePixelRGBA[c]), 0.0f, 1.0f);
                    }
                }
                avifSetRGBAPixel(toneMappedImage, i, j, &toneMappedPixelRGBInfo, basePixelRGBA);
            }
        }
        goto cleanup;
    }

    double inputConversionCoeffs[3][3];
    double outputConversionCoeffs[3][3];
    if (needsInputColorConversion &&
        !avifColorPrimariesComputeRGBToRGBMatrix(baseColorPrimaries, gainMapMathPrimaries, inputConversionCoeffs)) {
        avifDiagnosticsPrintf(diag, "Unsupported RGB color space conversion");
        res = AVIF_RESULT_NOT_IMPLEMENTED;
        goto cleanup;
    }
    if (needsOutputColorConversion &&
        !avifColorPrimariesComputeRGBToRGBMatrix(gainMapMathPrimaries, outputColorPrimaries, outputConversionCoeffs)) {
        avifDiagnosticsPrintf(diag, "Unsupported RGB color space conversion");
        res = AVIF_RESULT_NOT_IMPLEMENTED;
        goto cleanup;
    }

    if (gainMap->image->width != width || gainMap->image->height != height) {
        rescaledGainMap = avifImageCreateEmpty();
        const avifCropRect rect = { 0, 0, gainMap->image->width, gainMap->image->height };
        res = avifImageSetViewRect(rescaledGainMap, gainMap->image, &rect);
        if (res != AVIF_RESULT_OK) {
            goto cleanup;
        }
        res = avifImageScale(rescaledGainMap, width, height, diag);
        if (res != AVIF_RESULT_OK) {
            goto cleanup;
        }
    }
    const avifImage * const gainMapImage = (rescaledGainMap != NULL) ? rescaledGainMap : gainMap->image;

    avifRGBImageSetDefaults(&rgbGainMap, gainMapImage);
    res = avifRGBImageAllocatePixels(&rgbGainMap);
    if (res != AVIF_RESULT_OK) {
        goto cleanup;
    }
    res = avifImageYUVToRGB(gainMapImage, &rgbGainMap);
    if (res != AVIF_RESULT_OK) {
        goto cleanup;
    }

    avifRGBColorSpaceInfo gainMapRGBInfo;
    if (!avifGetRGBColorSpaceInfo(&rgbGainMap, &gainMapRGBInfo)) {
        avifDiagnosticsPrintf(diag, "Unsupported RGB color space");
        res = AVIF_RESULT_NOT_IMPLEMENTED;
        goto cleanup;
    }

    float rgbMaxLinear = 0; // Max tone mapped pixel value across R, G and B channels.
    float rgbSumLinear = 0; // Sum of max(r, g, b) for mapped pixels.
    // The gain map metadata contains the encoding gamma, and 1/gamma should be used for decoding.
    const float gammaInv[3] = { 1.0f / avifUnsignedFractionToFloat(gainMap->gainMapGamma[0]),
                                1.0f / avifUnsignedFractionToFloat(gainMap->gainMapGamma[1]),
                                1.0f / avifUnsignedFractionToFloat(gainMap->gainMapGamma[2]) };
    const float gainMapMin[3] = { avifSignedFractionToFloat(gainMap->gainMapMin[0]),
                                  avifSignedFractionToFloat(gainMap->gainMapMin[1]),
                                  avifSignedFractionToFloat(gainMap->gainMapMin[2]) };
    const float gainMapMax[3] = { avifSignedFractionToFloat(gainMap->gainMapMax[0]),
                                  avifSignedFractionToFloat(gainMap->gainMapMax[1]),
                                  avifSignedFractionToFloat(gainMap->gainMapMax[2]) };
    const float baseOffset[3] = { avifSignedFractionToFloat(gainMap->baseOffset[0]),
                                  avifSignedFractionToFloat(gainMap->baseOffset[1]),
                                  avifSignedFractionToFloat(gainMap->baseOffset[2]) };
    const float alternateOffset[3] = { avifSignedFractionToFloat(gainMap->alternateOffset[0]),
                                       avifSignedFractionToFloat(gainMap->alternateOffset[1]),
                                       avifSignedFractionToFloat(gainMap->alternateOffset[2]) };
    for (uint32_t j = 0; j < height; ++j) {
        for (uint32_t i = 0; i < width; ++i) {
            float basePixelRGBA[4];
            avifGetRGBAPixel(baseImage, i, j, &baseRGBInfo, basePixelRGBA);
            float gainMapRGBA[4];
            avifGetRGBAPixel(&rgbGainMap, i, j, &gainMapRGBInfo, gainMapRGBA);

            // Apply gain map.
            float toneMappedPixelRGBA[4];
            float pixelRgbMaxLinear = 0.0f; //  = max(r, g, b) for this pixel

            for (int c = 0; c < 3; ++c) {
                basePixelRGBA[c] = gammaToLinear(basePixelRGBA[c]);
            }

            if (needsInputColorConversion) {
                // Convert basePixelRGBA to gainMapMathPrimaries.
                avifLinearRGBConvertColorSpace(basePixelRGBA, inputConversionCoeffs);
            }

            for (int c = 0; c < 3; ++c) {
                const float baseLinear = basePixelRGBA[c];
                const float gainMapValue = gainMapRGBA[c];

                // Undo gamma & affine transform; the result is in log2 space.
                const float gainMapLog2 = lerp(gainMapMin[c], gainMapMax[c], powf(gainMapValue, gammaInv[c]));
                const float toneMappedLinear = (baseLinear + baseOffset[c]) * exp2f(gainMapLog2 * weight) - alternateOffset[c];

                if (toneMappedLinear > rgbMaxLinear) {
                    rgbMaxLinear = toneMappedLinear;
                }
                if (toneMappedLinear > pixelRgbMaxLinear) {
                    pixelRgbMaxLinear = toneMappedLinear;
                }

                toneMappedPixelRGBA[c] = toneMappedLinear;
            }

            if (needsOutputColorConversion) {
                // Convert toneMappedPixelRGBA to outputColorPrimaries.
                avifLinearRGBConvertColorSpace(toneMappedPixelRGBA, outputConversionCoeffs);
            }

            for (int c = 0; c < 3; ++c) {
                toneMappedPixelRGBA[c] = AVIF_CLAMP(linearToGamma(toneMappedPixelRGBA[c]), 0.0f, 1.0f);
            }

            toneMappedPixelRGBA[3] = basePixelRGBA[3]; // Alpha is unaffected by tone mapping.
            rgbSumLinear += pixelRgbMaxLinear;
            avifSetRGBAPixel(toneMappedImage, i, j, &toneMappedPixelRGBInfo, toneMappedPixelRGBA);
        }
    }
    if (clli != NULL) {
        // For exact CLLI value definitions, see ISO/IEC 23008-2 section D.3.35
        // at https://standards.iso.org/ittf/PubliclyAvailableStandards/index.html
        // See also discussion in https://github.com/AOMediaCodec/libavif/issues/1727

        // Convert extended SDR (where 1.0 is SDR white) to nits.
        clli->maxCLL = (uint16_t)AVIF_CLAMP(avifRoundf(rgbMaxLinear * SDR_WHITE_NITS), 0.0f, (float)UINT16_MAX);
        const float rgbAverageLinear = rgbSumLinear / (width * height);
        clli->maxPALL = (uint16_t)AVIF_CLAMP(avifRoundf(rgbAverageLinear * SDR_WHITE_NITS), 0.0f, (float)UINT16_MAX);
    }

cleanup:
    avifRGBImageFreePixels(&rgbGainMap);
    if (rescaledGainMap != NULL) {
        avifImageDestroy(rescaledGainMap);
    }

    return res;
}

avifResult avifImageApplyGainMap(const avifImage * baseImage,
                                 const avifGainMap * gainMap,
                                 float hdrHeadroom,
                                 avifColorPrimaries outputColorPrimaries,
                                 avifTransferCharacteristics outputTransferCharacteristics,
                                 avifRGBImage * toneMappedImage,
                                 avifContentLightLevelInformationBox * clli,
                                 avifDiagnostics * diag)
{
    avifDiagnosticsClearError(diag);

    if (baseImage->icc.size > 0 || gainMap->altICC.size > 0) {
        avifDiagnosticsPrintf(diag, "Tone mapping for images with ICC profiles is not supported");
        return AVIF_RESULT_NOT_IMPLEMENTED;
    }

    avifRGBImage baseImageRgb;
    avifRGBImageSetDefaults(&baseImageRgb, baseImage);
    AVIF_CHECKRES(avifRGBImageAllocatePixels(&baseImageRgb));
    avifResult res = avifImageYUVToRGB(baseImage, &baseImageRgb);
    if (res != AVIF_RESULT_OK) {
        goto cleanup;
    }

    res = avifRGBImageApplyGainMap(&baseImageRgb,
                                   baseImage->colorPrimaries,
                                   baseImage->transferCharacteristics,
                                   gainMap,
                                   hdrHeadroom,
                                   outputColorPrimaries,
                                   outputTransferCharacteristics,
                                   toneMappedImage,
                                   clli,
                                   diag);

cleanup:
    avifRGBImageFreePixels(&baseImageRgb);

    return res;
}

// ---------------------------------------------------------------------------
// Create a gain map.

// Returns the index of the histogram bucket for a given value, for a histogram with 'numBuckets' buckets,
// and values ranging in [bucketMin, bucketMax] (values outside of the range are added to the first/last buckets).
static int avifValueToBucketIdx(float v, float bucketMin, float bucketMax, int numBuckets)
{
    v = AVIF_CLAMP(v, bucketMin, bucketMax);
    return AVIF_MIN((int)avifRoundf((v - bucketMin) / (bucketMax - bucketMin) * numBuckets), numBuckets - 1);
}
// Returns the lower end of the value range belonging to the given histogram bucket.
static float avifBucketIdxToValue(int idx, float bucketMin, float bucketMax, int numBuckets)
{
    return idx * (bucketMax - bucketMin) / numBuckets + bucketMin;
}

avifResult avifFindMinMaxWithoutOutliers(const float * gainMapF, int numPixels, float * rangeMin, float * rangeMax)
{
    const float bucketSize = 0.01f;        // Size of one bucket. Empirical value.
    const float maxOutliersRatio = 0.001f; // 0.1%
    const int maxOutliersOnEachSide = (int)avifRoundf(numPixels * maxOutliersRatio / 2.0f);

    float min = gainMapF[0];
    float max = gainMapF[0];
    for (int i = 1; i < numPixels; ++i) {
        min = AVIF_MIN(min, gainMapF[i]);
        max = AVIF_MAX(max, gainMapF[i]);
    }

    *rangeMin = min;
    *rangeMax = max;
    if ((max - min) <= (bucketSize * 2) || maxOutliersOnEachSide == 0) {
        return AVIF_RESULT_OK;
    }

    const int maxNumBuckets = 10000;
    const int numBuckets = AVIF_MIN((int)ceilf((max - min) / bucketSize), maxNumBuckets);
    int * histogram = avifAlloc(sizeof(int) * numBuckets);
    if (histogram == NULL) {
        return AVIF_RESULT_OUT_OF_MEMORY;
    }
    memset(histogram, 0, sizeof(int) * numBuckets);
    for (int i = 0; i < numPixels; ++i) {
        ++(histogram[avifValueToBucketIdx(gainMapF[i], min, max, numBuckets)]);
    }

    int leftOutliers = 0;
    for (int i = 0; i < numBuckets; ++i) {
        leftOutliers += histogram[i];
        if (leftOutliers > maxOutliersOnEachSide) {
            break;
        }
        if (histogram[i] == 0) {
            // +1 to get the higher end of the bucket.
            *rangeMin = avifBucketIdxToValue(i + 1, min, max, numBuckets);
        }
    }

    int rightOutliers = 0;
    for (int i = numBuckets - 1; i >= 0; --i) {
        rightOutliers += histogram[i];
        if (rightOutliers > maxOutliersOnEachSide) {
            break;
        }
        if (histogram[i] == 0) {
            *rangeMax = avifBucketIdxToValue(i, min, max, numBuckets);
        }
    }

    avifFree(histogram);
    return AVIF_RESULT_OK;
}

avifResult avifGainMapValidateMetadata(const avifGainMap * gainMap, avifDiagnostics * diag)
{
    for (int i = 0; i < 3; ++i) {
        if (gainMap->gainMapMin[i].d == 0 || gainMap->gainMapMax[i].d == 0 || gainMap->gainMapGamma[i].d == 0 ||
            gainMap->baseOffset[i].d == 0 || gainMap->alternateOffset[i].d == 0) {
            avifDiagnosticsPrintf(diag, "Per-channel denominator is 0 in gain map metadata");
            return AVIF_RESULT_INVALID_ARGUMENT;
        }
        if ((int64_t)gainMap->gainMapMax[i].n * gainMap->gainMapMin[i].d <
            (int64_t)gainMap->gainMapMin[i].n * gainMap->gainMapMax[i].d) {
            avifDiagnosticsPrintf(diag, "Per-channel max is less than per-channel min in gain map metadata");
            return AVIF_RESULT_INVALID_ARGUMENT;
        }
        if (gainMap->gainMapGamma[i].n == 0) {
            avifDiagnosticsPrintf(diag, "Per-channel gamma is 0 in gain map metadata");
            return AVIF_RESULT_INVALID_ARGUMENT;
        }
    }
    if (gainMap->baseHdrHeadroom.d == 0 || gainMap->alternateHdrHeadroom.d == 0) {
        avifDiagnosticsPrintf(diag, "Headroom denominator is 0 in gain map metadata");
        return AVIF_RESULT_INVALID_ARGUMENT;
    }
    if (gainMap->useBaseColorSpace != 0 && gainMap->useBaseColorSpace != 1) {
        avifDiagnosticsPrintf(diag, "useBaseColorSpace is %d in gain map metadata", gainMap->useBaseColorSpace);
        return AVIF_RESULT_INVALID_ARGUMENT;
    }
    return AVIF_RESULT_OK;
}

avifBool avifSameGainMapMetadata(const avifGainMap * a, const avifGainMap * b)
{
    if (a->baseHdrHeadroom.n != b->baseHdrHeadroom.n || a->baseHdrHeadroom.d != b->baseHdrHeadroom.d ||
        a->alternateHdrHeadroom.n != b->alternateHdrHeadroom.n || a->alternateHdrHeadroom.d != b->alternateHdrHeadroom.d) {
        return AVIF_FALSE;
    }
    for (int c = 0; c < 3; ++c) {
        if (a->gainMapMin[c].n != b->gainMapMin[c].n || a->gainMapMin[c].d != b->gainMapMin[c].d ||
            a->gainMapMax[c].n != b->gainMapMax[c].n || a->gainMapMax[c].d != b->gainMapMax[c].d ||
            a->gainMapGamma[c].n != b->gainMapGamma[c].n || a->gainMapGamma[c].d != b->gainMapGamma[c].d ||
            a->baseOffset[c].n != b->baseOffset[c].n || a->baseOffset[c].d != b->baseOffset[c].d ||
            a->alternateOffset[c].n != b->alternateOffset[c].n || a->alternateOffset[c].d != b->alternateOffset[c].d) {
            return AVIF_FALSE;
        }
    }
    return AVIF_TRUE;
}

avifBool avifSameGainMapAltMetadata(const avifGainMap * a, const avifGainMap * b)
{
    if (a->altICC.size != b->altICC.size || memcmp(a->altICC.data, b->altICC.data, a->altICC.size) != 0 ||
        a->altColorPrimaries != b->altColorPrimaries || a->altTransferCharacteristics != b->altTransferCharacteristics ||
        a->altMatrixCoefficients != b->altMatrixCoefficients || a->altYUVRange != b->altYUVRange || a->altDepth != b->altDepth ||
        a->altPlaneCount != b->altPlaneCount || a->altCLLI.maxCLL != b->altCLLI.maxCLL || a->altCLLI.maxPALL != b->altCLLI.maxPALL) {
        return AVIF_FALSE;
    }
    return AVIF_TRUE;
}

static const float kEpsilon = 1e-10f;

// Decides which of 'basePrimaries' or 'altPrimaries' should be used for doing gain map math when creating a gain map.
// The other image (base or alternate) will be converted to this color space before computing
// the ratio between the two images.
// If a pixel color is outside of the target color space, some of the converted channel values will be negative.
// This should be avoided, as the negative values must either be clamped or offset before computing the log2()
// (since log2 only works on > 0 values). But a large offset causes artefacts when partially applying the gain map.
// Therefore we want to do gain map math in the larger of the two color spaces.
static avifResult avifChooseColorSpaceForGainMapMath(avifColorPrimaries basePrimaries,
                                                     avifColorPrimaries altPrimaries,
                                                     avifColorPrimaries * gainMapMathColorSpace)
{
    if (basePrimaries == altPrimaries) {
        *gainMapMathColorSpace = basePrimaries;
        return AVIF_RESULT_OK;
    }
    // Color convert pure red, pure green and pure blue in turn and see if they result in negative values.
    float rgba[4] = { 0 };
    double baseToAltCoeffs[3][3];
    double altToBaseCoeffs[3][3];
    if (!avifColorPrimariesComputeRGBToRGBMatrix(basePrimaries, altPrimaries, baseToAltCoeffs) ||
        !avifColorPrimariesComputeRGBToRGBMatrix(altPrimaries, basePrimaries, altToBaseCoeffs)) {
        return AVIF_RESULT_NOT_IMPLEMENTED;
    }

    float baseColorspaceChannelMin = 0;
    float altColorspaceChannelMin = 0;
    for (int c = 0; c < 3; ++c) {
        rgba[0] = rgba[1] = rgba[2] = 0;
        rgba[c] = 1.0f;
        avifLinearRGBConvertColorSpace(rgba, altToBaseCoeffs);
        for (int i = 0; i < 3; ++i) {
            baseColorspaceChannelMin = AVIF_MIN(baseColorspaceChannelMin, rgba[i]);
        }
        rgba[0] = rgba[1] = rgba[2] = 0;
        rgba[c] = 1.0f;
        avifLinearRGBConvertColorSpace(rgba, baseToAltCoeffs);
        for (int i = 0; i < 3; ++i) {
            altColorspaceChannelMin = AVIF_MIN(altColorspaceChannelMin, rgba[i]);
        }
    }
    // Pick the colorspace that has the largest min value (which is more or less the largest color space).
    *gainMapMathColorSpace = (altColorspaceChannelMin <= baseColorspaceChannelMin) ? basePrimaries : altPrimaries;
    return AVIF_RESULT_OK;
}

// avifRGBImageComputeGainMap removed - encoding function not needed for decoding
// avifImageComputeGainMap removed - encoding function not needed for decoding
// HDR functionality is preserved (avifImageApplyGainMap is kept)

// avifImageComputeGainMap removed - encoding function not needed for decoding