package ohos_app_cangjie_avif4hybrid

import ohos.ark_interop_macro.Interop

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
        if (uri.startsWith("http")) {
            let mDiskKey: String = getmd5key(this
                .mUri
                .toArray())
            let fileExist = FileUtils
                .getInstance()
                .exist(fileLruCache.path + mDiskKey)
            if (fileExist) {
                let source: ?Array<UInt8> = FileUtils.getInstance().readFileSync(fileLruCache.path + mDiskKey)
                if (let Some(i) <- source) {
                    createLoginc(i, threads)
                    return true
                }
            }
            let imageBuffer = getImageFromNet(uri)
            if (let Some(i) <- imageBuffer) {
                createLoginc(i, threads)
                return true
            } else {
                Hilog.error(0, "getImageFromNet", "获取网络文件内容失败")
                return false
            }
        } else if (uri.startsWith("rawfile://")) {
            let fileName = uri.removePrefix("rawfile://")
            let imageBuffer = getImageFromRawFile(fileName)
            if (let Some(i) <- imageBuffer) {
                createLoginc(i, threads)
                return true
            } else {
                Hilog.error(0, "getImageFromRawFile", "获取raw文件内容失败")
                return false
            }
        } else if (uri.startsWith("media://")) {
            let mediaName = uri.removePrefix("media://")
            let imageBuffer = getImageFromMedia(mediaName)
            if (let Some(i) <- imageBuffer) {
                createLoginc(i, threads)
                return true
            } else {
                Hilog.error(0, "getImageFromMedia", "获取media文件内容失败")
                return false
            }
        } else if (uri.startsWith("file://")) {
            let localFilePath = uri.removePrefix("file://")
            let imageBuffer: ?Array<UInt8> = FileUtils
                .getInstance()
                .readFileSync(localFilePath)
            if (let Some(i) <- imageBuffer) {
                createLoginc(i, threads)
                return true
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
                createLoginc(i, threads)
                return true
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

    public func isAvifImageffi(): Int32 {
        if (let Some(i) <- decoder) {
            if (let Some(j) <- encoded) {
                return i.isAvifImageffi(j)
            }
        }
        return 0
    }

    public func nextFrameIndexffi(): Int32 {
        if (let Some(i) <- decoder) {
            return i.nextFrameIndexffi()
        }
        return 0
    }

    public func nextFrameffiAsync(imageWidth: Int32, imageHeight: Int32): ReturnValue {
        let value: ReturnValue = ReturnValue()
        if (imageWidth < 0 || imageHeight < 0) {
            value.isSuccess = false
            return value
        }
        let count: Int64 = getFrameCount()
        if (count <= 0) {
            value.isSuccess = false
            return value
        }
        mDiskKey = getmd5key(this
            .mUri
            .toArray())
        if (count == 1) {
            mMemoryKey = getmd5key(this
                .mUri
                .toArray(), Int64(imageWidth), Int64(imageHeight)) + "notcomponent"
        }
        var realPicWidth = imageWidth
        var realPicHeight = imageHeight
        if (imageWidth == 0) {
            realPicWidth = Int32(getWidth())
        }
        if (imageHeight == 0) {
            realPicHeight = Int32(getHeight())
        }
        let color: Array<Byte> = Array<Byte>(Int64(realPicWidth * realPicHeight * 4), repeat: 0)
        if (let Some(i) <- decoder) {
            value.code = i.nextFrameffi(color, realPicWidth, realPicHeight)
            let cacheWidth = realPicWidth
            let cacheHeight = realPicHeight
            if (value.code == 0) {
                spawn {
                    if (count == 1) {
                        let cacheBean: CacheBean = CacheBean(Option<PixelMap>.None, color)
                        cacheBean.setMemoryWidth(Int64(cacheWidth))
                        cacheBean.setMemoryHeight(Int64(cacheHeight))
                        // 注意：alphaPremultiplied 已改为 AVIF_FALSE（非预乘模式）
                        // 需要正确传递 alpha 状态，以避免透明图片显示全黑或灰色
                        cacheBean.setAlphaPresent(getAlphaPresent())
                        memoryLruCache.put(mMemoryKey, cacheBean)
                    }

                    if (let Some(j) <- encoded) {
                        let fileExist = FileUtils
                            .getInstance()
                            .exist(fileLruCache.path + mDiskKey)
                        if (!fileExist && mUri.startsWith("http")) {
                            fileLruCache.put(mDiskKey, j.size, j)
                        }
                    }
                }
                value.isSuccess = true
                value.color = color
            } else {
                value.isSuccess = false
            }
            return value
        } else {
            value.isSuccess = false
            return value
        }
    }

    public func nthFrameffiAsync(index: Int32, imageWidth: Int32, imageHeight: Int32): ReturnValue {
        let value: ReturnValue = ReturnValue()
        if (imageWidth < 0 || imageHeight < 0) {
            value.isSuccess = false
            return value
        }
        let count: Int64 = getFrameCount()
        if (count <= 0) {
            value.isSuccess = false
            return value
        }
        mDiskKey = getmd5key(this
            .mUri
            .toArray())
        if (count == 1) {
            mMemoryKey = getmd5key(this
                .mUri
                .toArray(), Int64(imageWidth), Int64(imageHeight)) + "notcomponent"
        }
        var realPicWidth = imageWidth
        var realPicHeight = imageHeight
        if (imageWidth == 0) {
            realPicWidth = Int32(getWidth())
        }
        if (imageHeight == 0) {
            realPicHeight = Int32(getHeight())
        }
        let color: Array<Byte> = Array<Byte>(Int64(realPicWidth * realPicHeight * 4), repeat: 0)
        if (let Some(i) <- decoder) {
            if (count == 1) {
                value.code = i.nthFrameffi(0, color, realPicWidth, realPicHeight)
            } else {
                value.code = i.nthFrameffi(index, color, realPicWidth, realPicHeight)
            }
            let cacheWidth = realPicWidth
            let cacheHeight = realPicHeight
            if (value.code == 0) {
                spawn {
                    if (count == 1) {
                        let cacheBean: CacheBean = CacheBean(Option<PixelMap>.None, color)
                        cacheBean.setMemoryWidth(Int64(cacheWidth))
                        cacheBean.setMemoryHeight(Int64(cacheHeight))
                        // 注意：alphaPremultiplied 已改为 AVIF_FALSE（非预乘模式）
                        // 需要正确传递 alpha 状态，以避免透明图片显示全黑或灰色
                        cacheBean.setAlphaPresent(getAlphaPresent())
                        memoryLruCache.put(mMemoryKey, cacheBean)
                    }

                    if (let Some(j) <- encoded) {
                        let fileExist = FileUtils
                            .getInstance()
                            .exist(fileLruCache.path + mDiskKey)
                        if (!fileExist && mUri.startsWith("http")) {
                            fileLruCache.put(mDiskKey, j.size, j)
                        }
                    }
                }
                value.isSuccess = true
                value.color = color
            } else {
                value.isSuccess = false
            }
            return value
        } else {
            value.isSuccess = false
            return value
        }
    }

    public func release(): Unit {
        if (let Some(i) <- decoder) {
            return i.release()
        }
    }

    @When[arch == "aarch64"]
    public static func createAsync_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

        let arg1774848261264216600 = String.fromJSValue(context, callInfo[0])

        JSCurrentJSContext.set(context)
        let promise = context.promiseCapability()
        spawn {
            let RET = clazz.createAsync(arg1774848261264216600)
            context.postJSTask {
                newScope(context) {
                    promise.resolve(RET.toJSValue(context))
                }
            }
        }
        JSCurrentJSContext.unset()
        promise.toJSValue()
    }

    @When[arch == "aarch64"]
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
            let RET = clazz.createWithThreadAsync(arg1774848261265021900, arg1774848261265048800)
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

        JSCurrentJSContext.set(context)
        let RET = clazz.isAvifImageffi()
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

    @When[arch == "aarch64"]
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
            let RET = clazz.nextFrameffiAsync(arg1774848261267312300, arg1774848261267338400)
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

    @When[arch == "aarch64"]
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
            let RET = clazz.nthFrameffiAsync(arg1774848261267937800, arg1774848261267976000, arg1774848261268000400)
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
    var mMemoryKey = ""
    var mDiskKey = ""
    var mUri = ""
    var encoded: ?Array<Byte> = None
    func createLoginc(buffer: Array<UInt8>, threads: Int32): Option<CJAvifDecoder> {
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
