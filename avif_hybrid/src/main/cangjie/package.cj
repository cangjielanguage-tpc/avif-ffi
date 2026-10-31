package avif4cj
import stdx.net.http.HttpRequestBuilder
import stdx.encoding.url.URL


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

func fixUrlForStdx(rawUrl: String): URL {
     let url = URL.parse(rawUrl)
     let url1 = url.replace(path:url.path, query:url.query)
     return url.replace(path:url1.rawPath, query:url1.rawQuery)
 }

 func getImageFromNet(urlStr: String): ?Array<UInt8> {
     try {
         let fut: Future<?Array<UInt8>> = spawn {
             var tlsConfig = TlsClientConfig()
             tlsConfig.verifyMode = TrustAll
             let client = ClientBuilder().tlsConfig(tlsConfig).readTimeout(Duration.second * 60).build()
             try{
                 let ret = client.send(HttpRequestBuilder().get().url(fixUrlForStdx(urlStr)).build())
 	             if (ret.status < 200 || ret.status >= 400) {
                     Hilog.error(0,"getImageFromNet","getImageFromNet failed, url is ：${urlStr}, error is : ${ret}")
                     return None
                 }
                 if (let Some(v) <- ret.bodySize) {
                     let buf = Array<UInt8>(v, repeat: 0)
                     var readNumAll = 0
                     while (readNumAll < v) {
                         let readNum = ret.body.read(buf[readNumAll..v])
                         if (readNum <= 0) {
                             break
                         }
                         readNumAll += readNum
                     }
                     return buf
                 } else {
                     Hilog.info(0,"getImageFromNet2","bodySize is empty, url is ：${urlStr}, code is: ${ret.status}")
                     return None
                 }
             }catch (e:Exception){
                 Hilog.error(0,"getImageFromNet","getImageFromNet failed, error is ：${e.toString()}")
                 return None
             }finally {
                 client.close()
             }
         }
         let result: ?Array<UInt8>  = fut.get()
         return result
     } catch (e: Exception) {
         Hilog.error(0,"getImageFromNet","${e.toString()}")
         return None
     }
 }


