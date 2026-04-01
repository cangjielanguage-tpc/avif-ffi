package ohos_app_cangjie_avif4hybrid



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





