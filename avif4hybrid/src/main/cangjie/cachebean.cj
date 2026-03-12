/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package ohos_app_cangjie_avif4hybrid

//缓存对象
class CacheBean {
  var pixelMap:?PixelMap = None
  var picData:?Array<UInt8> = None

    func setPicData(picData:?Array<UInt8>){
        this.picData = picData
    }

    func setPixelMap(pixelMap:?PixelMap){
        this.pixelMap = pixelMap
    }

    func getPixelMap():?PixelMap{
        return pixelMap
    }

    func getPicData():?Array<UInt8>{
        return picData
    }

    init(pixelMap:?PixelMap,picData:?Array<UInt8>){
        this.pixelMap = pixelMap
        this.picData = picData
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
