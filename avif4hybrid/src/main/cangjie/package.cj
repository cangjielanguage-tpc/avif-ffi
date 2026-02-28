/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_avif4hybrid

public class InfoRN {
    public var isSuccess: Bool = false //是否成功
    public var errMsg: String = "" //是否成功
    public var isSinglePic: Bool = true //是否单图
    public var width: UInt32 = 0  //图片的最终宽度
    public var height: UInt32 = 0  //图片的最终高度
    public var depth: UInt32 = 0
    public var alphaPresent: Bool = false
    public var frameCount: Int32 = 0  //图片的帧数
    public var repetitionCount: Int32 = 0
    public var frameDurations: ?Array<Float64> = None //多图的时间集合数据
    public var dataColors: ?Array<Array<UInt8>> = None  //图片的像素数据  单图长度为1 多图长度为framecount
}

public func dealAvifWithRN(buffer:Array<UInt8>,imagePicWidth:Int64,imagePicHeight:Int64):InfoRN{
       var info:InfoRN = InfoRN()
       let decoder:?AvifDecoder = AvifDecoder.create(buffer)
       if(let Some(j) <- decoder){
            //表示是正确的avif数据
            //分为单帧和多帧
          let frameCount:Int64 = j.getFrameCount() //图片的帧数
          var imageTempWidth = j.getWidth() //图片的原始宽
          var imageTempHeight = j.getHeight() //图片的原始高
          if(imagePicWidth != 0){
            imageTempWidth = imagePicWidth //图片的需要生成的宽
          }
          if(imagePicHeight != 0){
            imageTempHeight = imagePicHeight //图片的需要生成的高
          }
          let imageWidth = imageTempWidth //最后实际的宽
          let imageHeight = imageTempHeight //最好实际的高
          if(frameCount <= 0){
               info.isSuccess = false
               info.errMsg = "frameCount can not be <= 0"
               return info
          }else{
             if(frameCount == 1){
                //单帧图
                      info.dataColors = Array<Array<UInt8>>(1,repeat:Array<UInt8>())
                      let colors: Array<UInt8> = Array<UInt8>(Int64(imageWidth * imageHeight * 4), repeat: 0)
                      j.nextFrameffi(colors, Int32(imageWidth),Int32(imageHeight))
                      //这里已经生成了color
                      j.release()
                      info.isSuccess = true
                      info.width = UInt32(imageWidth)
                      info.height = UInt32(imageHeight)
                      info.isSinglePic = true
                      info.frameCount = 1
                      info.dataColors.getOrThrow()[0] = colors
                      return info
             }else{
                //多帧图
                if(j.getFrameDurations().isNone()){
                    info.isSuccess = false
                    info.errMsg = "FrameDurations can not be None"
                    return info
                }
                if(j.getFrameDurations().getOrThrow().size != frameCount){
                    info.isSuccess = false
                    info.errMsg = "FrameDurations should be equal to frameCount"
                    return info
                }
                info.dataColors = Array<Array<UInt8>>(frameCount,repeat:Array<UInt8>())
                let durationList: Array<Float64> = j.getFrameDurations().getOrThrow()
                 for (k in 0..frameCount) {
                    let colors: Array<UInt8> = Array<UInt8>(Int64(imageWidth * imageHeight * 4),repeat: 0)
                    j.nthFrameffi(Int32(k), colors, Int32(imageWidth), Int32(imageHeight))
                    info.dataColors.getOrThrow()[k] = colors
                 }
                 info.isSuccess = true
                 info.isSinglePic = false
                 info.width = UInt32(imageWidth)
                 info.height = UInt32(imageHeight)
                 info.depth = UInt32(j.getDepth())
                 info.alphaPresent = j.getAlphaPresent()
                 info.frameCount = Int32(frameCount)
                 info.repetitionCount = Int32(j.getRepetitionCount())
                 info.frameDurations = durationList
                 return info
             }
          }
       }else{
             info.isSuccess = false
             info.errMsg = "AvifDecoder can not be none,maybe the imageBuffer data is not avif format data"
             return info
       }
}