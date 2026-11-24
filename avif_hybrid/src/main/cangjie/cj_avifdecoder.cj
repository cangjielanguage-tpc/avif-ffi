package avif4cj

import ohos.ark_interop_macro.Interop
import std.sync.ReentrantMutex

public class CJAvifDecoder <: SharedObject & JSInteropType<CJAvifDecoder> {
    static init() {
        JSModule.registerClass("CJAvifDecoder") {
            context =>
                let clazz = context.clazz(jsConstructor)

                clazz.addMethod("createAsync", context.function(createAsync_ArkTS_Interop_Identifier))

                clazz.addMethod("createWithThreadAsync",
                    context.function(createWithThreadAsync_ArkTS_Interop_Identifier))

                clazz.addMethod("getWidth", context.function(getWidth_ArkTS_Interop_Identifier))

                clazz.addMethod("getHeight", context.function(getHeight_ArkTS_Interop_Identifier))

                clazz.addMethod("getDepth", context.function(getDepth_ArkTS_Interop_Identifier))

                clazz.addMethod("getAlphaPresent", context.function(getAlphaPresent_ArkTS_Interop_Identifier))

                clazz.addMethod("getFrameCount", context.function(getFrameCount_ArkTS_Interop_Identifier))

                clazz.addMethod("getRepetitionCount", context.function(getRepetitionCount_ArkTS_Interop_Identifier))

                clazz.addMethod("getFrameDurations", context.function(getFrameDurations_ArkTS_Interop_Identifier))

                clazz.addMethod("isAvifImageffi", context.function(isAvifImageffi_ArkTS_Interop_Identifier))

                clazz.addMethod("nextFrameIndexffi", context.function(nextFrameIndexffi_ArkTS_Interop_Identifier))

                clazz.addMethod("nextFrameffiAsync", context.function(nextFrameffiAsync_ArkTS_Interop_Identifier))

                clazz.addMethod("nthFrameffiAsync", context.function(nthFrameffiAsync_ArkTS_Interop_Identifier))

                clazz.addMethod("release", context.function(release_ArkTS_Interop_Identifier))

                return clazz
        }
    }

    public init() {
    }

    public static func jsConstructor(context: JSContext, callInfo: JSCallInfo): JSValue {
        JSCurrentJSContext.set(context)
        let clazz = CJAvifDecoder()
        JSCurrentJSContext.unset()
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = context.external(clazz)
        thisObject.attachCJObject(jsExternal)
        return thisObject.toJSValue()
    }

    public func createAsync(uri: String): Bool {
        return createWithThreadAsync(uri, 1)
    }

    public func createWithThreadAsync(uri: String, threads: Int32): Bool {
        this.mUri = uri
        if (uri.toAsciiLower().startsWith("http")) {
            let mDiskKey: String = getmd5key(this
                .mUri
                .toArray())
            let fileExist = FileUtils
                .getInstance()
                .exist(fileLruCache.path + mDiskKey)
            if (fileExist) {
                let source: ?Array<UInt8> = FileUtils.getInstance().readFileSync(fileLruCache.path + mDiskKey)
                if (let Some(i) <- source) {
                    let res = createLoginc(i, threads)
                    if(res.isSome()){
                        return true
                    }else{
                         // 坏缓存自愈: remove 清 LRU 记账+删文件(场景A); deleteFile 兜底
                         // 删"不在 LRU 的孤儿残缺文件"(场景B, put 写失败回滚的遗留)。幂等安全。
                         fileLruCache.remove(mDiskKey)
                         FileUtils.getInstance().deleteFile(fileLruCache.path + mDiskKey)
                    }
                }
            }
            let imageBuffer = getImageFromNet(uri)
            if (let Some(i) <- imageBuffer) {
                let res = createLoginc(i, threads)
                return res.isSome()
            } else {
                Hilog.error(0, "getImageFromNet", "获取网络文件内容失败")
                return false
            }
        } else if (uri.toAsciiLower().startsWith("rawfile://")) {
            let fileName = uri.removePrefix("rawfile://")
            let imageBuffer = getImageFromRawFile(fileName)
            if (let Some(i) <- imageBuffer) {
                let res = createLoginc(i, threads)
                return res.isSome()
            } else {
                Hilog.error(0, "getImageFromRawFile", "获取raw文件内容失败")
                return false
            }
        } else if (uri.toAsciiLower().startsWith("media://")) {
            let mediaName = uri.removePrefix("media://")
            let imageBuffer = getImageFromMedia(mediaName)
            if (let Some(i) <- imageBuffer) {
                let res = createLoginc(i, threads)
                return res.isSome()
            } else {
                Hilog.error(0, "getImageFromMedia", "获取media文件内容失败")
                return false
            }
        } else if (uri.toAsciiLower().startsWith("file://")) {
            let localFilePath = uri.removePrefix("file://")
            let imageBuffer: ?Array<UInt8> = FileUtils
                .getInstance()
                .readFileSync(localFilePath)
            if (let Some(i) <- imageBuffer) {
                let res = createLoginc(i, threads)
                return res.isSome()
            } else {
                Hilog.error(0, "readFileSync", "读取本地文件失败")
                return false
            }
        } else {
            let localFilePath = uri
            let imageBuffer: ?Array<UInt8> = FileUtils
                .getInstance()
                .readFileSync(localFilePath)
            if (let Some(i) <- imageBuffer) {
                let res = createLoginc(i, threads)
                return res.isSome()
            } else {
                Hilog.error(0, "readFileSync", "读取内容失败")
                return false
            }
        }
    }

    public func getWidth(): Int64 {
        if (let Some(i) <- decoder) {
            return i.getWidth()
        }
        return 0
    }

    public func getHeight(): Int64 {
        if (let Some(i) <- decoder) {
            return i.getHeight()
        }
        return 0
    }

    public func getDepth(): Int64 {
        if (let Some(i) <- decoder) {
            return i.getDepth()
        }
        return 0
    }

    public func getAlphaPresent(): Bool {
        if (let Some(i) <- decoder) {
            return i.getAlphaPresent()
        }
        return false
    }

    public func getFrameCount(): Int64 {
        if (let Some(i) <- decoder) {
            return i.getFrameCount()
        }
        return 0
    }

    public func getRepetitionCount(): Int64 {
        if (let Some(i) <- decoder) {
            return i.getRepetitionCount()
        }
        return 0
    }

    public func getFrameDurations(): Option<JSArrayEx<Float64>> {
        if (let Some(i) <- decoder) {
            if (let Some(j) <- i.getFrameDurations()) {
                return JSArrayEx(j)
            } else {
                return None
            }
        }
        return None
    }

    public func isAvifImageffi(picData:Array<UInt8>): Int32 {
        return AvifDecoder.isAvifImageffi(picData)
    }

    public func nextFrameIndexffi(): Int32 {
        if (let Some(i) <- decoder) {
            return i.nextFrameIndexffi()
        }
        return 0
    }

    // ===== SEC-M2 修复：解码流程同步化 =====
    // 同一 decoder 不允许并发解码或边解码边释放：
    // 快照（持锁）→ 解码（锁外，release 已被推迟）→ 收尾（持锁处理释放请求）
    private func decodeFrame(imageWidth: Int32, imageHeight: Int32, nth: Bool, index: Int32): ReturnValue {
        let value: ReturnValue = ReturnValue()
        if (imageWidth < 0 || imageHeight < 0) {
            value.isSuccess = false
            return value
        }
        var dec: Option<AvifDecoder> = None
        var count: Int64 = 0
        var width = imageWidth
        var height = imageHeight
        var alpha = false
        synchronized(mtx) {
            // 并发解码拒绝 + 释放请求拒绝：同一 decoder 串行使用
            if (decoder.isNone() || releasePending || decoding) {
                value.isSuccess = false
                return value
            }
            let i = decoder.getOrThrow()
            dec = decoder
            count = i.getFrameCount()
            if (count <= 0) {
                value.isSuccess = false
                return value
            }
            if (imageWidth == 0) {
                width = Int32(i.getWidth())
            }
            if (imageHeight == 0) {
                height = Int32(i.getHeight())
            }
            // SEC-H3 修复：尺寸/乘积校验（imageWidth/Height 为开发者透传值，可能来自外部输入；
            // Int64 乘法防 Int32 溢出）——同一 decoder 串行使用的前提下载入失败返回
            if (width > Int32(MAX_DIMENSION) || height > Int32(MAX_DIMENSION) ||
                Int64(width) * Int64(height) > MAX_PIXELS) {
                Hilog.error(0, "aviflog", "image dimensions rejected: ${width}x${height}")
                value.isSuccess = false
                value.code = -1
                return value
            }
            alpha = i.getAlphaPresent()
            decoding = true
        }
        var color: Array<Byte> = Array<Byte>()
        var code: Int32 = -1
        var ok = false
        // SEC-M fix: 锁外解码段（大缓冲分配 + FFI）包 try/finally——任何异常路径都在
        // finally 内重新进锁复位 decoding，并按 releasePending 完成销毁，
        // 杜绝“decoding 卡 true → 对象永久不可用 / release() 永不销毁”的状态机破坏
        try {
            color = Array<Byte>(Int64(width) * Int64(height) * 4, repeat: 0)
            if (let Some(i) <- dec) {
                if (!nth) {
                    code = i.nextFrameffi(color, width, height)
                } else if (count > 1) {
                    code = i.nthFrameffi(index, color, width, height)
                } else {
                    code = i.nthFrameffi(0, color, width, height)
                }
            }
        } finally {
            synchronized(mtx) {
                decoding = false
                if (releasePending) {
                    // release 已请求：解码结束后立即销毁，本次返回失败
                    if (let Some(i) <- dec) {
                        i.release()
                    }
                    decoder = None
                    encoded = None
                } else if (code == 0) {
                    ok = true
                }
            }
        }
        if (!ok) {
            value.isSuccess = false
            value.code = code
            return value
        }
        // 缓存写入（key 与首建语义一致：使用调用方传入的宽高，而非解析后的实际宽高，
        // 与 getMemoryCache(uri, 0, 0) 的读取 key 对齐）
        if (count == 1) {
            let cacheBean: CacheBean = CacheBean(color)
            // bean 记录解析后的真实数据宽高（imageWidth/Height 为 0 时已解析为 decoder 实际尺寸）；
            // key 仍用调用方传入的宽高对齐（与 getMemoryCache(uri, 0, 0) 的读取一致）
            cacheBean.setMemoryWidth(Int64(width))
            cacheBean.setMemoryHeight(Int64(height))
            cacheBean.setAlphaPresent(alpha)
            let memKey = getmd5key(mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
            memoryLruCache.put(memKey, cacheBean)
        }
        let diskKey = getmd5key(mUri.toArray())
        if (let Some(j) <- encoded) {
            let fileExist = FileUtils.getInstance().exist(fileLruCache.path + diskKey)
            if (!fileExist && mUri.toAsciiLower().startsWith("http")) {
                fileLruCache.put(diskKey, j.size, j)
            }
        }
        value.isSuccess = true
        value.code = code
        value.color = color
        return value
    }

    public func nextFrameffiAsync(imageWidth: Int32, imageHeight: Int32): ReturnValue {
        return decodeFrame(imageWidth, imageHeight, false, 0)
    }

    public func nthFrameffiAsync(index: Int32, imageWidth: Int32, imageHeight: Int32): ReturnValue {
        return decodeFrame(imageWidth, imageHeight, true, index)
    }

    // SEC-M2/异常安全：spawn 内只捕获 let（不可变），异常在方法内部转为失败返回值，
    // 保证互操作 Promise 必定 resolve（不因异常逃逸导致 await 永久挂起）
    private func safeCreateAsync(uri: String): Bool {
        try {
            return createAsync(uri)
        } catch (e: Exception) {
            Hilog.error(0, "aviflog", "createAsync exception: ${e}")
            return false
        }
    }

    private func safeCreateWithThreadAsync(uri: String, threads: Int32): Bool {
        try {
            return createWithThreadAsync(uri, threads)
        } catch (e: Exception) {
            Hilog.error(0, "aviflog", "createWithThreadAsync exception: ${e}")
            return false
        }
    }

    private func safeNextFrame(imageWidth: Int32, imageHeight: Int32): ReturnValue {
        try {
            return nextFrameffiAsync(imageWidth, imageHeight)
        } catch (e: Exception) {
            Hilog.error(0, "aviflog", "nextFrame exception: ${e}")
            let v = ReturnValue()
            v.code = -1
            v.isSuccess = false
            return v
        }
    }

    private func safeNthFrame(index: Int32, imageWidth: Int32, imageHeight: Int32): ReturnValue {
        try {
            return nthFrameffiAsync(index, imageWidth, imageHeight)
        } catch (e: Exception) {
            Hilog.error(0, "aviflog", "nthFrame exception: ${e}")
            let v = ReturnValue()
            v.code = -1
            v.isSuccess = false
            return v
        }
    }

    public func release(): Unit {
        // SEC-M2 修复：与解码线程协同——解码进行中只标记 releasePending，
        // 解码线程结束后自行销毁；避免 use-after-free，且不阻塞 JS 线程
        synchronized(mtx) {
            releasePending = true
            if (!decoding) {
                if (let Some(i) <- decoder) {
                    i.release()
                }
                decoder = None
                encoded = None
            }
        }
    }

    public static func createAsync_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        let arg1774848261264216600 = String.fromJSValue(context, callInfo[0])

        JSCurrentJSContext.set(context)
        let promise = context.promiseCapability()
        spawn {
            let RET = clazz.safeCreateAsync(arg1774848261264216600)
            context.postJSTask {
                newScope(context) {
                    promise.resolve(RET.toJSValue(context))
                }
            }
        }
        JSCurrentJSContext.unset()
        promise.toJSValue()
    }

    public static func createWithThreadAsync_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        let arg1774848261265021900 = String.fromJSValue(context, callInfo[0])
        let arg1774848261265048800 = Int32.fromJSValue(context, callInfo[1])

        JSCurrentJSContext.set(context)
        let promise = context.promiseCapability()
        spawn {
            let RET = clazz.safeCreateWithThreadAsync(arg1774848261265021900, arg1774848261265048800)
            context.postJSTask {
                newScope(context) {
                    promise.resolve(RET.toJSValue(context))
                }
            }
        }
        JSCurrentJSContext.unset()
        promise.toJSValue()
    }

    public static func getWidth_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        JSCurrentJSContext.set(context)
        let RET = clazz.getWidth()
        JSCurrentJSContext.unset()
        RET.toJSValue(context)
    }

    public static func getHeight_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        JSCurrentJSContext.set(context)
        let RET = clazz.getHeight()
        JSCurrentJSContext.unset()
        RET.toJSValue(context)
    }

    public static func getDepth_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        JSCurrentJSContext.set(context)
        let RET = clazz.getDepth()
        JSCurrentJSContext.unset()
        RET.toJSValue(context)
    }

    public static func getAlphaPresent_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        JSCurrentJSContext.set(context)
        let RET = clazz.getAlphaPresent()
        JSCurrentJSContext.unset()
        RET.toJSValue(context)
    }

    public static func getFrameCount_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        JSCurrentJSContext.set(context)
        let RET = clazz.getFrameCount()
        JSCurrentJSContext.unset()
        RET.toJSValue(context)
    }

    public static func getRepetitionCount_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        JSCurrentJSContext.set(context)
        let RET = clazz.getRepetitionCount()
        JSCurrentJSContext.unset()
        RET.toJSValue(context)
    }

    public static func getFrameDurations_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        JSCurrentJSContext.set(context)
        let RET = clazz.getFrameDurations()
        JSCurrentJSContext.unset()
        RET.toJSValue(context)
    }

    public static func isAvifImageffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        let argJsArrayBuffer = callInfo[0].asArrayBuffer(context)

        JSCurrentJSContext.set(context)
        let RET = clazz.isAvifImageffi(argJsArrayBuffer.toUInt8Array())
        JSCurrentJSContext.unset()
        RET.toJSValue(context)
    }

    public static func nextFrameIndexffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        JSCurrentJSContext.set(context)
        let RET = clazz.nextFrameIndexffi()
        JSCurrentJSContext.unset()
        RET.toJSValue(context)
    }

    public static func nextFrameffiAsync_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        let arg1774848261267312300 = Int32.fromJSValue(context, callInfo[0])
        let arg1774848261267338400 = Int32.fromJSValue(context, callInfo[1])

        JSCurrentJSContext.set(context)
        let promise = context.promiseCapability()
        spawn {
            let RET = clazz.safeNextFrame(arg1774848261267312300, arg1774848261267338400)
            context.postJSTask {
                newScope(context) {
                    let obj = context.object()
                    obj.setProperty("code", RET
                        .code
                        .toJSValue(context))
                    obj.setProperty("color", RET
                        .color
                        .toJSValue(context))
                    obj.setProperty("issuccess", RET
                        .isSuccess
                        .toJSValue(context))
                    obj.setProperty("memoryWidth", RET
                        .memoryWidth
                        .toJSValue(context))
                    obj.setProperty("memoryHeight", RET
                        .memoryHeight
                        .toJSValue(context))
                     obj.setProperty("isAlphaPresent", RET
                        .isAlphaPresent
                        .toJSValue(context))
                    promise.resolve(obj.toJSValue())
                }
            }
        }
        JSCurrentJSContext.unset()
        promise.toJSValue()
    }

    public static func nthFrameffiAsync_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        let arg1774848261267937800 = Int32.fromJSValue(context, callInfo[0])
        let arg1774848261267976000 = Int32.fromJSValue(context, callInfo[1])
        let arg1774848261268000400 = Int32.fromJSValue(context, callInfo[2])
        JSCurrentJSContext.set(context)
        let promise = context.promiseCapability()
        spawn {
            let RET = clazz.safeNthFrame(arg1774848261267937800, arg1774848261267976000, arg1774848261268000400)
            context.postJSTask {
                newScope(context) {
                    let obj = context.object()
                    obj.setProperty("code", RET
                        .code
                        .toJSValue(context))
                    obj.setProperty("color", RET
                        .color
                        .toJSValue(context))
                    obj.setProperty("issuccess", RET
                        .isSuccess
                        .toJSValue(context))
                    obj.setProperty("memoryWidth", RET
                        .memoryWidth
                        .toJSValue(context))
                    obj.setProperty("memoryHeight", RET
                        .memoryHeight
                        .toJSValue(context))
                    obj.setProperty("isAlphaPresent", RET
 	                    .isAlphaPresent
 	                    .toJSValue(context))
                    promise.resolve(obj.toJSValue())
                }
            }
        }
        JSCurrentJSContext.unset()
        promise.toJSValue()
    }

    public static func release_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        JSCurrentJSContext.set(context)
        let RET = clazz.release()
        JSCurrentJSContext.unset()
        RET.toJSValue(context)
    }

    public func toJSValue(context: JSContext): JSValue {
        let ext = context.external(this)
        let obj = context.object()

        obj["createAsync"] = context
            .function(createAsync_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["createWithThreadAsync"] = context
            .function(createWithThreadAsync_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["getWidth"] = context
            .function(getWidth_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["getHeight"] = context
            .function(getHeight_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["getDepth"] = context
            .function(getDepth_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["getAlphaPresent"] = context
            .function(getAlphaPresent_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["getFrameCount"] = context
            .function(getFrameCount_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["getRepetitionCount"] = context
            .function(getRepetitionCount_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["getFrameDurations"] = context
            .function(getFrameDurations_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["isAvifImageffi"] = context
            .function(isAvifImageffi_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["nextFrameIndexffi"] = context
            .function(nextFrameIndexffi_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["nextFrameffiAsync"] = context
            .function(nextFrameffiAsync_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["nthFrameffiAsync"] = context
            .function(nthFrameffiAsync_ArkTS_Interop_Identifier)
            .toJSValue()

        obj["release"] = context
            .function(release_ArkTS_Interop_Identifier)
            .toJSValue()

        obj.attachCJObject(ext)
        obj.toJSValue()
    }

    public static func fromJSValue(context: JSContext, input: JSValue) {
        let jsObj = input.asObject(context)
        let jsExt = jsObj.getAttachInfo() ?? throw Exception("class: get external failed.")
        let obj = jsExt.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")
        return obj
    }
    public static func toArkTsType(): String {
        "class"
    }

    private var decoder: Option<AvifDecoder> = None
    var mUri = ""
    var encoded: ?Array<Byte> = None
    private let mtx = ReentrantMutex()       // SEC-M2: 保护 decoder 状态与 native 调用
    private var decoding = false             // mtx 保护：native 解码进行中
    private var releasePending = false       // mtx 保护：release 已请求，解码结束后销毁
    func createLoginc(buffer: Array<UInt8>, threads: Int32): Option<CJAvifDecoder> {
        synchronized(mtx) {
            encoded = buffer
            decoder = AvifDecoder(buffer, threads)
            if (let Some(k) <- decoder) {
                if (k.decoder == 0) {
                    return Option<CJAvifDecoder>.None
                }
                return this
            } else {
                return Option<CJAvifDecoder>.None
            }
        }
    }
}
