//
// Created on 2025/8/19.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

//#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
//#include <memory>
//#include <new>

#include "../include/avif/avif.h"

//#define LOG_TAG "avif_cj"
//#define LOGE(...) \
//  ((void)__android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__))



bool CreateDecoderAndParse(AvifDecoderWrapper* const decoder,
                           const uint8_t* const buffer, int length,
                           int threads) {
  decoder->decoder = avifDecoderCreate();
  if (decoder->decoder == NULL) {
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
    if(decoder->decoder != NULL){
        avifDecoderDestroy(decoder->decoder);
    }    
    decoder->decoder = NULL;
    return false;
  }
  res = avifDecoderParse(decoder->decoder);
  if (res != AVIF_RESULT_OK) {
     if(decoder->decoder != NULL){
         avifDecoderDestroy(decoder->decoder);
     }    
     decoder->decoder = NULL;
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
  avifImage* image;
  avifImage* cropped_image = NULL;
  avifResult res;
  if (decoder->decoder->image->width == decoder->crop.width &&
      decoder->decoder->image->height == decoder->crop.height &&
      decoder->crop.x == 0 && decoder->crop.y == 0) {
    image = decoder->decoder->image;
  } else {
    cropped_image = avifImageCreateEmpty();
    if (cropped_image == NULL) {
      return AVIF_RESULT_OUT_OF_MEMORY;
    }
    res = avifImageSetViewRect(cropped_image, decoder->decoder->image,
                               &decoder->crop);
    if (res != AVIF_RESULT_OK) {
      if(cropped_image != NULL){
          avifImageDestroy(cropped_image);
      }      
      return res;
    }
    image = cropped_image;
  }
  //std::unique_ptr<avifImage, decltype(&avifImageDestroy)> image_copy(nullptr, avifImageDestroy);
   avifImage* image_copy = NULL;
  if (image->width != picwidth ||
      image->height != picheight) {
    // If the avifImage does not own the planes, then create a copy for safe
    // scaling.
    if (!image->imageOwnsYUVPlanes || !image->imageOwnsAlphaPlane) {
      image_copy = avifImageCreateEmpty();
      if (image_copy == NULL) {
        return AVIF_RESULT_OUT_OF_MEMORY;
      }
      res = avifImageCopy(image_copy, image, AVIF_PLANES_ALL);
      if (res != AVIF_RESULT_OK) {
        if(image_copy != NULL){
            avifImageDestroy(image_copy);
        }        
        return res;
      }
      image = image_copy;
    }
    avifDiagnostics diag;
    res = avifImageScale(image, picwidth, picheight, &diag);
    if (res != AVIF_RESULT_OK) {
      if(cropped_image != NULL){
          avifImageDestroy(cropped_image);
      }
      if(image_copy != NULL){
          avifImageDestroy(image_copy);
      }
      return res;
    }
  }

  avifRGBImage rgb_image;
  avifRGBImageSetDefaults(&rgb_image, image);
  //RGBA_F16 0  //RGB_565 1 //else 2  
  if (formatvalue == 0) {
    rgb_image.depth = 16;
    rgb_image.isFloat = AVIF_TRUE;
  } else if (formatvalue == 1) {
    rgb_image.format = AVIF_RGB_FORMAT_RGB_565;
    rgb_image.depth = 8;
  } else {
    rgb_image.depth = 8;
  }
  rgb_image.pixels = bitmap_pixels;
  rgb_image.rowBytes = stride;
  // Android always sees the Bitmaps as premultiplied with alpha when it renders
  // them:
  // https://developer.android.com/reference/android/graphics/Bitmap#setPremultiplied(boolean)
  rgb_image.alphaPremultiplied = AVIF_FALSE;
  res = avifImageYUVToRGB(image, &rgb_image);
  // 新增：释放临时图像
  if (cropped_image != NULL) {
    avifImageDestroy(cropped_image);
  }
  if (image_copy != NULL) {
    avifImageDestroy(image_copy);
  }  
  return res;  
}


avifResult DecodeNextImage(AvifDecoderWrapper* const decoder,uint8_t* pixelmap,uint32_t picwidth,uint32_t picheight,uint32_t stride,uint32_t formatvalue) {
    avifResult res = avifDecoderNextImage(decoder->decoder);
    if (res != AVIF_RESULT_OK) {
    return res;
  }
  return AvifImageToBitmap(decoder, pixelmap,picwidth,picheight,stride,formatvalue);
}



avifResult DecodeNthImage(AvifDecoderWrapper* const decoder,uint32_t n,uint8_t* pixelmap,uint32_t picwidth,uint32_t picheight,uint32_t stride,uint32_t formatvalue) {
  avifResult res = avifDecoderNthImage(decoder->decoder, n);
  if (res != AVIF_RESULT_OK) {
    return res;
  }
  return AvifImageToBitmap( decoder, pixelmap,picwidth,picheight,stride,formatvalue);
}





