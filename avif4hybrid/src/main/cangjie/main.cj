package ohos_app_cangjie_avif4hybrid

import ohos.hilog.Hilog

@FastNative
foreign func memcpy_s(dest: CPointer<UInt8>, destSize: UIntNative, src: CPointer<UInt8>, count: UIntNative): IntNative

@C
public struct AvifDecodeInfo {
    public var isSuccess: Bool = false
    public var errMsg: CString = CString(CPointer<UInt8>())
    public var isSinglePic: Bool = true //是否单图
    public var width: Int64 = 0 //图片的最终宽度
    public var height: Int64 = 0 //图片的最终高度
    public var depth: Int64 = 0
    public var alphaPresent: Bool = false
    public var frameCount: Int64 = 0 //图片的帧数
    public var repetitionCount: Int32 = 0
    public var frameDurations: CPointer<Float64> = CPointer<Float64>() //多图的时间集合数据
    public var frameDurationsLength: Int64 = 0 //多图的时间集合数据
    public var dataColors: CPointer<CPointer<UInt8>> = CPointer<CPointer<UInt8>>() //图片的像素数据  单图长度为1 多图长度为framecount
}

unsafe func handleAvifSinglePicture(decoder: CJAvifDecoder, uri: String): AvifDecodeInfo {
    var info = AvifDecodeInfo()
    info.width = decoder.getWidth()
    info.height = decoder.getHeight()
    info.depth = decoder.getDepth()
    info.alphaPresent = decoder.getAlphaPresent()
    info.frameCount = 1
    //原图宽高未知的话传0即可，接口内部会处理
    Hilog.error(0, "aviflog", "log6")
    let retValue: CJReturnValue = decoder.nthFrameffi(0, 0, 0)
    Hilog.error(0, "aviflog", "log7")
    var colors: ?Array<UInt8> = None
    if (retValue.issuccess) {
        //如果成功
        if (let Some(i) <- retValue.color) {
            Hilog.error(0, "aviflog", "log8")
            colors = i
        } else {
            info.isSuccess = false
            info.errMsg = LibC.mallocCString("Avif decoder failed to get colors.")
            return info
        }
    } else {
        info.isSuccess = false
        info.errMsg = LibC.mallocCString("Avif decoder failed to get colors.")
        return info
    }
    //    let colors: Array<UInt8> = if (let ret <- getFrame(decoder, uri, info.width, info.height)) {
    //        if (ret.issuccess && let Some(_colors) <- ret.color) {
    //            _colors
    //        } else {
    //            info.isSuccess = false
    //            info.errMsg = LibC.mallocCString("Avif decoder failed to get colors.")
    //            return info
    //        }
    //    } else {
    //        info.isSuccess = false
    //        info.errMsg = LibC.mallocCString("Avif decoder faild to get frame.")
    //        return info
    //    }
    Hilog.error(0, "aviflog", "log9")
    info.dataColors = unsafe { LibC.malloc<CPointer<UInt8>>(count: Int64(info.frameCount)) }
    let pixelMapSize = Int64(info.width) * info.height * 4
    var dst = LibC.malloc<UInt8>(count: pixelMapSize)
    let src = acquireArrayRawData(colors.getOrThrow())
    let ret = memcpy_s(dst, UIntNative(pixelMapSize), src.pointer, UIntNative(pixelMapSize))
    releaseArrayRawData<UInt8>(src)
    if (ret != 0) {
        Hilog.error(0, "aviflog", "log10")
        info.isSuccess = false
        LibC.free(dst)
        dst = CPointer<UInt8>()
    } else {
        Hilog.error(0, "aviflog", "log11")
        info.dataColors.write(0, src.pointer)
        info.isSuccess = true
        info.isSinglePic = true
    }
    Hilog.error(0, "aviflog", "log12")
    return info
}

//unsafe func getFrame(decoder: CJAvifDecoder, uri: String, width: Int64, height: Int64) {
//    var retValue: CJReturnValue = CJMemoryCheck().getMemoryCache(uri, width, height)
//    return if (retValue.issuccess == true) {
//        retValue
//    } else {
//        decoder.nthFrameffi(0, Int32(width), Int32(height))
//    }
//}

unsafe func free(info: AvifDecodeInfo) {
    if (info.frameDurations.isNotNull()) {
        LibC.free(info.frameDurations)
    }
    if (info.dataColors.isNotNull()) {
        for (idx in 0..info.frameCount) {
            let tmpPtr = info.dataColors.read(idx)
            if (tmpPtr.isNotNull()) {
                LibC.free(tmpPtr)
                info.dataColors.write(idx, CPointer<UInt8>())
            }
        }
        LibC.free(info.dataColors)
    }
}

unsafe func handleAvifMultiPicture(decoder: CJAvifDecoder, uri: String): AvifDecodeInfo {
    var info = AvifDecodeInfo()
    info.width = decoder.getWidth()
    info.height = decoder.getHeight()
    info.depth = decoder.getDepth()
    info.frameCount = decoder.getFrameCount()
    info.alphaPresent = decoder.getAlphaPresent()
    info.repetitionCount = Int32(decoder.getRepetitionCount())
    Hilog.error(0, "aviflog", "log13")
    let frameDurations = decoder.getFrameDurations()
    if (frameDurations.isNone()) {
        info.isSuccess = false
        info.errMsg = LibC.mallocCString("FrameDurations can not be None.")
        return info
    }
    if (frameDurations.getOrThrow().size != info.frameCount) {
        info.isSuccess = false
        info.errMsg = LibC.mallocCString("FrameDurations should be equal to frameCount.")
        return info
    }
    let durations = frameDurations.getOrThrow().toArray()
    info.frameDurationsLength = durations.size
    info.frameDurations = LibC.malloc<Float64>(count: info.frameDurationsLength)
    for (idx in 0..info.frameDurationsLength) {
        info.frameDurations.write(idx, durations[idx])
    }
    Hilog.error(0, "aviflog", "log14")
    let colors: Array<Array<UInt8>> = Array<Array<UInt8>>(info.frameCount, repeat: Array<UInt8>())
    for (idx in 0..info.frameCount) {
        //原图传0,底层自动会转换
        colors[idx] = if (let ret <- decoder.nthFrameffi(Int32(idx), 0, 0)) {
            if (ret.issuccess && let Some(color) <- ret.color) {
                color
            } else {
                info.isSuccess = false
                free(info)
                info.errMsg = LibC.mallocCString("Avif decoder failed to get colors at index ${idx}.")
                return info
            }
        } else {
            info.isSuccess = false
            LibC.free<Float64>(info.frameDurations)
            info.errMsg = LibC.mallocCString("Avif decoder faild to get frame ${idx}.")
            return info
        }
    }
    Hilog.error(0, "aviflog", "log15")
    info.dataColors = unsafe { LibC.malloc<CPointer<UInt8>>(count: Int64(info.frameCount)) }
    for (idx in 0..Int64(info.frameCount)) {
        let pixelMapSize = Int64(info.width * info.height * 4)
        var dst = LibC.malloc<UInt8>(count: pixelMapSize)
        let src = acquireArrayRawData(colors[idx])
        let ret = memcpy_s(dst, UIntNative(pixelMapSize), src.pointer, UIntNative(pixelMapSize)) //  直接使用array的原始指针会有显示异常的问题
        releaseArrayRawData<UInt8>(src)
        if (ret == 0) {
            info.dataColors.write(idx, dst)
        } else {
            LibC.free(dst)
            dst = CPointer<UInt8>()
            free(info)
            info.frameDurations = CPointer<Float64>()
            info.dataColors = CPointer<CPointer<UInt8>>()
            info.isSuccess = false
            return info
        }
    }
    Hilog.error(0, "aviflog", "log16")
    info.isSuccess = true
    info.isSinglePic = false
    return info
}

unsafe func handleAvifSource(decoder: CJAvifDecoder, uri: String): ?AvifDecodeInfo {
    let frameCount = decoder.getFrameCount() //图片的帧数
    Hilog.error(0, "aviflog", "log2")
    return if (frameCount <= 0) {
        Hilog.error(0, "aviflog", "log3")
        var info = AvifDecodeInfo()
        info.isSuccess = false
        info.errMsg = LibC.mallocCString("frame count less than 0.")
        info
    } else if (frameCount == 1) {
        Hilog.error(0, "aviflog", "log4")
        handleAvifSinglePicture(decoder, uri)
    } else {
        Hilog.error(0, "aviflog", "log5")
        handleAvifMultiPicture(decoder, uri)
    }
}

unsafe func dealWithMemoryCache(cjreturnValue: CJReturnValue): AvifDecodeInfo {
    var info = AvifDecodeInfo()
    info.width = cjreturnValue.memoryWidth
    info.height = cjreturnValue.memoryHeight
    info.frameCount = 1
    if (let Some(i) <- cjreturnValue.color) {
        //表示有图片数据
        info.dataColors = unsafe { LibC.malloc<CPointer<UInt8>>(count: Int64(info.frameCount)) }
        let pixelMapSize = Int64(info.width) * info.height * 4
        var dst = LibC.malloc<UInt8>(count: pixelMapSize)
        let src = acquireArrayRawData(i)
        let ret = memcpy_s(dst, UIntNative(pixelMapSize), src.pointer, UIntNative(pixelMapSize))
        releaseArrayRawData<UInt8>(src)
        if (ret != 0) {
            info.isSuccess = false
            LibC.free(dst)
            dst = CPointer<UInt8>()
        } else {
            info.dataColors.write(0, src.pointer)
            info.isSuccess = true
            info.isSinglePic = true
        }
        return info
    } else {
        info.isSuccess = false
        info.errMsg = LibC.mallocCString("Avif decoder failed to get colors.")
        return info
    }
}

@C
public unsafe func decodeURI(uri: CString): CPointer<AvifDecodeInfo> {
    //因为原图，所以宽高传0,0
    var decoder: ?CJAvifDecoder = None
    try {
        let cjreturnValue: CJReturnValue = CJCacheCheck().getMemoryCache(uri.toString(), 0, 0)
        if (cjreturnValue.issuccess) {
            Hilog.error(0, "aviflog", "进了内存缓存")
            let info = dealWithMemoryCache(cjreturnValue)
            //如果内存缓存取到了
            let ret = LibC.malloc<AvifDecodeInfo>()
            ret.write(info)
            return ret
        }
        decoder = CJCacheCheck().getDiskCache(uri.toString(), 0, 0)
        if (decoder.isNone()) {
            //没有本地缓存
            Hilog.error(0, "aviflog", "没有缓存")
            decoder = CJAvifDecoder().create(uri.toString())
        }else{
            Hilog.error(0, "aviflog", "进了本地缓存")
        }
        Hilog.error(0, "aviflog", "log1")
        let info = handleAvifSource(decoder.getOrThrow(), uri.toString()).getOrThrow()
        let ret = LibC.malloc<AvifDecodeInfo>()
        ret.write(info)
        return ret
    } catch (e: Exception) {
        Hilog.error(0, "aviflog", "log17")
        Hilog.error(0, "AvifDecoder", "decode ${uri} failed: ${e}")
        var info = AvifDecodeInfo()
        info.isSuccess = false
        info.errMsg = LibC.mallocCString(e.message)
        let ret = LibC.malloc<AvifDecodeInfo>()
        ret.write(info)
        ret
    } finally {
        Hilog.error(0, "aviflog", "log18")
        decoder?.release()
    }
    //    var decoder = None<CJAvifDecoder>
    //    return try {
    //        let uriStr = uri.toString()
    //        decoder = CJAvifDecoder().create(uriStr) ?? throw Exception("Create avif decoder failed.")
    //        let info = handleAvifSource(decoder.getOrThrow(), uriStr).getOrThrow()
    //        let ret = LibC.malloc<AvifDecodeInfo>()
    //        ret.write(info)
    //        ret
    //    } catch (e: Exception) {
    //        Hilog.error(0, "AvifDecoder", "decode ${uri} failed: ${e}")
    //        var info = AvifDecodeInfo()
    //        info.isSuccess = false
    //        info.errMsg = LibC.mallocCString(e.message)
    //        let ret = LibC.malloc<AvifDecodeInfo>()
    //        ret.write(info)
    //        ret
    //    } finally {
    //        decoder?.release()
    //    }
}
