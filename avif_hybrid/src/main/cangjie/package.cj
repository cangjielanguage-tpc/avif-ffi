package avif4cj


var memoryLruCache:MemoryLruCache = MemoryLruCache(256, 40 * 1024 * 1024)
var fileLruCache:FileLruCache = FileLruCache(1500, 256 * 1024 * 1024)


//这个key是多方因素组成
func getmd5key(buffer: Array<UInt8>): String {
    var md5Instance = MD5()
    md5Instance.write(buffer)
    var md: Array<Byte> = md5Instance.finish()
    var result: String = toHexString(md)
    return result
}

func getmd5key(buffer: Array<UInt8>, imagePicWidth: Int64, imagePicHeight: Int64): String {
    var md5Instance = MD5()
    md5Instance.write(buffer)
    var md: Array<Byte> = md5Instance.finish()
    var result: String = toHexString(md)
    return result + "w" + imagePicWidth.toString() + "h" + imagePicHeight.toString()
}

 func getImageFromRawFile(rawFileName: String): ?Array<UInt8> {
    try {
        let resourceManager = ResourceManager.getResourceManager(GlobalContext.getContext().getOrThrow())
        let arr: Array<UInt8> = resourceManager.getRawFileContent(rawFileName)
        return arr
    } catch (e: Exception) {
        Hilog.error(0,"rawfile","${e.toString()}")
        return None
    }
}

 func getImageFromMedia(mediaName: String): ?Array<UInt8> {
    try {
        var mediastr = mediaName.removeSuffix(".avif")
        let resourceManager = ResourceManager.getResourceManager(GlobalContext.getContext().getOrThrow())
        let arr: Array<UInt8> = resourceManager.getMediaByName(mediastr,0)
        return arr
    } catch (e: Exception) {
        Hilog.error(0,"media","${e.toString()}")
        return None
    }
}

func getImageFromNet(urlStr: String):?Array<UInt8> {
    let res:FetchResult = fetchDataFromUrl(urlStr)
    let responseCode = res.responseCode
    if(let Some(i) <- responseCode){
        if(i == 200){
            //表示成功
           let resData:?Array<Byte> = res.result
           if(let Some(j) <- resData){
              return j
           }else{
              return None
           }
        }
        return None
    }else{
        //如果没有responseCode
        return None
    }
}

