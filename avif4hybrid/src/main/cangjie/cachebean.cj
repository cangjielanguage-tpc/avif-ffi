/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package ohos_app_cangjie_avif4hybrid
import ohos.image.PixelMap

//缓存对象
class CacheBean {
  var multiPixelMap:?MultiPixelMap = None
  var pixelMap:?PixelMap = None

    func setMultiPixelMap(multiPixelMap:?MultiPixelMap){
        this.multiPixelMap = multiPixelMap
    }

    func setPixelMap(pixelMap:?PixelMap){
        this.pixelMap = pixelMap
    }

    func getMultiPixelMap():?MultiPixelMap{
        return multiPixelMap
    }

    func getPixelMap():?PixelMap{
        return pixelMap
    }

    init(multiPixelMap:?MultiPixelMap,pixelMap:?PixelMap){
        this.multiPixelMap = multiPixelMap
        this.pixelMap = pixelMap
    }

}

//多图缓存对象
class MultiPixelMap{
    var frameDurations: Array<Float64> = Array<Float64>()
    var pixelMapList: ArrayList<PixelMap> = ArrayList<PixelMap>()
    var repetitionCount: Int32 = 0

    func setFrameDurations(frameDurations:Array<Float64>){
        this.frameDurations = frameDurations
    }

    func setPixelMapList(pixelMapList:ArrayList<PixelMap>){
        this.pixelMapList = pixelMapList
    }

    func setRepetitionCount(repetitionCount:Int32){
        this.repetitionCount = repetitionCount
    }

    func getFrameDurations():Array<Float64>{
        return frameDurations
    }

    func getPixelMapList():ArrayList<PixelMap>{
        return pixelMapList
    }

    func getRepetitionCount():Int32{
        return repetitionCount
    }

    init(pixelMapList:ArrayList<PixelMap>,frameDurations:Array<Float64>,repetitionCount:Int32){
        this.pixelMapList = pixelMapList
        this.frameDurations = frameDurations
        this.repetitionCount = repetitionCount
    }
}
