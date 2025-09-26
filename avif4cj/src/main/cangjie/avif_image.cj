/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package avif4cj

import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.component.Image
import ohos.component.ImageFit
import ohos.component.CustomView
import ohos.image.Size
import ohos.image.InitializationOptions
import ohos.image.PixelMap
import ohos.image.createPixelMap
import ohos.image.PixelMapFormat
import ohos.base.*
import std.collection.ArrayList
import ohos.concurrency.launch
import ohos.hilog.Hilog


@Component
public class AvifImage {

    //图片源数据 必传
    @Link
    var imageBuffer:?Array<UInt8>

    //图片宽度
    @State
    var imagePicWidth: Int64 = 0

    //图片高度
    @State
    var imagePicHeight: Int64 = 0

    //图片控件宽度
    @State
    var imageViewWidth: Length = 100.percent

    //图片控件高度
    @State
    var imageViewHeight: Length = 100.percent

    //图片对齐方式
    @State
    var imageFit: ImageFit = ImageFit.Contain


    //一开始的原始占位图
    let size: Size = Size(width: 1, height: 1)
    let opts: InitializationOptions = InitializationOptions(size: size)
    let color: Array<UInt8> = Array<UInt8>(1*1*4, repeat: 0)
    @State
    var pixelMap: PixelMap = createPixelMap(color, opts)

    //放在外面 利于回收
    let pixelMapList: ArrayList<PixelMap> = ArrayList<PixelMap>()
    //判断是否是单帧 对后面释放pixelmap有用
    var isSinglePic:Bool = true

    protected override func aboutToAppear() {
        if(let Some(i) <- imageBuffer){
              let avif:?AvifDecoder = AvifDecoder.create(i)
              if(let Some(j) <- avif){
                  //分为单帧和多帧
                  let frameCount:Int64 = j.getFrameCount()
                  var imageTempWidth = j.getWidth()
                  var imageTempHeight = j.getHeight()
                  if(imagePicWidth != 0){
                    imageTempWidth = imagePicWidth
                  }
                  if(imagePicHeight != 0){
                    imageTempHeight = imagePicHeight
                  }
                  let imageWidth = imageTempWidth
                  let imageHeight = imageTempHeight
                  if(frameCount <= 0){
                       throw Exception("frameCount can not be <= 0")
                  }else{
                     if(frameCount == 1){
                        //单帧图
                          spawn{
                              let colors: Array<UInt8> = Array<UInt8>(Int64(imageWidth * imageHeight * 4), repeat: 0)
                              j.nextFrameffi(colors, Int32(imageWidth),Int32(imageHeight),PixelMapFormat.RGBA_8888)
                              //根据生成胡color重新生成pixelmap
                              let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
                              let opts: InitializationOptions = InitializationOptions(PixelMapFormat.RGBA_8888,editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                              let tempPixelMap = createPixelMap(colors, opts)
                              launch{
                                 pixelMap = tempPixelMap
                              }
                              j.release()
                          }
                          return
                     }else{
                        //多帧图
                        isSinglePic = false
                        if(j.getFrameDurations().isNone()){
                            throw Exception("FrameDurations can not be None")
                        }
                        if(j.getFrameDurations().getOrThrow().size != frameCount){
                            throw Exception("FrameDurations should be equal to frameCount")
                        }
                        let durationList: Array<Float64> = j.getFrameDurations().getOrThrow()
                        spawn {
                            while (true) {
                                if (pixelMapList.size != frameCount) {
                                     for (k in 0..frameCount) {
                                        let colors: Array<UInt8> = Array<UInt8>(Int64(imageWidth * imageHeight * 4),repeat: 0)
                                        j.nthFrameffi(Int32(k), colors, Int32(imageWidth), Int32(imageHeight),PixelMapFormat.RGBA_8888)
                                        let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
                                        let opts: InitializationOptions = InitializationOptions(PixelMapFormat.RGBA_8888, editable: true,pixelFormat: PixelMapFormat.RGBA_8888,size: size2)
                                        let tempPixelMap = createPixelMap(colors, opts)
                                        launch{
                                             pixelMap = tempPixelMap
                                        }
                                        sleep(durationList[Int64(k)] * Duration.second)
                                        pixelMapList.add(tempPixelMap)
                                    }
                                }else{
                                    j.release()
                                    for (k in 0..pixelMapList.size) {
                                        let tempPixelMap = pixelMapList.get(k).getOrThrow()
                                        launch{
                                            pixelMap = tempPixelMap
                                        }
                                        sleep(durationList[Int64(k)] * Duration.second)
                                   }
                                }
                            }
                         }
                         return
                     }
                  }
              }else{
                 throw Exception("AvifDecoder can not be none")
              }
        }else{
            throw Exception("imageBuffer can not be none")
        }
    }

    protected override func aboutToDisappear() {
        try{
            if(isSinglePic){
                //单帧直接release
                this.pixelMap.release()
            }else{
                //多帧就release list 不要release pixelmap 会导致重复release
                for(i in 0..pixelMapList.size){
                    pixelMapList.get(i).getOrThrow().release()
                }
            }
        }catch(e:Exception){
            Hilog.error(0,"releasepixelmap","error=${e.toString()}")
        }
    }

    func build() {
         Image(this.pixelMap)
            .width(imageViewWidth)
            .height(imageViewHeight)
            .objectFit(imageFit)
    }
}