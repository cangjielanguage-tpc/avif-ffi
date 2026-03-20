package ohos_app_cangjie_avif4hybrid

/**
 * 定义一个全局的 Context 获取类，方便后续其他业务使用
 */
public class GlobalContext {
    static var _context: Option<StageContext> = None

    /**
     * 设置StageContext
     *
     * @param context StageContext
     */
    public static func setContext(context: StageContext): Unit {
        _context = context
    }

    /**
     * 获取StageContext
     *
     * @return Option<StageContext> StageContext
     */
    public static func getContext(): Option<StageContext> {
        return _context
    }
}



let EXPORT_MODULE = JSModule.registerModule {
    runtime, exports =>
    exports["setGlobalContext"] = runtime.function(setGlobalContext).toJSValue()
    exports["setMemoryLruCache"] = runtime.function(setMemoryLruCache).toJSValue()
    exports["setFileLruCache"] = runtime.function(setFileLruCache).toJSValue()

}
