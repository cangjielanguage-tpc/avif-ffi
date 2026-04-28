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

//(?Array<UInt8>,Bool) 第一个参数表述返回的图片字节数据，第二个参数false表示下载的图片是非avif图片
func getImageFromNet2(urlStr: String):(?Array<UInt8>,?Bool) {

    let res:FetchResult = fetchDataFromUrlRN(urlStr)
    let responseCode = res.responseCode
    if(let Some(i) <- responseCode){
        if(i == 200){
            //表示成功
           let resData:?Array<Byte> = res.result
           if(let Some(j) <- resData){
              return (j,true)
           }else{
              return (None,None)
           }
        }
        return (None,None)
    }else{
        //如果没有responseCode
        return (None,false)
    }
}

//102, 116, 121, 112, 97, 118, 105, 102
func isPicAvif(fileData:ArrayList<UInt8>):Bool{
    if(fileData.size >= 12){
        return fileData[4] == 102 && fileData[5] == 116 && fileData[6] == 121  && fileData[7] == 112 && fileData[8] == 97 && fileData[9] == 118 &&
        fileData[10] == 105  && (fileData[11] == 102 || fileData[11] == 115)
    }else{
        return false
    }
}

