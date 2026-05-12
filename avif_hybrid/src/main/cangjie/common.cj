package avif4cj

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

//100.percent 100%
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
        case value.endsWith("vp") =>
            LengthType.vp(number)
        case value.endsWith("px") =>
            LengthType.px(number)
        case value.endsWith("%") =>
            LengthType.percent(number/100.0)
        case value.endsWith("lpx") =>
            LengthType.lpx(number)
        case value.endsWith("fp") =>
            LengthType.fp(number)
        case _ =>
            LengthType.vp(number)
    }
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

/**
 * 设置StageContext互操作函数
 *
 * @param runtime JSContext
 * @param callInfo 接口数据
 * @return JSValue 返回值
 */
func setGlobalContext(runtime: JSContext, callInfo: JSCallInfo): JSValue {
    let jsEnv = runtime.getNapiEnv()
    let jsValue = arkTsValuetoNapiValue(jsEnv, callInfo[0])
    if (isStageMode(jsEnv, jsValue)) {
        GlobalContext.setContext(getContextStageMode(jsEnv, jsValue))
    } else {
    }
    return runtime.undefined().toJSValue()
}

func setMemoryLruCache(runtime: JSContext, callInfo: JSCallInfo):JSValue{
    let countSize =Int64(callInfo[0].toNumber())
    let memorySize =Int64(callInfo[1].toNumber())
    memoryLruCache.setSize(countSize,memorySize)
    return runtime.undefined().toJSValue()
}

func setFileLruCache(runtime: JSContext, callInfo: JSCallInfo):JSValue{
    let countSize =Int64(callInfo[0].toNumber())
    let memorySize =Int64(callInfo[1].toNumber())
    fileLruCache.setSize(countSize,memorySize)
    return runtime.undefined().toJSValue()
}





