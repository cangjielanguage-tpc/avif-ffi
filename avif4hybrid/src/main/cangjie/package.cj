/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_avif4hybrid

var memoryLruCache:MemoryLruCache = MemoryLruCache(1024, 2*1024 * 1024 * 1024)
var fileLruCache:FileLruCache = FileLruCache(1024, 2*1024 * 1024 * 1024)

 //这个key是多方因素组成
 func getmd5key(buffer: Array<UInt8>): String {
     var md5Instance = MD5()
     md5Instance.write(buffer)
     var md: Array<Byte> = md5Instance.finish()
     var result: String = toHexString(md)
     return result
 }


//这个key是多方因素组成
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

 func getImageFromNet(urlStr: String): ?Array<UInt8> {
    try {
        let fut: Future<?Array<UInt8>> = spawn {
            var tlsConfig = TlsClientConfig()
            tlsConfig.verifyMode = TrustAll
            let client = ClientBuilder().tlsConfig(tlsConfig).build()
            let ret = client.get(urlStr)
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
                client.close()
                return buf
            } else {
                client.close()
                return None
            }
        }
        let result: ?Array<UInt8>  = fut.get()
        return result
    } catch (e: Exception) {
        Hilog.error(0,"getImageFromNet","${e.toString()}")
        return None
    }
}

