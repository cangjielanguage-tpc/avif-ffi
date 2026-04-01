package ohos_app_cangjie_avif4hybrid

import ohos.ark_interop_macro.Interop

public class CJCacheCheck <: SharedObject & JSInteropType<CJCacheCheck> {
    static init() {
        JSModule.registerClass("CJCacheCheck") {
            context =>
                let clazz = context.clazz(jsConstructor)

                clazz.addMethod("getMemoryCache", context.function(getMemoryCache_ArkTS_Interop_Identifier))

                return clazz
        }
    }

    public init() {
    }

    public static func jsConstructor(context: JSContext, callInfo: JSCallInfo): JSValue {
        JSCurrentJSContext.set(context)
        let clazz = CJCacheCheck()
        JSCurrentJSContext.unset()
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = context.external(clazz)
        thisObject.attachCJObject(jsExternal)
        return thisObject.toJSValue()
    }

    public func getMemoryCache(uri: String, imagePicWidth: Int64, imagePicHeight: Int64): ReturnValue {
        let value: ReturnValue = ReturnValue()
        let key = getmd5key(uri.toArray(), imagePicWidth, imagePicHeight) + "notcomponent"
        let memCache: ?CacheBean = memoryLruCache.get(key)
        if (let Some(i) <- memCache) {
            let arrData: ?Array<UInt8> = i.getPicData()
            if (let Some(j) <- arrData) {
                value.color = j
                value.memoryWidth = i.getMemoryWidth()
                value.memoryHeight = i.getMemoryHeight()
                value.isSuccess = true
                return value
            } else {
                value.isSuccess = false
                return value
            }
        } else {
            value.isSuccess = false
            return value
        }
    }

    public static func getMemoryCache_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
        let thisArg = callInfo.thisArg
        let thisObject = thisArg.asObject(context)
        let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
        let clazz = jsExternal.cast<CJCacheCheck>() ?? throw Exception("class: get clazz failed.")

        let arg1774849430649291400 = String.fromJSValue(context, callInfo[0])
        let arg1774849430649337700 = Int64.fromJSValue(context, callInfo[1])
        let arg1774849430649358200 = Int64.fromJSValue(context, callInfo[2])

        JSCurrentJSContext.set(context)
        let RET = clazz.getMemoryCache(arg1774849430649291400, arg1774849430649337700, arg1774849430649358200)
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
        JSCurrentJSContext.unset()
        obj.toJSValue()
    }

    public func toJSValue(context: JSContext): JSValue {
        let ext = context.external(this)
        let obj = context.object()

        obj["getMemoryCache"] = context
            .function(getMemoryCache_ArkTS_Interop_Identifier)
            .toJSValue()

        obj.attachCJObject(ext)
        obj.toJSValue()
    }

    public static func fromJSValue(context: JSContext, input: JSValue) {
        let jsObj = input.asObject(context)
        let jsExt = jsObj.getAttachInfo() ?? throw Exception("class: get external failed.")
        let obj = jsExt.cast<CJCacheCheck>() ?? throw Exception("class: get clazz failed.")
        return obj
    }
    public static func toArkTsType(): String {
        "class"
    }
}
