/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_avif4hybrid

internal import ohos.component.*
internal import ohos.base.*
internal import ohos.state_manage.*
internal import ohos.matrix4.*
internal import ohos.resource_manager.*
internal import ohos.display.getDefaultDisplaySync
internal import ohos.ark_interop.*
internal import ohos.ark_interop_helper.*
internal import std.collection.*
internal import std.sync.ReentrantMutex
internal import std.process.Process
internal import std.collection.concurrent.ConcurrentHashMap
internal import std.convert.Parsable
internal import ohos.hilog.Hilog
internal import ohos.device_info.DeviceInfo
internal import ohos.image.createImageSource
import ohos.image.PixelMap
import stdx.crypto.digest.MD5
import stdx.encoding.hex.toHexString
import ohos.file_fs.FileFs
import stdx.net.tls.TlsClientConfig
import stdx.net.http.ClientBuilder


//这个key是多方因素组成

var memoryLruCache:MemoryLruCache = MemoryLruCache(256, 1024 * 1024 * 1024)
var fileLruCache:FileLruCache = FileLruCache(256, 1024 * 1024 * 1024,FileLruCache.CACHE_FOLDER)

func setMemoryLruCache(countSize:Int64,memorySize:Int64):Unit{
    memoryLruCache = MemoryLruCache(countSize,memorySize)
}

func setFileLruCache(countSize:Int64,memorySize:Int64,folderName:String):Unit{
    fileLruCache = FileLruCache(countSize,memorySize,folderName)
}


func getmd5key(buffer: Array<UInt8>, imagePicWidth: Int64, imagePicHeight: Int64): String {
    var md5Instance = MD5()
    md5Instance.write(buffer)
    var md: Array<Byte> = md5Instance.finish()
    var result: String = toHexString(md)
    return result + "w" + imagePicWidth.toString() + "h" + imagePicHeight.toString()
}

func getmd5keyWithIndex(buffer: Array<UInt8>, imagePicWidth: Int64, imagePicHeight: Int64,index:Int32): String {
    var md5Instance = MD5()
    md5Instance.write(buffer)
    var md: Array<Byte> = md5Instance.finish()
    var result: String = toHexString(md)
    return result + "w" + imagePicWidth.toString() + "h" + imagePicHeight.toString()+"idx"+index.toString()
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
        let resourceManager = ResourceManager.getResourceManager(GlobalContext.getContext().getOrThrow())
        let arr: Array<UInt8> = resourceManager.getMediaByName(mediaName,0)
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
