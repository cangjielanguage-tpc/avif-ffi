/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package ohos_app_cangjie_avif4hybrid
import ohos.ark_interop.JSObject
import ohos.base.Length


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
            //LengthType.vp(number)
            number.vp
        case value.endsWith("px") =>
            //LengthType.px(number)
            number.px
        case value.endsWith("%") =>
            //LengthType.percent(number/100.0)
            number.percent
        case _ =>
            //LengthType.vp(number)
            number.vp
    }
}

public func getLoadCJPage(ctx: JSContext, callInfo: JSCallInfo): JSValue {
    var model: ?CJAvifImageModel = None
    if (callInfo[0].typeof() != JSType.UNDEFINED) {
        let cfgObj: JSObject = callInfo[0].asObject()
        let cfgExt: Option<JSExternal> = cfgObj.getAttachInfo()
        if (let Some(v) <- cfgExt) {
            model = v.cast<CJAvifImageModel>()
        }
    }
    let elmetId = ViewStackProcessor.allocateNewElmetIdForNextComponent()
    ViewStackProcessor.startGetAccessRecordingFor(elmetId)
    let comp = CJAvifView(
        Option<CustomView>.None,
        cjmodel: ObservedProperty<Option<CJAvifImageModel>>("", model)
    )
    CustomView.create(comp)
    ViewStackProcessor.stopGetAccessRecording()
    return ctx
        .function(
            {
                ctx1: JSContext, callInfo1: JSCallInfo =>
                return ctx.undefined().toJSValue()
            }
        )
        .toJSValue()
}





