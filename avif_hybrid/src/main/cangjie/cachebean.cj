package avif4cj

//缓存对象（内存缓存只存解码字节 color；PixelMap 由显示方自行创建并持有）
class CacheBean {
  var picData:?Array<UInt8> = None
  var memoryWidth:Int64 = 0
  var memoryHeight:Int64 = 0
  var isAlphaPresent:Bool = false

    func setPicData(picData:?Array<UInt8>){
        this.picData = picData
    }

    func getPicData():?Array<UInt8>{
        return picData
    }

    func getMemoryWidth():Int64{
        return memoryWidth
    }

    func setMemoryWidth(memoryWidth:Int64){
        this.memoryWidth = memoryWidth
    }

    func getMemoryHeight():Int64{
        return memoryHeight
    }

    func setMemoryHeight(memoryHeight:Int64){
        this.memoryHeight = memoryHeight
    }

    func setAlphaPresent(isAlphaPresent:Bool){
        this.isAlphaPresent = isAlphaPresent
    }

    func getAlphaPresent():Bool{
        return isAlphaPresent
    }

    // 非 avif 图片的占位标记构造（avif_decoder_wrap 兼容路径）
    init(picData:?Array<UInt8>){
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
