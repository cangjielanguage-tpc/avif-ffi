/**
 * Created on 2026/1/4
 */
package ohos_app_cangjie_avif4hybrid

import ohos.ark_interop_macro.Interop

/* ===== Emitted by MacroCall @Interop in cj_avifdecoder.cj:8:1 ===== */
/* 8.1 */public class CJAvifDecoder <: SharedObject & JSInteropType < CJAvifDecoder > {
/* 8.2 */
/* 8.3 */    static init() {
/* 8.4 */        JSModule.registerClass("CJAvifDecoder") { context =>
/* 8.5 */            let clazz = context.clazz(jsConstructor)
/* 8.6 */
/* 8.7 */
/* 8.8 */
/* 8.9 */            clazz.addMethod("create",
/* 8.10 */            context.function(create_ArkTS_Interop_Identifier))
/* 8.11 */
/* 8.12 */            clazz.addMethod("createWithThread",
/* 8.13 */            context.function(createWithThread_ArkTS_Interop_Identifier))
/* 8.14 */
/* 8.15 */            clazz.addMethod("getWidth",
/* 8.16 */            context.function(getWidth_ArkTS_Interop_Identifier))
/* 8.17 */
/* 8.18 */            clazz.addMethod("getHeight",
/* 8.19 */            context.function(getHeight_ArkTS_Interop_Identifier))
/* 8.20 */
/* 8.21 */            clazz.addMethod("getDepth",
/* 8.22 */            context.function(getDepth_ArkTS_Interop_Identifier))
/* 8.23 */
/* 8.24 */            clazz.addMethod("getAlphaPresent",
/* 8.25 */            context.function(getAlphaPresent_ArkTS_Interop_Identifier))
/* 8.26 */
/* 8.27 */            clazz.addMethod("getFrameCount",
/* 8.28 */            context.function(getFrameCount_ArkTS_Interop_Identifier))
/* 8.29 */
/* 8.30 */            clazz.addMethod("getRepetitionCount",
/* 8.31 */            context.function(getRepetitionCount_ArkTS_Interop_Identifier))
/* 8.32 */
/* 8.33 */            clazz.addMethod("getFrameDurations",
/* 8.34 */            context.function(getFrameDurations_ArkTS_Interop_Identifier))
/* 8.35 */
/* 8.36 */            clazz.addMethod("isAvifImageffi",
/* 8.37 */            context.function(isAvifImageffi_ArkTS_Interop_Identifier))
/* 8.38 */
/* 8.39 */            clazz.addMethod("nextFrameIndexffi",
/* 8.40 */            context.function(nextFrameIndexffi_ArkTS_Interop_Identifier))
/* 8.41 */
/* 8.42 */            clazz.addMethod("nextFrameffi",
/* 8.43 */            context.function(nextFrameffi_ArkTS_Interop_Identifier))
/* 8.44 */
/* 8.45 */            clazz.addMethod("nthFrameffi",
/* 8.46 */            context.function(nthFrameffi_ArkTS_Interop_Identifier))
/* 8.47 */
/* 8.48 */            clazz.addMethod("release",
/* 8.49 */            context.function(release_ArkTS_Interop_Identifier))
/* 8.50 */
/* 8.51 */            return clazz
/* 8.52 */        }
/* 8.53 */    }
/* 8.54 */
/* 8.55 */
/* 8.56 */    public init() {
/* 8.57 */    }
/* 8.58 */
/* 8.59 */    public static func jsConstructor(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.60 */
/* 8.61 */        JSCurrentJSContext.set(context)
/* 8.62 */        let clazz = CJAvifDecoder()
/* 8.63 */        JSCurrentJSContext.unset()
/* 8.64 */        let thisArg = callInfo.thisArg
/* 8.65 */        let thisObject = thisArg.asObject(context)
/* 8.66 */        let jsExternal = context.external(clazz)
/* 8.67 */        thisObject.attachCJObject(jsExternal)
/* 8.68 */        return thisObject.toJSValue()
/* 8.69 */    }
/* 8.70 */
/* 8.71 */
/* 8.72 */
/* 8.73 */
/* 8.74 */
/* 8.75 */
/* 8.76 */
/* 8.77 */    public func create(uri: String): Option < CJAvifDecoder > {
/* 8.78 */        return createWithThread(uri, 1)
/* 8.79 */    }
/* 8.80 */
/* 8.81 */    public func createWithThread(uri: String, threads: Int32): Option < CJAvifDecoder > {
/* 8.82 */        this.mUri = uri
/* 8.83 */        if(uri.startsWith("http")) {
/* 8.84 */            let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
/* 8.85 */            if(fileExist) {
/* 8.86 */                let source:?Array < UInt8 >= fileLruCache.get(mDiskKey)
/* 8.87 */                if(let Some(i) <- source) {
/* 8.88 */                    return createLoginc(i, threads)
/* 8.89 */                }
/* 8.90 */            }
/* 8.91 */            let imageBuffer = getImageFromNet(uri)
/* 8.92 */            if(let Some(i) <- imageBuffer) {
/* 8.93 */                return createLoginc(i, threads)
/* 8.94 */            }
/* 8.95 */            else {
/* 8.96 */                Hilog.error(0, "getImageFromNet", "获取网络文件内容失败")
/* 8.97 */                return Option < CJAvifDecoder >.None
/* 8.98 */            }
/* 8.99 */        }
/* 8.100 */        else if(uri.startsWith("rawfile://")) {
/* 8.101 */            let fileName = uri.removePrefix("rawfile://")
/* 8.102 */            let imageBuffer = getImageFromRawFile(fileName)
/* 8.103 */            if(let Some(i) <- imageBuffer) {
/* 8.104 */                return createLoginc(i, threads)
/* 8.105 */            }
/* 8.106 */            else {
/* 8.107 */                Hilog.error(0, "getImageFromRawFile", "获取raw文件内容失败")
/* 8.108 */                return Option < CJAvifDecoder >.None
/* 8.109 */            }
/* 8.110 */        }
/* 8.111 */        else if(uri.startsWith("media://")) {
/* 8.112 */            let mediaName = uri.removePrefix("media://")
/* 8.113 */            let imageBuffer = getImageFromMedia(mediaName)
/* 8.114 */            if(let Some(i) <- imageBuffer) {
/* 8.115 */                return createLoginc(i, threads)
/* 8.116 */            }
/* 8.117 */            else {
/* 8.118 */                Hilog.error(0, "getImageFromMedia", "获取media文件内容失败")
/* 8.119 */                return Option < CJAvifDecoder >.None
/* 8.120 */            }
/* 8.121 */        }
/* 8.122 */        else if(uri.startsWith("file://")) {
/* 8.123 */            let localFilePath = uri.removePrefix("file://")
/* 8.124 */            let imageBuffer:?Array < UInt8 >= FileUtils.getInstance().readFileSync(localFilePath)
/* 8.125 */            if(let Some(i) <- imageBuffer) {
/* 8.126 */                return createLoginc(i, threads)
/* 8.127 */            }
/* 8.128 */            else {
/* 8.129 */                Hilog.error(0, "readFileSync", "读取本地文件失败")
/* 8.130 */                return Option < CJAvifDecoder >.None
/* 8.131 */            }
/* 8.132 */        }
/* 8.133 */        else {
/* 8.134 */            let localFilePath = uri
/* 8.135 */            let imageBuffer:?Array < UInt8 >= FileUtils.getInstance().readFileSync(localFilePath)
/* 8.136 */            if(let Some(i) <- imageBuffer) {
/* 8.137 */                return createLoginc(i, threads)
/* 8.138 */            }
/* 8.139 */            else {
/* 8.140 */                Hilog.error(0, "readFileSync", "读取内容失败")
/* 8.141 */                return Option < CJAvifDecoder >.None
/* 8.142 */            }
/* 8.143 */        }
/* 8.144 */    }
/* 8.145 */
/* 8.146 */    public func getWidth(): Int64 {
/* 8.147 */        if(let Some(i) <- decoder) {
/* 8.148 */            return i.getWidth()
/* 8.149 */        }
/* 8.150 */        return 0
/* 8.151 */    }
/* 8.152 */
/* 8.153 */    public func getHeight(): Int64 {
/* 8.154 */        if(let Some(i) <- decoder) {
/* 8.155 */            return i.getHeight()
/* 8.156 */        }
/* 8.157 */        return 0
/* 8.158 */    }
/* 8.159 */
/* 8.160 */    public func getDepth(): Int64 {
/* 8.161 */        if(let Some(i) <- decoder) {
/* 8.162 */            return i.getDepth()
/* 8.163 */        }
/* 8.164 */        return 0
/* 8.165 */    }
/* 8.166 */
/* 8.167 */    public func getAlphaPresent(): Bool {
/* 8.168 */        if(let Some(i) <- decoder) {
/* 8.169 */            return i.getAlphaPresent()
/* 8.170 */        }
/* 8.171 */        return false
/* 8.172 */    }
/* 8.173 */
/* 8.174 */    public func getFrameCount(): Int64 {
/* 8.175 */        if(let Some(i) <- decoder) {
/* 8.176 */            return i.getFrameCount()
/* 8.177 */        }
/* 8.178 */        return 0
/* 8.179 */    }
/* 8.180 */
/* 8.181 */    public func getRepetitionCount(): Int64 {
/* 8.182 */        if(let Some(i) <- decoder) {
/* 8.183 */            return i.getRepetitionCount()
/* 8.184 */        }
/* 8.185 */        return 0
/* 8.186 */    }
/* 8.187 */
/* 8.188 */    public func getFrameDurations(): Option < JSArrayEx < Float64 >> {
/* 8.189 */        if(let Some(i) <- decoder) {
/* 8.190 */            if(let Some(j) <- i.getFrameDurations()) {
/* 8.191 */                return JSArrayEx(j)
/* 8.192 */            }
/* 8.193 */            else {
/* 8.194 */                return None
/* 8.195 */            }
/* 8.196 */        }
/* 8.197 */        return None
/* 8.198 */    }
/* 8.199 */
/* 8.200 */    public func isAvifImageffi(): Int32 {
/* 8.201 */        if(let Some(i) <- decoder) {
/* 8.202 */            if(let Some(j) <- encoded) {
/* 8.203 */                return i.isAvifImageffi(j)
/* 8.204 */            }
/* 8.205 */        }
/* 8.206 */        return 0
/* 8.207 */    }
/* 8.208 */
/* 8.209 */    public func nextFrameIndexffi(): Int32 {
/* 8.210 */        if(let Some(i) <- decoder) {
/* 8.211 */            return i.nextFrameIndexffi()
/* 8.212 */        }
/* 8.213 */        return 0
/* 8.214 */    }
/* 8.215 */
/* 8.216 */    public func nextFrameffi(imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 8.217 */        let value: CJReturnValue = CJReturnValue()
/* 8.218 */        if(imageWidth < 0 || imageHeight < 0) {
/* 8.219 */            value.issuccess = false
/* 8.220 */            return value
/* 8.221 */        }
/* 8.222 */        let count: Int64 = getFrameCount()
/* 8.223 */        if(count <= 0) {
/* 8.224 */            value.issuccess = false
/* 8.225 */            return value
/* 8.226 */        }
/* 8.227 */        if(count == 1) {
/* 8.228 */            mDiskKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
/* 8.229 */            mMemoryKey = mDiskKey + "notcomponent"
/* 8.230 */        }
/* 8.231 */        else {
/* 8.232 */            let index: Int32 = nextFrameIndexffi()
/* 8.233 */            mMemoryKey = getmd5keyWithIndex(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight), index) + "notcomponent"
/* 8.234 */            mDiskKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
/* 8.235 */        }
/* 8.236 */        var realPicWidth = imageWidth
/* 8.237 */        var realPicHeight = imageHeight
/* 8.238 */        if(imageWidth == 0) {
/* 8.239 */            realPicWidth = Int32(getWidth())
/* 8.240 */        }
/* 8.241 */        if(imageHeight == 0) {
/* 8.242 */            realPicHeight = Int32(getHeight())
/* 8.243 */        }
/* 8.244 */        let memPixelMap:?CacheBean = memoryLruCache.get(mMemoryKey)
/* 8.245 */        if(let Some(cache) <- memPixelMap) {
/* 8.246 */            let arrData = cache.getPicData()
/* 8.247 */            if(let Some(i) <- arrData) {
/* 8.248 */                value.color = i
/* 8.249 */                value.issuccess = true
/* 8.250 */                return value
/* 8.251 */            }
/* 8.252 */        }
/* 8.253 */        let color: Array < Byte >= Array < Byte >(Int64(realPicWidth * realPicHeight * 4), repeat: 0)
/* 8.254 */        if(let Some(i) <- decoder) {
/* 8.255 */            value.code = i.nextFrameffi(color, realPicWidth, realPicHeight)
/* 8.256 */            if(value.code == 0) {
/* 8.257 */                spawn { let cacheBean: CacheBean = CacheBean(Option < MultiPixelMap >.None, Option < PixelMap >.None, color)
/* 8.258 */
/* 8.259 */                    memoryLruCache.put(mMemoryKey, cacheBean)
/* 8.260 */                    if(let Some(j) <- encoded) {
/* 8.261 */                        let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
/* 8.262 */                        if(! fileExist && mUri.startsWith("http")) {
/* 8.263 */                            fileLruCache.put(mDiskKey, j.size, j)
/* 8.264 */                        }
/* 8.265 */                    }
/* 8.266 */                }
/* 8.267 */                value.issuccess = true
/* 8.268 */                value.color = color
/* 8.269 */            }
/* 8.270 */            else {
/* 8.271 */                value.issuccess = false
/* 8.272 */            }
/* 8.273 */            return value
/* 8.274 */        }
/* 8.275 */        else {
/* 8.276 */            value.issuccess = false
/* 8.277 */            return value
/* 8.278 */        }
/* 8.279 */    }
/* 8.280 */
/* 8.281 */    public func nthFrameffi(index: Int32, imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 8.282 */        let value: CJReturnValue = CJReturnValue()
/* 8.283 */        if(imageWidth < 0 || imageHeight < 0) {
/* 8.284 */            value.issuccess = false
/* 8.285 */            return value
/* 8.286 */        }
/* 8.287 */        let count: Int64 = getFrameCount()
/* 8.288 */        if(count <= 0) {
/* 8.289 */            value.issuccess = false
/* 8.290 */            return value
/* 8.291 */        }
/* 8.292 */        if(count == 1) {
/* 8.293 */            mDiskKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
/* 8.294 */            mMemoryKey = mDiskKey + "notcomponent"
/* 8.295 */        }
/* 8.296 */        else {
/* 8.297 */            mMemoryKey = getmd5keyWithIndex(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight), index) + "notcomponent"
/* 8.298 */            mDiskKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
/* 8.299 */        }
/* 8.300 */        let memPixelMap:?CacheBean = memoryLruCache.get(mMemoryKey)
/* 8.301 */        if(let Some(cache) <- memPixelMap) {
/* 8.302 */            let arrData = cache.getPicData()
/* 8.303 */            if(let Some(i) <- arrData) {
/* 8.304 */                value.color = i
/* 8.305 */                value.issuccess = true
/* 8.306 */                return value
/* 8.307 */            }
/* 8.308 */        }
/* 8.309 */        var realPicWidth = imageWidth
/* 8.310 */        var realPicHeight = imageHeight
/* 8.311 */        if(imageWidth == 0) {
/* 8.312 */            realPicWidth = Int32(getWidth())
/* 8.313 */        }
/* 8.314 */        if(imageHeight == 0) {
/* 8.315 */            realPicHeight = Int32(getHeight())
/* 8.316 */        }
/* 8.317 */        let color: Array < Byte >= Array < Byte >(Int64(realPicWidth * realPicHeight * 4), repeat: 0)
/* 8.318 */        if(let Some(i) <- decoder) {
/* 8.319 */            if(count == 1) {
/* 8.320 */                value.code = i.nthFrameffi(0, color, realPicWidth, realPicHeight)
/* 8.321 */            }
/* 8.322 */            else {
/* 8.323 */                value.code = i.nthFrameffi(index, color, realPicWidth, realPicHeight)
/* 8.324 */            }
/* 8.325 */            if(value.code == 0) {
/* 8.326 */                spawn { let cacheBean: CacheBean = CacheBean(Option < MultiPixelMap >.None, Option < PixelMap >.None, color)
/* 8.327 */
/* 8.328 */                    memoryLruCache.put(mMemoryKey, cacheBean)
/* 8.329 */                    if(let Some(j) <- encoded) {
/* 8.330 */                        let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
/* 8.331 */                        if(! fileExist && mUri.startsWith("http")) {
/* 8.332 */                            fileLruCache.put(mDiskKey, j.size, j)
/* 8.333 */                        }
/* 8.334 */                    }
/* 8.335 */                }
/* 8.336 */                value.issuccess = true
/* 8.337 */                value.color = color
/* 8.338 */            }
/* 8.339 */            else {
/* 8.340 */                value.issuccess = false
/* 8.341 */            }
/* 8.342 */            return value
/* 8.343 */        }
/* 8.344 */        else {
/* 8.345 */            value.issuccess = false
/* 8.346 */            return value
/* 8.347 */        }
/* 8.348 */    }
/* 8.349 */
/* 8.350 */    public func release(): Unit {
/* 8.351 */        if(let Some(i) <- decoder) {
/* 8.352 */            return i.release()
/* 8.353 */        }
/* 8.354 */    }
/* 8.355 */
/* 8.356 */
/* 8.357 */
/* 8.358 */    public static func create_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.359 */
/* 8.360 */        let thisArg = callInfo.thisArg
/* 8.361 */        let thisObject = thisArg.asObject(context)
/* 8.362 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.363 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.364 */
/* 8.365 */        let arg1773297205550861300 = String.fromJSValue(context, callInfo[0])
/* 8.366 */
/* 8.367 */        JSCurrentJSContext.set(context)
/* 8.368 */        let RET = clazz.create(arg1773297205550861300)
/* 8.369 */        JSCurrentJSContext.unset()
/* 8.370 */        RET.toJSValue(context)
/* 8.371 */    }
/* 8.372 */
/* 8.373 */    public static func createWithThread_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.374 */
/* 8.375 */        let thisArg = callInfo.thisArg
/* 8.376 */        let thisObject = thisArg.asObject(context)
/* 8.377 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.378 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.379 */
/* 8.380 */        let arg1773297205551329600 = String.fromJSValue(context, callInfo[0])
/* 8.381 */        let arg1773297205551349500 = Int32.fromJSValue(context, callInfo[1])
/* 8.382 */
/* 8.383 */        JSCurrentJSContext.set(context)
/* 8.384 */        let RET = clazz.createWithThread(arg1773297205551329600, arg1773297205551349500)
/* 8.385 */        JSCurrentJSContext.unset()
/* 8.386 */        RET.toJSValue(context)
/* 8.387 */    }
/* 8.388 */
/* 8.389 */    public static func getWidth_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.390 */
/* 8.391 */        let thisArg = callInfo.thisArg
/* 8.392 */        let thisObject = thisArg.asObject(context)
/* 8.393 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.394 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.395 */
/* 8.396 */
/* 8.397 */        JSCurrentJSContext.set(context)
/* 8.398 */        let RET = clazz.getWidth()
/* 8.399 */        JSCurrentJSContext.unset()
/* 8.400 */        RET.toJSValue(context)
/* 8.401 */    }
/* 8.402 */
/* 8.403 */    public static func getHeight_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.404 */
/* 8.405 */        let thisArg = callInfo.thisArg
/* 8.406 */        let thisObject = thisArg.asObject(context)
/* 8.407 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.408 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.409 */
/* 8.410 */
/* 8.411 */        JSCurrentJSContext.set(context)
/* 8.412 */        let RET = clazz.getHeight()
/* 8.413 */        JSCurrentJSContext.unset()
/* 8.414 */        RET.toJSValue(context)
/* 8.415 */    }
/* 8.416 */
/* 8.417 */    public static func getDepth_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.418 */
/* 8.419 */        let thisArg = callInfo.thisArg
/* 8.420 */        let thisObject = thisArg.asObject(context)
/* 8.421 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.422 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.423 */
/* 8.424 */
/* 8.425 */        JSCurrentJSContext.set(context)
/* 8.426 */        let RET = clazz.getDepth()
/* 8.427 */        JSCurrentJSContext.unset()
/* 8.428 */        RET.toJSValue(context)
/* 8.429 */    }
/* 8.430 */
/* 8.431 */    public static func getAlphaPresent_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.432 */
/* 8.433 */        let thisArg = callInfo.thisArg
/* 8.434 */        let thisObject = thisArg.asObject(context)
/* 8.435 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.436 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.437 */
/* 8.438 */
/* 8.439 */        JSCurrentJSContext.set(context)
/* 8.440 */        let RET = clazz.getAlphaPresent()
/* 8.441 */        JSCurrentJSContext.unset()
/* 8.442 */        RET.toJSValue(context)
/* 8.443 */    }
/* 8.444 */
/* 8.445 */    public static func getFrameCount_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.446 */
/* 8.447 */        let thisArg = callInfo.thisArg
/* 8.448 */        let thisObject = thisArg.asObject(context)
/* 8.449 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.450 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.451 */
/* 8.452 */
/* 8.453 */        JSCurrentJSContext.set(context)
/* 8.454 */        let RET = clazz.getFrameCount()
/* 8.455 */        JSCurrentJSContext.unset()
/* 8.456 */        RET.toJSValue(context)
/* 8.457 */    }
/* 8.458 */
/* 8.459 */    public static func getRepetitionCount_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.460 */
/* 8.461 */        let thisArg = callInfo.thisArg
/* 8.462 */        let thisObject = thisArg.asObject(context)
/* 8.463 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.464 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.465 */
/* 8.466 */
/* 8.467 */        JSCurrentJSContext.set(context)
/* 8.468 */        let RET = clazz.getRepetitionCount()
/* 8.469 */        JSCurrentJSContext.unset()
/* 8.470 */        RET.toJSValue(context)
/* 8.471 */    }
/* 8.472 */
/* 8.473 */    public static func getFrameDurations_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.474 */
/* 8.475 */        let thisArg = callInfo.thisArg
/* 8.476 */        let thisObject = thisArg.asObject(context)
/* 8.477 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.478 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.479 */
/* 8.480 */
/* 8.481 */        JSCurrentJSContext.set(context)
/* 8.482 */        let RET = clazz.getFrameDurations()
/* 8.483 */        JSCurrentJSContext.unset()
/* 8.484 */        RET.toJSValue(context)
/* 8.485 */    }
/* 8.486 */
/* 8.487 */    public static func isAvifImageffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.488 */
/* 8.489 */        let thisArg = callInfo.thisArg
/* 8.490 */        let thisObject = thisArg.asObject(context)
/* 8.491 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.492 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.493 */
/* 8.494 */
/* 8.495 */        JSCurrentJSContext.set(context)
/* 8.496 */        let RET = clazz.isAvifImageffi()
/* 8.497 */        JSCurrentJSContext.unset()
/* 8.498 */        RET.toJSValue(context)
/* 8.499 */    }
/* 8.500 */
/* 8.501 */    public static func nextFrameIndexffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.502 */
/* 8.503 */        let thisArg = callInfo.thisArg
/* 8.504 */        let thisObject = thisArg.asObject(context)
/* 8.505 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.506 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.507 */
/* 8.508 */
/* 8.509 */        JSCurrentJSContext.set(context)
/* 8.510 */        let RET = clazz.nextFrameIndexffi()
/* 8.511 */        JSCurrentJSContext.unset()
/* 8.512 */        RET.toJSValue(context)
/* 8.513 */    }
/* 8.514 */
/* 8.515 */    public static func nextFrameffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.516 */
/* 8.517 */        let thisArg = callInfo.thisArg
/* 8.518 */        let thisObject = thisArg.asObject(context)
/* 8.519 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.520 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.521 */
/* 8.522 */        let arg1773297205553325500 = Int32.fromJSValue(context, callInfo[0])
/* 8.523 */        let arg1773297205553347000 = Int32.fromJSValue(context, callInfo[1])
/* 8.524 */
/* 8.525 */        JSCurrentJSContext.set(context)
/* 8.526 */        let RET = clazz.nextFrameffi(arg1773297205553325500, arg1773297205553347000)
/* 8.527 */        JSCurrentJSContext.unset()
/* 8.528 */        RET.toJSValue(context)
/* 8.529 */    }
/* 8.530 */
/* 8.531 */    public static func nthFrameffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.532 */
/* 8.533 */        let thisArg = callInfo.thisArg
/* 8.534 */        let thisObject = thisArg.asObject(context)
/* 8.535 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.536 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.537 */
/* 8.538 */        let arg1773297205553967000 = Int32.fromJSValue(context, callInfo[0])
/* 8.539 */        let arg1773297205553989800 = Int32.fromJSValue(context, callInfo[1])
/* 8.540 */        let arg1773297205554008000 = Int32.fromJSValue(context, callInfo[2])
/* 8.541 */
/* 8.542 */        JSCurrentJSContext.set(context)
/* 8.543 */        let RET = clazz.nthFrameffi(arg1773297205553967000, arg1773297205553989800, arg1773297205554008000)
/* 8.544 */        JSCurrentJSContext.unset()
/* 8.545 */        RET.toJSValue(context)
/* 8.546 */    }
/* 8.547 */
/* 8.548 */    public static func release_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.549 */
/* 8.550 */        let thisArg = callInfo.thisArg
/* 8.551 */        let thisObject = thisArg.asObject(context)
/* 8.552 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.553 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.554 */
/* 8.555 */
/* 8.556 */        JSCurrentJSContext.set(context)
/* 8.557 */        let RET = clazz.release()
/* 8.558 */        JSCurrentJSContext.unset()
/* 8.559 */        RET.toJSValue(context)
/* 8.560 */    }
/* 8.561 */
/* 8.562 */
/* 8.563 */
/* 8.564 */
/* 8.565 */
/* 8.566 */
/* 8.567 */
/* 8.568 */
/* 8.569 */    public func toJSValue(context: JSContext): JSValue {
/* 8.570 */        let ext = context.external(this)
/* 8.571 */        let obj = context.object()
/* 8.572 */
/* 8.573 */
/* 8.574 */
/* 8.575 */        obj["create"] =
/* 8.576 */        context.function(create_ArkTS_Interop_Identifier).toJSValue()
/* 8.577 */
/* 8.578 */        obj["createWithThread"] =
/* 8.579 */        context.function(createWithThread_ArkTS_Interop_Identifier).toJSValue()
/* 8.580 */
/* 8.581 */        obj["getWidth"] =
/* 8.582 */        context.function(getWidth_ArkTS_Interop_Identifier).toJSValue()
/* 8.583 */
/* 8.584 */        obj["getHeight"] =
/* 8.585 */        context.function(getHeight_ArkTS_Interop_Identifier).toJSValue()
/* 8.586 */
/* 8.587 */        obj["getDepth"] =
/* 8.588 */        context.function(getDepth_ArkTS_Interop_Identifier).toJSValue()
/* 8.589 */
/* 8.590 */        obj["getAlphaPresent"] =
/* 8.591 */        context.function(getAlphaPresent_ArkTS_Interop_Identifier).toJSValue()
/* 8.592 */
/* 8.593 */        obj["getFrameCount"] =
/* 8.594 */        context.function(getFrameCount_ArkTS_Interop_Identifier).toJSValue()
/* 8.595 */
/* 8.596 */        obj["getRepetitionCount"] =
/* 8.597 */        context.function(getRepetitionCount_ArkTS_Interop_Identifier).toJSValue()
/* 8.598 */
/* 8.599 */        obj["getFrameDurations"] =
/* 8.600 */        context.function(getFrameDurations_ArkTS_Interop_Identifier).toJSValue()
/* 8.601 */
/* 8.602 */        obj["isAvifImageffi"] =
/* 8.603 */        context.function(isAvifImageffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.604 */
/* 8.605 */        obj["nextFrameIndexffi"] =
/* 8.606 */        context.function(nextFrameIndexffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.607 */
/* 8.608 */        obj["nextFrameffi"] =
/* 8.609 */        context.function(nextFrameffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.610 */
/* 8.611 */        obj["nthFrameffi"] =
/* 8.612 */        context.function(nthFrameffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.613 */
/* 8.614 */        obj["release"] =
/* 8.615 */        context.function(release_ArkTS_Interop_Identifier).toJSValue()
/* 8.616 */
/* 8.617 */        obj.attachCJObject(ext)
/* 8.618 */        obj.toJSValue()
/* 8.619 */    }
/* 8.620 */
/* 8.621 */
/* 8.622 */    public static func fromJSValue(context: JSContext, input: JSValue) {
/* 8.623 */        let jsObj = input.asObject(context)
/* 8.624 */        let jsExt = jsObj.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.625 */        let obj = jsExt.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.626 */        return obj
/* 8.627 */    }
/* 8.628 */    public static func toArkTsType(): String {
/* 8.629 */        "class"
/* 8.630 */    }
/* 8.631 */
/* 8.632 */    private var decoder: Option < AvifDecoder >= None
/* 8.633 */    var mMemoryKey = ""
/* 8.634 */    var mDiskKey = ""
/* 8.635 */    var mUri = ""
/* 8.636 */    var encoded:?Array < Byte >= None
/* 8.637 */    private func createLoginc(buffer: Array < UInt8 >, threads: Int32): Option < CJAvifDecoder > {
/* 8.638 */        encoded = buffer
/* 8.639 */        decoder = AvifDecoder(buffer, threads)
/* 8.640 */        if(let Some(k) <- decoder) {
/* 8.641 */            if(k.decoder == 0) {
/* 8.642 */                return Option < CJAvifDecoder >.None
/* 8.643 */            }
/* 8.644 */            return this
/* 8.645 */        }
/* 8.646 */        else {
/* 8.647 */            return Option < CJAvifDecoder >.None
/* 8.648 */        }
/* 8.649 */    }
/* 8.650 */
/* 8.651 */}
/* 8.652 */
/* ===== End of the Emit ===== */