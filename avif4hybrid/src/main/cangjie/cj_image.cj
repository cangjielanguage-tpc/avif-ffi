/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package ohos_app_cangjie_avif4hybrid
import ohos.ark_interop.JSObject
import ohos.ark_interop.JSValue
import ohos.ark_interop.JSCodeError
import ohos.base.BusinessException

public func jsObjApiCallNotT(obj: JSObject, funcName: String, args: (JSContext) -> Array<JSValue>) {
    try {
        obj.callMethod(funcName, args(getCtx()))
    } catch (e: Exception) {
        throw BusinessException(10000, "Cannot find the ${funcName}")
    }
}

public func jsObjApiCallNotT(obj: JSObject, funcName: String) {
    try {
        obj.callMethod(funcName)
    } catch (e: JSCodeError) {
        throw BusinessException(10000, "Cannot excute the ${funcName} function")
    }
}


public class ImageSourceInterop {
    protected ImageSourceInterop(let arkts_object: JSObject) {}

    protected func toJSValue(_: JSContext): JSValue {
        arkts_object.toJSValue()
    }

    protected static func fromJSValue(_: JSContext, input: JSValue): ImageSourceInterop {
        ImageSourceInterop(input.asObject())
    }

    /**
     * Create a PixelMapInterop object based on image decoding parameters synchronously.
     *
     * @param { DecodingOptionsInterop } options - Image decoding parameters.
     * @returns { PixelMapInterop } Return the PixelMapInterop. If decoding fails, return undefined.
     * @syscap SystemCapability.Multimedia.Image.ImageSourceInterop
     * @crossplatform
     * @brief createPixelMapSync(options?: DecodingOptionsInterop): PixelMapInterop
     */
    public func createPixelMapInterop(options!: ?DecodingOptionsInterop = None): PixelMapInterop {
        if (let Some(v) <- options) {
            jsObjApiCall<PixelMapInterop>(arkts_object, "createPixelMapSync", {ctx => [v.toJSValue(ctx)]}) {
                ctx, info => PixelMapInterop.fromJSValue(ctx, info)
            }
        } else {
            jsObjApiCall<PixelMapInterop>(arkts_object, "createPixelMapSync", emptyArg) {
                ctx, info => PixelMapInterop.fromJSValue(ctx, info)
            }
        }
    }
}

/**
 * Describes image decoding parameters.
 *
 * @typedef DecodingOptionsInterop
 * @syscap SystemCapability.Multimedia.Image.ImageSourceInterop
 * @crossplatform
 * @form
 * @atomicservice
 */
public class DecodingOptionsInterop {
    public DecodingOptionsInterop(
        public var index!: ?Float64 = None,
        public var sampleSize!: ?Float64 = None,
        public var rotate!: ?Float64 = None,
        public var editable!: ?Bool = None
    ) {}

    protected func toJSValue(context: JSContext): JSValue {
        let obj = context.object()
        if (let Some(v) <- index) {
            obj["index"] = v.toJSValue(context)
        }
        if (let Some(v) <- sampleSize) {
            obj["sampleSize"] = v.toJSValue(context)
        }
        if (let Some(v) <- rotate) {
            obj["rotate"] = v.toJSValue(context)
        }
        if (let Some(v) <- editable) {
            obj["editable"] = v.toJSValue(context)
        }
        obj.toJSValue()
    }

    protected static func fromJSValue(context: JSContext, input: JSValue): DecodingOptionsInterop {
        let obj = input.asObject()
        DecodingOptionsInterop(
            index: if (obj["index"].isUndefined()) {
                None
            } else {
                Float64.fromJSValue(context, obj["index"])
            },
            sampleSize: if (obj["sampleSize"].isUndefined()) {
                None
            } else {
                Float64.fromJSValue(context, obj["sampleSize"])
            },
            rotate: if (obj["rotate"].isUndefined()) {
                None
            } else {
                Float64.fromJSValue(context, obj["rotate"])
            },
            editable: if (obj["editable"].isUndefined()) {
                None
            } else {
                Bool.fromJSValue(context, obj["editable"])
            }
        )
    }
}

public class PixelMapInterop {
    protected PixelMapInterop(let arkts_object: JSObject) {}

    protected func toJSValue(_: JSContext): JSValue {
        arkts_object.toJSValue()
    }

    protected static func fromJSValue(_: JSContext, input: JSValue): PixelMapInterop {
        PixelMapInterop(input.asObject())
    }

    public static func fromOhosValue(input: PixelMapInterop): PixelMapInterop {
        return PixelMapInterop.fromJSValue(getMainContext(), input.toJSValue(getMainContext()))
    }

    public func toOhosPixelMap(): PixelMapInterop {
        return PixelMapInterop.fromJSValue(getMainContext(), this.toJSValue(getMainContext()))
    }
}

public class CJImageCompleteInterop <: InteropObjectBase {
    public CJImageCompleteInterop(width: Float64, height: Float64, componentWidth: Float64, componentHeight: Float64,
        loadingStatus: Int64, contentWidth: Float64, contentHeight: Float64, contentOffsetX: Float64,
        contentOffsetY: Float64) {
        super(getCtx().object())
        setProp("width", width.toJSValue(getCtx()))
        setProp("height", height.toJSValue(getCtx()))
        setProp("componentWidth", componentWidth.toJSValue(getCtx()))
        setProp("componentHeight", componentHeight.toJSValue(getCtx()))
        setProp("loadingStatus", loadingStatus.toJSValue(getCtx()))
        setProp("contentWidth", contentWidth.toJSValue(getCtx()))
        setProp("contentHeight", contentHeight.toJSValue(getCtx()))
        setProp("contentOffsetX", contentOffsetX.toJSValue(getCtx()))
        setProp("contentOffsetY", contentOffsetY.toJSValue(getCtx()))
    }

    public prop width: Float64 {
        get() {
            Float64.fromJSValue(getCtx(), getProp("width"))
        }
    }

    public prop height: Float64 {
        get() {
            Float64.fromJSValue(getCtx(), getProp("height"))
        }
    }

    public prop componentWidth: Float64 {
        get() {
            Float64.fromJSValue(getCtx(), getProp("componentWidth"))
        }
    }

    public prop componentHeight: Float64 {
        get() {
            Float64.fromJSValue(getCtx(), getProp("componentHeight"))
        }
    }

    public prop loadingStatus: Int64 {
        get() {
            Int64.fromJSValue(getCtx(), getProp("loadingStatus"))
        }
    }

    public prop contentWidth: Float64 {
        get() {
            Float64.fromJSValue(getCtx(), getProp("contentWidth"))
        }
    }

    public prop contentHeight: Float64 {
        get() {
            Float64.fromJSValue(getCtx(), getProp("contentHeight"))
        }
    }

    public prop contentOffsetX: Float64 {
        get() {
            Float64.fromJSValue(getCtx(), getProp("contentOffsetX"))
        }
    }

    public prop contentOffsetY: Float64 {
        get() {
            Float64.fromJSValue(getCtx(), getProp("contentOffsetY"))
        }
    }

    static func fromJSValue(context: JSContext, input: JSValue): CJImageCompleteInterop {
        let width = Float64.fromJSValue(context, input.getProperty(context, "width"))
        let height = Float64.fromJSValue(context, input.getProperty(context, "height"))
        let componentWidth = Float64.fromJSValue(context, input.getProperty(context, "componentWidth"))
        let componentHeight = Float64.fromJSValue(context, input.getProperty(context, "componentHeight"))
        let loadingStatus = Int64.fromJSValue(context, input.getProperty(context, "loadingStatus"))
        let contentWidth = Float64.fromJSValue(context, input.getProperty(context, "contentWidth"))
        let contentHeight = Float64.fromJSValue(context, input.getProperty(context, "contentHeight"))
        let contentOffsetX = Float64.fromJSValue(context, input.getProperty(context, "contentOffsetX"))
        let contentOffsetY = Float64.fromJSValue(context, input.getProperty(context, "contentOffsetY"))
        CJImageCompleteInterop(width, height, componentWidth, componentHeight, loadingStatus, contentWidth, contentHeight,
            contentOffsetX, contentOffsetY)
    }
}

public class CJImageErrorInterop <: InteropObjectBase {
    public CJImageErrorInterop(componentWidth: Float64, componentHeight: Float64, message: String) {
        super(getCtx().object())
        setProp("componentWidth", componentWidth.toJSValue(getCtx()))
        setProp("componentHeight", componentHeight.toJSValue(getCtx()))
        setProp("message", message.toJSValue(getCtx()))
    }

    public prop componentWidth: Float64 {
        get() {
            Float64.fromJSValue(getCtx(), getProp("componentWidth"))
        }
    }

    public prop componentHeight: Float64 {
        get() {
            Float64.fromJSValue(getCtx(), getProp("componentHeight"))
        }
    }

    public prop message: String {
        get() {
            String.fromJSValue(getCtx(), getProp("message"))
        }
    }

    static func fromJSValue(context: JSContext, input: JSValue): CJImageErrorInterop {
        let componentWidth = Float64.fromJSValue(context, input.getProperty(context, "componentWidth"))
        let componentHeight = Float64.fromJSValue(context, input.getProperty(context, "componentHeight"))
        let message = String.fromJSValue(context, input.getProperty(context, "message"))
        CJImageErrorInterop(componentWidth, componentHeight, message)
    }
}

extend Image {
//    func interopDraggable(value: Bool): Image {
//        try {
//            let global = context.getOrThrow().global
//            let ctx = context.getOrThrow()
//            let image = global["Image"].asObject(ctx)
//            let draggable = image["draggable"].asFunction(ctx)
//            draggable.call(value.toJSValue(ctx))
//        } catch (e: Exception) {
//        }
//        return this
//    }

//    func interopOnComplete(value: (result: CJImageCompleteInterop) -> Unit): Image {
//        try {
//            let global = context.getOrThrow().global
//            let ctx = context.getOrThrow()
//            let image = global["Image"].asObject(ctx)
//            let argFunc = getCtx().function(
//                {
//                    context: JSContext, callInfo: JSCallInfo =>
//                    let ret = value(CJImageCompleteInterop.fromJSValue(context, callInfo[0]))
//                    ret.toJSValue(context)
//                }
//            ).toJSValue()
//            jsObjApiCallNotT(image, "onComplete", {ctx => [argFunc]})
//        } catch (e: Exception) {
//        }
//        return this
//    }

}

public enum ImageFitInterop {
    | Contain
    | Cover
    | Auto
    | Fill
    | ScaleDown
    | None
    | TOP_START
    | TOP
    | TOP_END
    | START
    | CENTER
    | END
    | BOTTOM_START
    | BOTTOM
    | BOTTOM_END

    func toJSValue(context: JSContext) {
        match (this) {
            case Fill => 0.toJSValue(context)
            case Contain => 1.toJSValue(context)
            case Cover => 2.toJSValue(context)
            case Auto => 3.toJSValue(context)
            case None => 5.toJSValue(context)
            case ScaleDown => 6.toJSValue(context)
            case TOP_START => 7.toJSValue(context)
            case TOP => 8.toJSValue(context)
            case TOP_END => 9.toJSValue(context)
            case START => 10.toJSValue(context)
            case CENTER => 11.toJSValue(context)
            case END => 12.toJSValue(context)
            case BOTTOM_START => 13.toJSValue(context)
            case BOTTOM => 14.toJSValue(context)
            case BOTTOM_END => 15.toJSValue(context)
            case _ => throw Exception("not support type")
        }
    }

    static func fromJSValue(context: JSContext, input: JSValue): ImageFitInterop {
        match (Int32.fromJSValue(context, input)) {
            case 0 => Fill
            case 1 => Contain
            case 2 => Cover
            case 3 => Auto
            case 5 => None
            case 6 => ScaleDown
            case 7 => TOP_START
            case 8 => TOP
            case 9 => TOP_END
            case 10 => START
            case 11 => CENTER
            case 12 => END
            case 13 => BOTTOM_START
            case 14 => BOTTOM
            case 15 => BOTTOM_END
            case _ => throw IllegalArgumentException("unknown value")
        }
    }
}