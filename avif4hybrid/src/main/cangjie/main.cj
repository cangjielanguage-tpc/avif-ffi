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
    public var isNotAvif: Bool = false //这个字段是对于非avif图片设置的  非avif图片这个字段会设置为true
}

unsafe func handleAvifSinglePicture(decoder: AvifDecoderWrap, uri: String): AvifDecodeInfo {
    var info = AvifDecodeInfo()
    info.width = decoder.getWidth()
    info.height = decoder.getHeight()
    info.depth = decoder.getDepth()
    info.alphaPresent = decoder.getAlphaPresent()
    info.frameCount = 1
    //原图宽高未知的话传0即可，接口内部会处理
    let retValue: ReturnValue = decoder.nthFrameffi(0, 0, 0)
    var colors: ?Array<UInt8> = None
    if (retValue.isSuccess) {
        //如果成功
        if (let Some(i) <- retValue.color) {
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
    info.dataColors = unsafe { LibC.malloc<CPointer<UInt8>>(count: Int64(info.frameCount)) }
    let pixelMapSize = Int64(info.width) * info.height * 4
    var dst = LibC.malloc<UInt8>(count: pixelMapSize)
    let src = acquireArrayRawData(colors.getOrThrow())
    let ret = memcpy_s(dst, UIntNative(pixelMapSize), src.pointer, UIntNative(pixelMapSize))
    releaseArrayRawData<UInt8>(src)
    if (ret != 0) {
        info.isSuccess = false
        LibC.free(dst)
        dst = CPointer<UInt8>()
    } else {
        info.dataColors.write(0, dst)
        info.isSuccess = true
        info.isSinglePic = true
    }
    return info
}


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

unsafe func handleAvifMultiPicture(decoder: AvifDecoderWrap, uri: String): AvifDecodeInfo {
    var info = AvifDecodeInfo()
    info.width = decoder.getWidth()
    info.height = decoder.getHeight()
    info.depth = decoder.getDepth()
    info.frameCount = decoder.getFrameCount()
    info.alphaPresent = decoder.getAlphaPresent()
    info.repetitionCount = Int32(decoder.getRepetitionCount())
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
    let colors: Array<Array<UInt8>> = Array<Array<UInt8>>(info.frameCount, repeat: Array<UInt8>())
    for (idx in 0..info.frameCount) {
        //原图传0,底层自动会转换
        colors[idx] = if (let ret <- decoder.nthFrameffi(Int32(idx), 0, 0)) {
            if (ret.isSuccess && let Some(color) <- ret.color) {
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
    info.isSuccess = true
    info.isSinglePic = false
    return info
}

unsafe func handleAvifSource(decoder: AvifDecoderWrap, uri: String): ?AvifDecodeInfo {
    let frameCount = decoder.getFrameCount() //图片的帧数
    return if (frameCount <= 0) {
        var info = AvifDecodeInfo()
        info.isNotAvif = decoder.isNotAvif
        info.isSuccess = false
        info.errMsg = LibC.mallocCString("frame count less than 0.")
        info
    } else if (frameCount == 1) {
        handleAvifSinglePicture(decoder, uri)
    } else {
        handleAvifMultiPicture(decoder, uri)
    }
}

unsafe func dealWithMemoryCache(returnValue: ReturnValue): AvifDecodeInfo {
    var info = AvifDecodeInfo()
    info.width = returnValue.memoryWidth
    info.height = returnValue.memoryHeight
    // alphaPremultiplied 已改为 AVIF_FALSE，需要正确传递 alpha 状态给上层
    //不加这行代码，RN在获取内存缓存时候会拿不到图片的isAlphaPresent信息
    info.alphaPresent = returnValue.isAlphaPresent
    info.frameCount = 1
    if (let Some(i) <- returnValue.color) {
        //表示有图片数据
        if(i.size == 1){
            //表示不是avif图
            info.isNotAvif = true
            info.isSuccess = false
            return info
        }
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
            info.dataColors.write(0, dst)
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
    var decoder: ?AvifDecoderWrap = None
    try {
        let returnValue: ReturnValue = CacheCheck().getMemoryCache(uri.toString(), 0, 0)
        if (returnValue.isSuccess) {
            let info = dealWithMemoryCache(returnValue)
            //如果内存缓存取到了
            let ret = LibC.malloc<AvifDecodeInfo>()
            ret.write(info)
            return ret
        }
        //本地缓存里面实现了
        decoder = AvifDecoderWrap().createCompatibleOtherPic(uri.toString())
        if(let Some(i) <- decoder){
            let info = handleAvifSource(i, uri.toString()).getOrThrow()
            let ret = LibC.malloc<AvifDecodeInfo>()
            ret.write(info)
            return ret
        }else{
            var info = AvifDecodeInfo()
            info.isSuccess = false
            info.errMsg = LibC.mallocCString("生成解码器对象失败")
            let ret = LibC.malloc<AvifDecodeInfo>()
            ret.write(info)
            return ret
        }
    } catch (e: Exception) {
        Hilog.error(0, "AvifDecoder", "decode ${uri} failed: ${e}")
        var info = AvifDecodeInfo()
        info.isSuccess = false
        info.errMsg = LibC.mallocCString(e.message)
        let ret = LibC.malloc<AvifDecodeInfo>()
        ret.write(info)
        ret
    } finally {
        decoder?.release()
    }
}
