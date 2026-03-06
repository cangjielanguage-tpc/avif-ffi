/**
 * Created on 2025/10/31
 */
package ohos_app_cangjie_avif4hybrid

public var context: ?JSContext = None

let _ = {
    => JSModule.registerModule(
        {
            ctx, exports =>
            context = ctx
            exports
        }
    )
}()

extend Image{
    func interopDraggable(isBool: Bool): Image{
            try {
                let global = context.getOrThrow().global
                let ctx = context.getOrThrow()
                let image = global["Image"].asObject(ctx)
                let draggable = image["draggable"].asFunction(ctx)
                let value:Bool = isBool
                draggable.call(value.toJSValue(ctx))
            } catch (e: Exception) {
            }
        return this
    }

    func interopObjectFit(imageFit: ImageFit): Image{
            try {
                let global = context.getOrThrow().global
                let ctx = context.getOrThrow()
                let image = global["Image"].asObject(ctx)
                let objectFit = image["objectFit"].asFunction(ctx)
                let value:Int64 = match (imageFit) {
                    case ImageFit.Fill => 0
                    case ImageFit.Contain => 1
                    case ImageFit.Cover => 2
                    case ImageFit.Auto => 3
                    case ImageFit.None => 5
                    case ImageFit.ScaleDown => 6
                    case ImageFit.TOP_START => 7
                    case ImageFit.TOP => 8
                    case ImageFit.TOP_END => 9
                    case ImageFit.START => 10
                    case ImageFit.CENTER => 11
                    case ImageFit.END => 12
                    case ImageFit.BOTTOM_START => 13
                    case ImageFit.BOTTOM => 14
                    case ImageFit.BOTTOM_END => 15
                    case _ => -1
                }
                objectFit.call(value.toJSValue(ctx))
            } catch (e: Exception) {
            }
        return this
    }
}