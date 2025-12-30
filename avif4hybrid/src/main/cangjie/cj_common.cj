/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package ohos_app_cangjie_avif4hybrid
import std.collection.concurrent.ConcurrentHashMap
import std.collection.HashMap
import ohos.base.Main
import ohos.ark_interop.JSCodeError
import ohos.base.BusinessException
import ohos.ark_interop.JSObject
import std.collection.ArrayList
import std.sync.ReentrantMutex
import ohos.ark_interop.JSRuntime
import ohos.base.LengthType
import std.process.Process
import ohos.base.Length

var tempArrayList: ArrayList<JSValue> = ArrayList<JSValue>()
/**
 * JSContext
 */
//public var context: ?JSContext = None
protected let emptyArg = {ctx: JSContext => Array<JSValue>()}
private let MAIN_CONTEXT_MODULE_MAP = ConcurrentHashMap<String, JSObject>()
protected var mainThreadRuntime = None<JSRuntime>
protected var mainThreadContext = None<JSContext>
private var lock = ReentrantMutex()
private let mainThreadId = Process.current.pid
// only run in hybrid mode
private let REG_CTX = JSModule.registerModule {
    ctx, _ => mainThreadContext = ctx
}
let g_globalObjHashMap: HashMap<String, JSObject> = HashMap<String, JSObject>()

foreign func gettid(): Int64

let _ = {
    => JSModule.registerModule(
        {
            ctx, exports =>
            context = ctx
            exports
        }
    )
}()

public func getCtx() {
    let content = context ?? throw JSInteropNativeError("Component InterOp: get global context failed.")
    return content
}

protected func getMainContext(): JSContext {
    if (let Some(v) <- mainThreadContext) {
        return v
    }

    func initJs(): JSContext {
        synchronized(lock) {
            if (let Some(v) <- mainThreadContext) {
                v
            } else {
                let rt = JSRuntime()
                mainThreadRuntime = rt
                mainThreadContext = rt.mainContext
                rt.mainContext
            }
        }
    }

    let curTid = unsafe { gettid() }
    if (curTid == mainThreadId) {
        initJs()
    } else {
        let f = spawn (Main) {
            initJs()
        }
        f.get()
    }
}

protected func getJSModule(ctx: JSContext, name: String, prefix: ?String, isHsp!: Bool = false): JSObject {
    match (MAIN_CONTEXT_MODULE_MAP.get(name)) {
        case Some(v) => v
        case None =>
            let module = if (isHsp) {
                ctx.global[name.replace('.', "_")].asObject(ctx)
            } else {
                ctx.requireSystemNativeModule(name, prefix: prefix).asObject(ctx)
            }
            MAIN_CONTEXT_MODULE_MAP.add(name, module)
            module
    }
}

protected func jsGlobalApiCall<T>(moduleName: String, modulePrefix: ?String, funcName: String,
    args: (JSContext) -> Array<JSValue>, onResolve: (JSContext, JSValue) -> T): T {
    func call(context: JSContext): T {
        try {
            let jsModule = getJSModule(context, moduleName, modulePrefix)
            let jsRet = jsModule.callMethod(funcName, args(context))
            onResolve(context, jsRet)
        } catch (e: JSCodeError) {
            throw BusinessException(e.code.getOrDefault({=> 0}), e.jsError)
        }
    }
    checkThreadAndCall<T>(getMainContext(), call)
}

protected func ohosGlobalApiCall<T>(moduleName: String, funcName: String, args: (JSContext) -> Array<JSValue>,
    onResolve: (JSContext, JSValue) -> T): T {
    jsGlobalApiCall<T>(moduleName, None<String>, funcName, args, onResolve)
}

protected func ohosGlobalApiCall<T>(moduleName: String, funcName: String, args: (JSContext) -> Array<JSValue>): T where T <: JSInteropType<T> {
    ohosGlobalApiCall<T>(moduleName, funcName, args) {ctx, info => T.fromJSValue(ctx, info)}
}

protected func jsObjApiCall<T>(obj: JSObject, funcName: String, args: (JSContext) -> Array<JSValue>,
    onResolve: (JSContext, JSValue) -> T): T {
    func call(context: JSContext): T {
        try {
            let jsRet = obj.callMethod(funcName, args(context))
            onResolve(context, jsRet)
        } catch (e: JSCodeError) {
            throw BusinessException(e.code.getOrDefault({=> 0}), e.jsError)
        }
    }
    checkThreadAndCall<T>(getMainContext(), call)
}

protected func jsObjApiCall<T>(obj: JSObject, funcName: String, args: (JSContext) -> Array<JSValue>): T where T <: JSInteropType<T> {
    jsObjApiCall<T>(obj, funcName, args) {ctx, info => T.fromJSValue(ctx, info)}
}

public func getGlobalObject(className: String, useCache!: ?Bool = true): JSObject {
    if (useCache == true && g_globalObjHashMap.contains(className)) {
        return g_globalObjHashMap[className]
    }
    let ctx = context.getOrThrow()
    let globalThis = ctx.global
    if (!globalThis.hasProperty(className)) {
        throw IllegalArgumentException("there is no ${className} in globalThis")
    }
    if (useCache == false) {
        return globalThis[className].asObject()
    }
    g_globalObjHashMap[className] = globalThis[className].asObject()
    return g_globalObjHashMap[className]
}

protected func checkThreadAndCall<T>(ctx: JSContext, f: (JSContext) -> T): T {
    if (ctx.isInBindThread()) {
        f(ctx)
    } else {
        let fut = spawn (Main) {
            f(ctx)
        }
        fut.get()
    }
}

public func convertJSValueToLength(context: JSContext, input: JSValue): Length {
    if (input.isNumber()) {
        return input.toNumber().vp
    }
    if (input.isString()) {
        var retValue = input.toString()
        return string2Length(retValue)
    }
    return 0.vp
}

//100.percent
func string2Length(value: String): Length {
    var str = ""
    for (r in value.runes()) {
        if (r.isAsciiNumber()) {
            str += r.toString()
        } else {
            break
        }
    }
    var number = Float64.tryParse(str) ?? 0.0
    return match {
        case value.endsWith("vp") => LengthType.vp(number)
        case value.endsWith("px") => LengthType.px(number)
        case value.endsWith("%") => LengthType.percent(number)
        case value.endsWith("lpx") => LengthType.lpx(number)
        case value.endsWith("fp") => LengthType.fp(number)
        case _ => LengthType.vp(number)
    }
}

public open class InteropObjectBase {
    protected var jsObj: ?JSObject = None
    private let globalThis = getCtx().global

    init() {}

    protected init(obj: JSObject) {
        jsObj = obj
    }

    protected init(objName: JSKeyable) {
        if (!globalThis.hasProperty(objName)) {
            throw IllegalArgumentException("there is no ${objName} in globalThis")
        }
        jsObj = globalThis[objName].asClass().new().asObject()
    }

    protected init(objName: JSKeyable, args: Array<JSValue>) {
        if (!globalThis.hasProperty(objName)) {
            throw IllegalArgumentException("there is no ${objName} in globalThis")
        }
        jsObj = globalThis[objName].asClass().new(args).asObject()
    }

    protected func getObjectName(): String {
        let constructor = jsObj.getOrThrow()["constructor"]
        if (constructor.isUndefined()) {
            "object"
        } else {
            String.fromJSValue(getCtx(), constructor.asObject()["name"])
        }
    }

    protected func callMethod(key: JSKeyable, args: (JSContext) -> Array<JSValue>): JSValue {
        jsObj.getOrThrow().callMethod(key, args(getCtx()))
    }

    protected func callMethod(key: JSKeyable): JSValue {
        jsObj.getOrThrow().callMethod(key)
    }

    protected func getObj(): JSObject {
        jsObj.getOrThrow()
    }

    protected func getProp(key: JSKeyable): JSValue {
        jsObj.getOrThrow()[key]
    }

    protected func setProp(key: JSKeyable, value: JSValue) {
        jsObj.getOrThrow()[key] = value
    }

    protected open func toJSValue(_: JSContext): JSValue {
        jsObj.getOrThrow().toJSValue()
    }

    static func fromJSValue(_: JSContext, input: JSValue): InteropObjectBase {
        InteropObjectBase(input.asObject())
    }
}

// 基础数据类型使用此方法转换array
public func arrayObj2JSValueBase<T>(value: Array<T>, ctx: JSContext) where T <: JSInteropType<T> {
    value |> forEach<T>({item: T => tempArrayList.add(item.toJSValue(ctx))})
    var ret = ctx.array(tempArrayList.toArray()).toJSValue()
    tempArrayList.clear()
    return ret
}

public func getLoadCJPage(ctx: JSContext, callInfo: JSCallInfo): JSValue {
    var model: ?CJAvifImageModel = None
    if (callInfo[0].typeof() != JSType.UNDEFINED) {
        let cfgObj: JSObject = callInfo[0].asObject(ctx)
        let cfgExt: Option<JSExternal> = cfgObj.getAttachInfo()
        if (let Some(v) <- cfgExt) {
            model = v.cast<CJAvifImageModel>()
        }
    }
    let elmetId = ViewStackProcessor.AllocateNewElmetIdForNextComponent()
    ViewStackProcessor.StartGetAccessRecordingFor(elmetId)
    let comp = CJAvifView(
        Option<CustomView>.None,
        cjmodel: ObservedProperty<Option<CJAvifImageModel>>("", model)
    )
    CustomView.create(comp)
    ViewStackProcessor.StopGetAccessRecording()
    return ctx
        .function(
            {
                ctx1: JSContext, callInfo1: JSCallInfo =>
                return ctx.undefined().toJSValue()
            }
        )
        .toJSValue()
}

var imageResource: ?AppResource = None
var errorResource: ?AppResource = None

public func getCJResource(ctx: JSContext, callInfo: JSCallInfo): JSValue {
    if (callInfo[0].typeof() != JSType.UNDEFINED) {
        imageResource = arktsRes2CJResource(ctx, callInfo[0])
    }
    if (callInfo[1].typeof() != JSType.UNDEFINED) {
        errorResource = arktsRes2CJResource(ctx, callInfo[1])
    }
    return ctx.undefined().toJSValue()
}

func arktsRes2CJResource(ctx: JSContext, value: JSValue): AppResource {
    let obj = value.asObject()
    AppResource(
        String.fromJSValue(ctx, obj["bundleName"]),
        String.fromJSValue(ctx, obj["moduleName"]),
        Int32.fromJSValue(ctx, obj["id"]),
        params:[],
        resType: Int32.fromJSValue(ctx, obj["type"]),
    )
}
