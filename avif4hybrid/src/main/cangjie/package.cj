package ohos_app_cangjie_avif4hybrid

internal import ohos.hilog.Hilog
import ohos.concurrency.launch
internal import ohos.file_fs.FileFs
internal import ohos.ark_interop.JSContext
internal import ohos.ark_interop.JSModule
internal import ohos.ark_interop.JSInteropType
internal import ohos.file_fs.Stat
internal import ohos.file_fs.OpenMode
internal import ohos.image.PixelMap
internal import ohos.base.Length
internal import ohos.base.LengthType
internal import ohos.ark_interop.JSObject
internal import std.time.DateTime
internal import std.sort.sort
internal import std.collection.ArrayList
internal import std.sync.ReentrantMutex
internal import std.convert.Parsable
internal import ohos.base.LengthProp
internal import stdx.crypto.digest.MD5
internal import stdx.encoding.hex.toHexString
internal import ohos.resource_manager.ResourceManager
internal import ohos.ark_interop.JSCallInfo
internal import ohos.ark_interop.JSValue
internal import ohos.ark_interop.SharedObject
internal import ohos.ark_interop.JSCurrentJSContext
internal import ohos.ark_interop.JSArrayEx
internal import ohos.ark_interop.JSExternal
internal import ohos.ark_interop.JSType
internal import ohos.ark_interop_helper.StageContext
internal import ohos.ark_interop_helper.arkTsValuetoNapiValue
internal import ohos.ark_interop_helper.isStageMode
internal import ohos.ark_interop_helper.getContextStageMode
internal import stdx.net.http.ClientBuilder
internal import stdx.net.tls.CertificateVerifyMode
internal import stdx.net.tls.TlsClientConfig
import stdx.encoding.url.URL
import stdx.net.http.HttpRequestBuilder

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





func getImageFromNet(urlStr: String): (?Array<UInt8>, Int32, String) {
    try {
        let fut: Future<(?Array<UInt8>, Int32, String)> = spawn {
            var tlsConfig = TlsClientConfig()
            tlsConfig.verifyMode = TrustAll
            let client = ClientBuilder().tlsConfig(tlsConfig).readTimeout(Duration.second * 60).build()
            try {
                let ret = client.send(HttpRequestBuilder().get().url(fixUrlForStdx(urlStr)).build())
                if (ret.status < 200 || ret.status >= 400) {
                    let message = "网络响应状态异常，status=${ret.status}"
                    Hilog.error(0, "getImageFromNet", "${message}, url is: ${urlStr}")
                    return (None, 1014, message)
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
                    if (readNumAll < v) {
                        let message = "网络响应数据不完整，已读取${readNumAll}/${v}"
                        Hilog.error(0, "getImageFromNet", "${message}, url is: ${urlStr}")
                        return (None, 1015, message)
                    }
                    return (buf, 0, "success")
                } else {
                    let message = "网络响应内容为空，status=${ret.status}"
                    Hilog.info(0, "getImageFromNet", "${message}, url is: ${urlStr}")
                    return (None, 1006, message)
                }
            } catch (e: Exception) {
                let message = "网络请求异常：${e.toString()}，message=${e.message}"
                Hilog.error(0, "getImageFromNet", message)
                return (None, 1006, message)
            } finally {
                client.close()
            }
        }
        return fut.get()
    } catch (e: Exception) {
        let message = "网络任务异常：${e.toString()}，message=${e.message}"
        Hilog.error(0, "getImageFromNet", message)
        return (None, 1006, message)
    }
}



 func getImageFromNet2(urlStr: String): (?Array<UInt8>,?Bool){
    try {
        let fut: Future<(?Array<UInt8>,?Bool)> = spawn {
            let hasCheckAvif = HasCheckAvif()
            var tlsConfig = TlsClientConfig()
            tlsConfig.verifyMode = TrustAll
            let client = ClientBuilder().tlsConfig(tlsConfig).readTimeout(Duration.second * 60).build()
            try{
                let ret = client.send(HttpRequestBuilder().get().url(fixUrlForStdx(urlStr)).build())
                if (ret.status < 200 || ret.status >= 400) {
                    Hilog.error(0,"getImageFromNet2","getImageFromNet2 failed, url is ：${urlStr}, error is: ${ret}")
                    return (None,None)
                }
                if (let Some(v) <- ret.bodySize) {
                    let buf = Array<UInt8>(v, repeat: 0)
                    var readNumAll = 0
                    var stoppedByNonAvif = false
                    while (readNumAll < v) {
                        let readNum = ret.body.read(buf[readNumAll..v])
                        if (readNum <= 0) {
                            break
                        }
                        readNumAll += readNum
                        if(!hasCheckAvif.hasCheck && readNumAll >= 12){
                            hasCheckAvif.hasCheck = true
                            let checkBuf = buf.slice(0,12)
                            if(!isPicAvif(checkBuf)){
                                //如果不是avif停止下载
                                hasCheckAvif.isAvif = false
                                stoppedByNonAvif = true
                                break
                            }
                        }
                    }
                    if (stoppedByNonAvif) {
                        // 主动终止：确认非 AVIF，语义是「不是 avif 图」
                        Hilog.info(0,"getImageFromNet2","Non Avif images, url is ：${urlStr}，code is: ${ret.status}")
                        return (None,false)
                    }
                    // 宁可失败，不可残缺：EOF/网络中断导致读不满 bodySize 时，
                    // 尾部是 0 填充的残缺 buf，禁止返回（会污染缓存且解码异常）
                    if (readNumAll < v) {
                        Hilog.error(0,"getImageFromNet2","incomplete body, read ${readNumAll}/${v}, url is ：${urlStr}")
                        return (None,None)
                    }
                    if(let Some(i) <- hasCheckAvif.isAvif){
                        //如果有值，必然false
                        Hilog.info(0,"getImageFromNet2","Non Avif images, url is ：${urlStr}，code is: ${ret.status}")
                        return (None,false)
                    }else{
                        hasCheckAvif.isAvif = true
                        return (buf,true)
                    }
                } else {
                    Hilog.info(0,"getImageFromNet2","bodySize is empty, url is ：${urlStr}, code is: ${ret.status}")
                    return (None,None)
                }
            }catch (e:Exception){
                Hilog.error(0,"getImageFromNet2","getImageFromNet2 failed, error is ：${e.toString()}, message is: ${e.message}")
                return (None,None)
            }finally {
                client.close()
            }
        }
        let result: (?Array<UInt8>,?Bool) = fut.get()
        return result
    } catch (e: Exception) {
        Hilog.error(0,"getImageFromNet2","getImageFromNet2 error is ${e.toString()}")
        return (None,None)
    }
}

func fixUrlForStdx(rawUrl: String): URL {
    let url = URL.parse(rawUrl)
    let url1 = url.replace(path:url.path, query:url.query)
    return url.replace(path:url1.rawPath, query:url1.rawQuery)
}

//102, 116, 121, 112, 97, 118, 105, 102
func isPicAvif(fileData:Array<UInt8>):Bool{
    if(fileData.size >= 12){
        return fileData[4] == 102 && fileData[5] == 116 && fileData[6] == 121  && fileData[7] == 112 && fileData[8] == 97 && fileData[9] == 118 &&
        fileData[10] == 105  && (fileData[11] == 102 || fileData[11] == 115)
    }else{
        return false
    }
}

