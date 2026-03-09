package ohos_app_cangjie_avif4hybrid

func testCJ(runtime: JSContext, callInfo: JSCallInfo): JSValue {
    let result = "Hello ${callInfo[0].toString(runtime)}"
    runtime.string(result).toJSValue()
}

let EXPORT_MODULE = JSModule.registerModule {
    runtime, exports => exports["testCJ"] = runtime.function(testCJ).toJSValue()
    exports["getLoadCJPage"] = runtime.function(getLoadCJPage).toJSValue()
}
