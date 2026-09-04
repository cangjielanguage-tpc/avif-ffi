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





//网络图片下载的最大体积上限(8MB)。防止恶意/异常服务器声明超大Content-Length时
//直接按bodySize可能会预分配超大缓冲导致OOM崩溃(修复P-03/P-26)。如业务确有超大图需求可调整该值。
let MAX_DOWNLOAD_SIZE: Int64 = 8 * 1024 * 1024


func getImageFromNet(urlStr: String): (?Array<UInt8>, ?Bool, Int32, String) {
    try {
        let fut: Future<(?Array<UInt8>, ?Bool, Int32, String)> = spawn {
            var tlsConfig = TlsClientConfig()
            tlsConfig.verifyMode = TrustAll
            let client = ClientBuilder().tlsConfig(tlsConfig).readTimeout(Duration.second * 60).build()
            try {
                let ret = client.send(HttpRequestBuilder().get().url(fixUrlForStdx(urlStr)).build())
                if (ret.status < 200 || ret.status >= 400) {
                    let message = "网络响应状态异常，status=${ret.status}"
                    Hilog.error(0, "getImageFromNet", "${message}, url is: ${urlStr}")
                    return (None, None, 1014, message)
                }
                if (let Some(v) <- ret.bodySize) {
                    // 下载体积上限校验：超限直接返回，不再按bodySize预分配缓冲(防OOM)
                    if (v > MAX_DOWNLOAD_SIZE) {
                        let message = "网络响应数据过大，size=${v}，超过上限${MAX_DOWNLOAD_SIZE}"
                        Hilog.error(0, "getImageFromNet", "${message}, url is: ${urlStr}")
                        return (None, None, 1018, message)
                    }
                    let buf = Array<UInt8>(v, repeat: 0)
                    var readNumAll = 0
                    var hasCheckIsAvif = false
                    while (readNumAll < v) {
                        let readNum = ret.body.read(buf[readNumAll..v])
                        if (readNum <= 0) {
                            break
                        }
                        readNumAll += readNum
                        if(!hasCheckIsAvif && readNumAll >= 12){
                            hasCheckIsAvif = true
                            let checkBuf = buf.slice(0,12)
                            let (isAvif,message) = isPicAvif(checkBuf)
                            if (let Some(avif) <- isAvif){
                                if(!avif){
                                    Hilog.info(0,"getImageFromNet","${message}, url is ：${urlStr}，code is: ${ret.status}")
                                    return (None, false, 1017, message)
                                }
                            } else {
                                    Hilog.info(0,"getImageFromNet","${message}, url is ：${urlStr}，code is: ${ret.status}")
                                    return (None, None, 1017, message)
                            }
                        }
                    }
                    if(readNumAll< 12){
                        // 异常数据
                        let message = "非图片数据, ${buf[0..readNumAll]}"
                        Hilog.info(0,"getImageFromNet","${message}, url is ：${urlStr}，code is: ${ret.status}")
                        return (None, None, 1017, "${message}")
                    }
                    if (readNumAll < v) {
                        let message = "网络响应数据不完整，已读取${readNumAll}/${v}"
                        Hilog.error(0, "getImageFromNet", "${message}, url is: ${urlStr}")
                        return (None, None, 1015, message)
                    }
                    return (buf, true, 0, "success")
                } else {
                    let message = "网络响应内容为空，status=${ret.status}"
                    Hilog.info(0, "getImageFromNet", "${message}, url is: ${urlStr}")
                    return (None, None, 1006, message)
                }
            } catch (e: Exception) {
                let message = "网络请求异常：${e.toString()}，message=${e.message}"
                Hilog.error(0, "getImageFromNet", message)
                return (None, None, 1006, message)
            } finally {
                client.close()
            }
        }
        return fut.get()
    } catch (e: Exception) {
        let message = "网络任务异常：${e.toString()}，message=${e.message}"
        Hilog.error(0, "getImageFromNet", message)
        return (None, None, 1006, message)
    }
}


func fixUrlForStdx(rawUrl: String): URL {
    let url = URL.parse(rawUrl)
    let url1 = url.replace(path:url.path, query:url.query)
    return url.replace(path:url1.rawPath, query:url1.rawQuery)
}

//102, 116, 121, 112, 97, 118, 105, 102
func isPicAvif(fileData:Array<UInt8>):(?Bool,String){
    if(fileData.size >= 12){
        if (fileData[4] == 102 && fileData[5] == 116 && fileData[6] == 121  && fileData[7] == 112 && fileData[8] == 97 && fileData[9] == 118 &&
        fileData[10] == 105  && (fileData[11] == 102 || fileData[11] == 115)){
            return (true, "avif图片")
        }
        if(fileData[0] == 60){
            return (None, "非图片数据:${fileData}")
        }
        return (false, "非avif图片")
    }else{
        return (None, "非图片数据:${fileData}")
    }
}

