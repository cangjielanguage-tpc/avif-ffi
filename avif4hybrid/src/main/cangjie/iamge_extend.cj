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

