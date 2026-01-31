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
import std.fs.exists
import std.fs.Directory
import std.fs.File
import std.fs.OpenMode


//这个key是多方因素组成
let memoryMap: HashMap<String, CacheBean> = HashMap<String, CacheBean>()
let cacheDirPath = "/data/storage/el2/base/haps/entry/cache/avifcache"

func getmd5key(buffer: Array<UInt8>, imagePicWidth: Int64, imagePicHeight: Int64): String {
    var md5Instance = MD5()
    md5Instance.write(buffer)
    var md: Array<Byte> = md5Instance.finish()
    var result: String = toHexString(md)
    return result + "w" + imagePicWidth.toString() + "h" + imagePicHeight.toString()
}


func colorToFile(key: String, buffer: Array<UInt8>, width: Int64, height: Int64): Bool {
    try {
        let dirPath = cacheDirPath
        if (!exists(dirPath)) {
            Directory.create(dirPath)
        }
        let filePath = dirPath + "/" + key
        let tempFile = File(filePath, OpenMode.ReadWrite)
        let imageInfoArr: Array<UInt8> = Array<UInt8>(4, repeat: 0)
        imageInfoArr[0] = UInt8(width >> 8 & 0xFF)
        imageInfoArr[1] = UInt8(width & 0xFF)
        imageInfoArr[2] = UInt8(height >> 8 & 0xFF)
        imageInfoArr[3] = UInt8(height & 0xFF)
        tempFile.write(imageInfoArr)
        tempFile.write(buffer)
        tempFile.flush()
        tempFile.close()
        return true
    } catch (e: Exception) {
        Hilog.error(0, "exception", "${e.toString()}")
        return false
    }
}
