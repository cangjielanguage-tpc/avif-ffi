//
// Created on 2025/8/19.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

//#include <algorithm>
#include <hilog/log.h>
#include <stdio.h>
#include <stdlib.h>
//#include <memory>
//#include <new>

#include "../include/avif/avif.h"

//#define LOG_TAG "avif_cj"
//#define LOGE(...) \
//  ((void)__android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__))


//namespace {
 //RAII wrapper class that properly frees the decoder related objects on
 //destruction.
//struct AvifDecoderWrapper {
//
// public:
//  AvifDecoderWrapper() = default;
//  // Not copyable or movable.
//  AvifDecoderWrapper(const AvifDecoderWrapper&) = delete;
//  AvifDecoderWrapper& operator=(const AvifDecoderWrapper&) = delete;
//
//  ~AvifDecoderWrapper() {
//    if (decoder != nullptr) {
//      avifDecoderDestroy(decoder);
//    }
//  }
//
//  avifDecoder* decoder = nullptr;
//  avifCropRect crop;
//};

bool CreateDecoderAndParse(AvifDecoderWrapper* const decoder,
                           const uint8_t* const buffer, int length,
                           int threads) {
  decoder->decoder = avifDecoderCreate();
  if (decoder->decoder == NULL) {
    //LOGE("Failed to create AVIF Decoder.");
    return false;
  }
  decoder->decoder->maxThreads = threads;
  decoder->decoder->ignoreXMP = AVIF_TRUE;
  decoder->decoder->ignoreExif = AVIF_TRUE;

  // Turn off libavif's 'clap' (clean aperture) property validation. This allows
  // us to detect and ignore streams that have an invalid 'clap' property
  // instead failing.
  decoder->decoder->strictFlags &= ~AVIF_STRICT_CLAP_VALID;
  // Allow 'pixi' (pixel information) property to be missing. Older versions of
  // libheif did not add the 'pixi' item property to AV1 image items (See
  // crbug.com/1198455).
  decoder->decoder->strictFlags &= ~AVIF_STRICT_PIXI_REQUIRED;

  avifResult res = avifDecoderSetIOMemory(decoder->decoder, buffer, length);
  if (res != AVIF_RESULT_OK) {
    //LOGE("Failed to set AVIF IO to a memory reader.");
    return false;
  }
  res = avifDecoderParse(decoder->decoder);
  if (res != AVIF_RESULT_OK) {
    //LOGE("Failed to parse AVIF image: %s.", avifResultToString(res));
    return false;
  }

  avifDiagnostics diag;
  // If the image does not have a valid 'clap' property, then we simply display
  // the whole image.
  // TODO(vigneshv): Handle the case of avifCropRectRequiresUpsampling()
  //                 returning true.
  if (!(decoder->decoder->image->transformFlags & AVIF_TRANSFORM_CLAP) ||
      !avifCropRectFromCleanApertureBox(
          &decoder->crop, &decoder->decoder->image->clap,
          decoder->decoder->image->width, decoder->decoder->image->height,
          &diag) ||
      avifCropRectRequiresUpsampling(&decoder->crop,
                                     decoder->decoder->image->yuvFormat)) {
    decoder->crop.width = decoder->decoder->image->width;
    decoder->crop.height = decoder->decoder->image->height;
    decoder->crop.x = 0;
    decoder->crop.y = 0;
  }
  return true;
}

avifResult AvifImageToBitmap(AvifDecoderWrapper* const decoder,uint8_t* bitmap_pixels,uint32_t picwidth,uint32_t picheight,uint32_t stride,uint32_t formatvalue) {
  //AndroidBitmapInfo bitmap_info;
//  if (AndroidBitmap_getInfo(env, bitmap, &bitmap_info) < 0) {
//    LOGE("AndroidBitmap_getInfo failed.");
//    return AVIF_RESULT_UNKNOWN_ERROR;
//  }
  // Ensure that the bitmap format is RGBA_8888, RGB_565 or RGBA_F16.
//  if (bitmap_info.format != ANDROID_BITMAP_FORMAT_RGBA_8888 &&
//      bitmap_info.format != ANDROID_BITMAP_FORMAT_RGB_565 &&
//      bitmap_info.format != ANDROID_BITMAP_FORMAT_RGBA_F16) {
//    LOGE("Bitmap format (%d) is not supported.", bitmap_info.format);
//    return AVIF_RESULT_NOT_IMPLEMENTED;
//  }
//  void* bitmap_pixels = nullptr;
//  if (AndroidBitmap_lockPixels(env, bitmap, &bitmap_pixels) !=
//      ANDROID_BITMAP_RESULT_SUCCESS) {
//    LOGE("Failed to lock Bitmap.");
//    return AVIF_RESULT_UNKNOWN_ERROR;
//  }
  //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "----- AvifImageToBitmap 1");
  avifImage* image;
  //std::unique_ptr<avifImage, decltype(&avifImageDestroy)> cropped_image(nullptr, avifImageDestroy);
  avifImage* cropped_image = NULL;
  avifResult res;
  if (decoder->decoder->image->width == decoder->crop.width &&
      decoder->decoder->image->height == decoder->crop.height &&
      decoder->crop.x == 0 && decoder->crop.y == 0) {
    //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "----- AvifImageToBitmap 2");
    image = decoder->decoder->image;
  } else {
    cropped_image = avifImageCreateEmpty();
    if (cropped_image == NULL) {
      //LOGE("Failed to allocate cropped image.");
      return AVIF_RESULT_OUT_OF_MEMORY;
    }
    res = avifImageSetViewRect(cropped_image, decoder->decoder->image,
                               &decoder->crop);
    if (res != AVIF_RESULT_OK) {
      //LOGE("Failed to set crop rectangle. Status: %d", res);
      return res;
    }
    //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "----- AvifImageToBitmap 3");
    image = cropped_image;
  }
  //std::unique_ptr<avifImage, decltype(&avifImageDestroy)> image_copy(nullptr, avifImageDestroy);
   avifImage* image_copy = NULL;
  if (image->width != picwidth ||
      image->height != picheight) {
    // If the avifImage does not own the planes, then create a copy for safe
    // scaling.
    if (!image->imageOwnsYUVPlanes || !image->imageOwnsAlphaPlane) {
      //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "----- AvifImageToBitmap 4");
      image_copy = avifImageCreateEmpty();
      if (image_copy == NULL) {
        //LOGE("Failed to allocate image for scaling.");
        return AVIF_RESULT_OUT_OF_MEMORY;
      }
      res = avifImageCopy(image_copy, image, AVIF_PLANES_ALL);
      if (res != AVIF_RESULT_OK) {
        //LOGE("Failed to make a copy of the image for scaling. Status: %d", res);
        return res;
      }
      image = image_copy;
    }
    avifDiagnostics diag;
    //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "----- AvifImageToBitmap 5");
    res = avifImageScale(image, picwidth, picheight, &diag);
    if (res != AVIF_RESULT_OK) {
      //LOGE("Failed to scale image. Status: %d", res);
      return res;
    }
  }

  avifRGBImage rgb_image;
  avifRGBImageSetDefaults(&rgb_image, image);
  //RGBA_F16 0  //RGB_565 1 //else 2  
  if (formatvalue == 0) {
    //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "----- AvifImageToBitmap 6");
    rgb_image.depth = 16;
    rgb_image.isFloat = AVIF_TRUE;
  } else if (formatvalue == 1) {
    //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "----- AvifImageToBitmap 7");
    rgb_image.format = AVIF_RGB_FORMAT_RGB_565;
    rgb_image.depth = 8;
  } else {
    //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "----- AvifImageToBitmap 8");
    rgb_image.depth = 8;
  }
  rgb_image.pixels = bitmap_pixels;
  rgb_image.rowBytes = stride;
  // Android always sees the Bitmaps as premultiplied with alpha when it renders
  // them:
  // https://developer.android.com/reference/android/graphics/Bitmap#setPremultiplied(boolean)
  rgb_image.alphaPremultiplied = AVIF_TRUE;
  res = avifImageYUVToRGB(image, &rgb_image);
  //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "----- AvifImageToBitmap 9");
  //AndroidBitmap_unlockPixels(env, bitmap);
  if (res != AVIF_RESULT_OK) {
    //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "----- AvifImageToBitmap 10");
    //LOGE("Failed to convert YUV Pixels to RGB. Status: %d", res);
    return res;
  }
  //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "----- AvifImageToBitmap 11");
  return AVIF_RESULT_OK;
}


avifResult DecodeNextImage(AvifDecoderWrapper* const decoder,uint8_t* pixelmap,uint32_t picwidth,uint32_t picheight,uint32_t stride,uint32_t formatvalue) {
    //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "-----  bbbbbb ");
    avifResult res = avifDecoderNextImage(decoder->decoder);
    if (res != AVIF_RESULT_OK) {
    //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "-----  bbbbbbbbb11_%{public}d",res);
    //LOGE("Failed to decode AVIF image. Status: %d", res);
    return res;
  }
  //OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "avif", "-----  cccccc ");
  return AvifImageToBitmap(decoder, pixelmap,picwidth,picheight,stride,formatvalue);
}



avifResult DecodeNthImage(AvifDecoderWrapper* const decoder,uint32_t n,uint8_t* pixelmap,uint32_t picwidth,uint32_t picheight,uint32_t stride,uint32_t formatvalue) {
  avifResult res = avifDecoderNthImage(decoder->decoder, n);
  if (res != AVIF_RESULT_OK) {
    //LOGE("Failed to decode AVIF image. Status: %d", res);
    return res;
  }
  return AvifImageToBitmap( decoder, pixelmap,picwidth,picheight,stride,formatvalue);
}
//
//int getThreadCount(int threads) {
//  if (threads < 0) {
//    return android_getCpuCount();
//  }
//  if (threads == 0) {
//    // Empirically, on Android devices with more than 1 core, decoding with 2
//    // threads is almost always better than using as many threads as CPU cores.
//    return std::min(android_getCpuCount(), 2);
//  }
//  return threads;
//}
//
//// Checks if there is a pending JNI exception that will be thrown when the
//// control returns to the java layer. If there is none, it will return false. If
//// there is one, then it will clear the pending exception and return true.
//// Whenever this function returns true, the caller should treat it as a fatal
//// error and return with a failure status as early as possible.
//bool JniExceptionCheck(JNIEnv* env) {
//  if (!env->ExceptionCheck()) {
//    return false;
//  }
//  env->ExceptionClear();
//  return true;
//}

//}




