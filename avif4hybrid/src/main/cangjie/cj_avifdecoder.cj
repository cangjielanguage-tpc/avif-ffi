package ohos_app_cangjie_avif4hybrid

import ohos.ark_interop_macro.Interop


 /* ===== Emitted by MacroCall @Interop in cj_avifdecoder.cj:6:2 ===== */
/* 6.1 */public class CJAvifDecoder <: SharedObject & JSInteropType < CJAvifDecoder > {
/* 6.2 */
/* 6.3 */    static init() {
/* 6.4 */        JSModule.registerClass("CJAvifDecoder") { context =>
/* 6.5 */            let clazz = context.clazz(jsConstructor)
/* 6.6 */
/* 6.7 */
/* 6.8 */
/* 6.9 */            clazz.addMethod("create",
/* 6.10 */            context.function(create_ArkTS_Interop_Identifier))
/* 6.11 */
/* 6.12 */            clazz.addMethod("createAsync",
/* 6.13 */            context.function(createAsync_ArkTS_Interop_Identifier))
/* 6.14 */
/* 6.15 */            clazz.addMethod("createWithThread",
/* 6.16 */            context.function(createWithThread_ArkTS_Interop_Identifier))
/* 6.17 */
/* 6.18 */            clazz.addMethod("createWithThreadAsync",
/* 6.19 */            context.function(createWithThreadAsync_ArkTS_Interop_Identifier))
/* 6.20 */
/* 6.21 */            clazz.addMethod("getWidth",
/* 6.22 */            context.function(getWidth_ArkTS_Interop_Identifier))
/* 6.23 */
/* 6.24 */            clazz.addMethod("getHeight",
/* 6.25 */            context.function(getHeight_ArkTS_Interop_Identifier))
/* 6.26 */
/* 6.27 */            clazz.addMethod("getDepth",
/* 6.28 */            context.function(getDepth_ArkTS_Interop_Identifier))
/* 6.29 */
/* 6.30 */            clazz.addMethod("getAlphaPresent",
/* 6.31 */            context.function(getAlphaPresent_ArkTS_Interop_Identifier))
/* 6.32 */
/* 6.33 */            clazz.addMethod("getFrameCount",
/* 6.34 */            context.function(getFrameCount_ArkTS_Interop_Identifier))
/* 6.35 */
/* 6.36 */            clazz.addMethod("getRepetitionCount",
/* 6.37 */            context.function(getRepetitionCount_ArkTS_Interop_Identifier))
/* 6.38 */
/* 6.39 */            clazz.addMethod("getFrameDurations",
/* 6.40 */            context.function(getFrameDurations_ArkTS_Interop_Identifier))
/* 6.41 */
/* 6.42 */            clazz.addMethod("isAvifImageffi",
/* 6.43 */            context.function(isAvifImageffi_ArkTS_Interop_Identifier))
/* 6.44 */
/* 6.45 */            clazz.addMethod("nextFrameIndexffi",
/* 6.46 */            context.function(nextFrameIndexffi_ArkTS_Interop_Identifier))
/* 6.47 */
/* 6.48 */            clazz.addMethod("nextFrameffi",
/* 6.49 */            context.function(nextFrameffi_ArkTS_Interop_Identifier))
/* 6.50 */
/* 6.51 */            clazz.addMethod("nextFrameffiAsync",
/* 6.52 */            context.function(nextFrameffiAsync_ArkTS_Interop_Identifier))
/* 6.53 */
/* 6.54 */            clazz.addMethod("nthFrameffi",
/* 6.55 */            context.function(nthFrameffi_ArkTS_Interop_Identifier))
/* 6.56 */
/* 6.57 */            clazz.addMethod("nthFrameffiAsync",
/* 6.58 */            context.function(nthFrameffiAsync_ArkTS_Interop_Identifier))
/* 6.59 */
/* 6.60 */            clazz.addMethod("release",
/* 6.61 */            context.function(release_ArkTS_Interop_Identifier))
/* 6.62 */
/* 6.63 */            return clazz
/* 6.64 */        }
/* 6.65 */    }
/* 6.66 */
/* 6.67 */
/* 6.68 */    public init() {
/* 6.69 */    }
/* 6.70 */
/* 6.71 */    public static func jsConstructor(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.72 */
/* 6.73 */        JSCurrentJSContext.set(context)
/* 6.74 */        let clazz = CJAvifDecoder()
/* 6.75 */        JSCurrentJSContext.unset()
/* 6.76 */        let thisArg = callInfo.thisArg
/* 6.77 */        let thisObject = thisArg.asObject(context)
/* 6.78 */        let jsExternal = context.external(clazz)
/* 6.79 */        thisObject.attachCJObject(jsExternal)
/* 6.80 */        return thisObject.toJSValue()
/* 6.81 */    }
/* 6.82 */
/* 6.83 */
/* 6.84 */
/* 6.85 */
/* 6.86 */
/* 6.87 */
/* 6.88 */
/* 6.89 */    public func create(uri: String): Option < CJAvifDecoder > {
/* 6.90 */        return createWithThread(uri, 1)
/* 6.91 */    }
/* 6.92 */
/* 6.93 */    public func createAsync(uri: String): Option < CJAvifDecoder > {
/* 6.94 */        return createWithThreadAsync(uri, 1)
/* 6.95 */    }
/* 6.96 */
/* 6.97 */    public func createWithThread(uri: String, threads: Int32): Option < CJAvifDecoder > {
/* 6.98 */        this.mUri = uri
/* 6.99 */        if(uri.startsWith("http")) {
/* 6.100 */            let mDiskKey: String = getmd5key(this.mUri.toArray())
/* 6.101 */            let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
/* 6.102 */            if(fileExist) {
/* 6.103 */                let source:?Array < UInt8 >= fileLruCache.get(mDiskKey)
/* 6.104 */                if(let Some(i) <- source) {
/* 6.105 */                    return createLoginc(i, threads)
/* 6.106 */                }
/* 6.107 */                else {
/* 6.108 */                    return Option < CJAvifDecoder >.None
/* 6.109 */                }
/* 6.110 */            }
/* 6.111 */            let imageBuffer = getImageFromNet(uri)
/* 6.112 */            if(let Some(i) <- imageBuffer) {
/* 6.113 */                return createLoginc(i, threads)
/* 6.114 */            }
/* 6.115 */            else {
/* 6.116 */                Hilog.error(0, "getImageFromNet", "获取网络文件内容失败")
/* 6.117 */                return Option < CJAvifDecoder >.None
/* 6.118 */            }
/* 6.119 */        }
/* 6.120 */        else if(uri.startsWith("rawfile://")) {
/* 6.121 */            let fileName = uri.removePrefix("rawfile://")
/* 6.122 */            let imageBuffer = getImageFromRawFile(fileName)
/* 6.123 */            if(let Some(i) <- imageBuffer) {
/* 6.124 */                return createLoginc(i, threads)
/* 6.125 */            }
/* 6.126 */            else {
/* 6.127 */                Hilog.error(0, "getImageFromRawFile", "获取raw文件内容失败")
/* 6.128 */                return Option < CJAvifDecoder >.None
/* 6.129 */            }
/* 6.130 */        }
/* 6.131 */        else if(uri.startsWith("media://")) {
/* 6.132 */            let mediaName = uri.removePrefix("media://")
/* 6.133 */            let imageBuffer = getImageFromMedia(mediaName)
/* 6.134 */            if(let Some(i) <- imageBuffer) {
/* 6.135 */                return createLoginc(i, threads)
/* 6.136 */            }
/* 6.137 */            else {
/* 6.138 */                Hilog.error(0, "getImageFromMedia", "获取media文件内容失败")
/* 6.139 */                return Option < CJAvifDecoder >.None
/* 6.140 */            }
/* 6.141 */        }
/* 6.142 */        else if(uri.startsWith("file://")) {
/* 6.143 */            let localFilePath = uri.removePrefix("file://")
/* 6.144 */            let imageBuffer:?Array < UInt8 >= FileUtils.getInstance().readFileSync(localFilePath)
/* 6.145 */            if(let Some(i) <- imageBuffer) {
/* 6.146 */                return createLoginc(i, threads)
/* 6.147 */            }
/* 6.148 */            else {
/* 6.149 */                Hilog.error(0, "readFileSync", "读取本地文件失败")
/* 6.150 */                return Option < CJAvifDecoder >.None
/* 6.151 */            }
/* 6.152 */        }
/* 6.153 */        else {
/* 6.154 */            let localFilePath = uri
/* 6.155 */            let imageBuffer:?Array < UInt8 >= FileUtils.getInstance().readFileSync(localFilePath)
/* 6.156 */            if(let Some(i) <- imageBuffer) {
/* 6.157 */                return createLoginc(i, threads)
/* 6.158 */            }
/* 6.159 */            else {
/* 6.160 */                Hilog.error(0, "readFileSync", "读取内容失败")
/* 6.161 */                return Option < CJAvifDecoder >.None
/* 6.162 */            }
/* 6.163 */        }
/* 6.164 */    }
/* 6.165 */
/* 6.166 */    public func createWithThreadAsync(uri: String, threads: Int32): Option < CJAvifDecoder > {
/* 6.167 */        this.mUri = uri
/* 6.168 */        if(uri.startsWith("http")) {
/* 6.169 */            let mDiskKey: String = getmd5key(this.mUri.toArray())
/* 6.170 */            let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
/* 6.171 */            if(fileExist) {
/* 6.172 */                let source:?Array < UInt8 >= fileLruCache.get(mDiskKey)
/* 6.173 */                if(let Some(i) <- source) {
/* 6.174 */                    return createLoginc(i, threads)
/* 6.175 */                }
/* 6.176 */                else {
/* 6.177 */                    return Option < CJAvifDecoder >.None
/* 6.178 */                }
/* 6.179 */            }
/* 6.180 */            let imageBuffer = getImageFromNet(uri)
/* 6.181 */            if(let Some(i) <- imageBuffer) {
/* 6.182 */                return createLoginc(i, threads)
/* 6.183 */            }
/* 6.184 */            else {
/* 6.185 */                Hilog.error(0, "getImageFromNet", "获取网络文件内容失败")
/* 6.186 */                return Option < CJAvifDecoder >.None
/* 6.187 */            }
/* 6.188 */        }
/* 6.189 */        else if(uri.startsWith("rawfile://")) {
/* 6.190 */            let fileName = uri.removePrefix("rawfile://")
/* 6.191 */            let imageBuffer = getImageFromRawFile(fileName)
/* 6.192 */            if(let Some(i) <- imageBuffer) {
/* 6.193 */                return createLoginc(i, threads)
/* 6.194 */            }
/* 6.195 */            else {
/* 6.196 */                Hilog.error(0, "getImageFromRawFile", "获取raw文件内容失败")
/* 6.197 */                return Option < CJAvifDecoder >.None
/* 6.198 */            }
/* 6.199 */        }
/* 6.200 */        else if(uri.startsWith("media://")) {
/* 6.201 */            let mediaName = uri.removePrefix("media://")
/* 6.202 */            let imageBuffer = getImageFromMedia(mediaName)
/* 6.203 */            if(let Some(i) <- imageBuffer) {
/* 6.204 */                return createLoginc(i, threads)
/* 6.205 */            }
/* 6.206 */            else {
/* 6.207 */                Hilog.error(0, "getImageFromMedia", "获取media文件内容失败")
/* 6.208 */                return Option < CJAvifDecoder >.None
/* 6.209 */            }
/* 6.210 */        }
/* 6.211 */        else if(uri.startsWith("file://")) {
/* 6.212 */            let localFilePath = uri.removePrefix("file://")
/* 6.213 */            let imageBuffer:?Array < UInt8 >= FileUtils.getInstance().readFileSync(localFilePath)
/* 6.214 */            if(let Some(i) <- imageBuffer) {
/* 6.215 */                return createLoginc(i, threads)
/* 6.216 */            }
/* 6.217 */            else {
/* 6.218 */                Hilog.error(0, "readFileSync", "读取本地文件失败")
/* 6.219 */                return Option < CJAvifDecoder >.None
/* 6.220 */            }
/* 6.221 */        }
/* 6.222 */        else {
/* 6.223 */            let localFilePath = uri
/* 6.224 */            let imageBuffer:?Array < UInt8 >= FileUtils.getInstance().readFileSync(localFilePath)
/* 6.225 */            if(let Some(i) <- imageBuffer) {
/* 6.226 */                return createLoginc(i, threads)
/* 6.227 */            }
/* 6.228 */            else {
/* 6.229 */                Hilog.error(0, "readFileSync", "读取内容失败")
/* 6.230 */                return Option < CJAvifDecoder >.None
/* 6.231 */            }
/* 6.232 */        }
/* 6.233 */    }
/* 6.234 */
/* 6.235 */    public func getWidth(): Int64 {
/* 6.236 */        if(let Some(i) <- decoder) {
/* 6.237 */            return i.getWidth()
/* 6.238 */        }
/* 6.239 */        return 0
/* 6.240 */    }
/* 6.241 */
/* 6.242 */    public func getHeight(): Int64 {
/* 6.243 */        if(let Some(i) <- decoder) {
/* 6.244 */            return i.getHeight()
/* 6.245 */        }
/* 6.246 */        return 0
/* 6.247 */    }
/* 6.248 */
/* 6.249 */    public func getDepth(): Int64 {
/* 6.250 */        if(let Some(i) <- decoder) {
/* 6.251 */            return i.getDepth()
/* 6.252 */        }
/* 6.253 */        return 0
/* 6.254 */    }
/* 6.255 */
/* 6.256 */    public func getAlphaPresent(): Bool {
/* 6.257 */        if(let Some(i) <- decoder) {
/* 6.258 */            return i.getAlphaPresent()
/* 6.259 */        }
/* 6.260 */        return false
/* 6.261 */    }
/* 6.262 */
/* 6.263 */    public func getFrameCount(): Int64 {
/* 6.264 */        if(let Some(i) <- decoder) {
/* 6.265 */            return i.getFrameCount()
/* 6.266 */        }
/* 6.267 */        return 0
/* 6.268 */    }
/* 6.269 */
/* 6.270 */    public func getRepetitionCount(): Int64 {
/* 6.271 */        if(let Some(i) <- decoder) {
/* 6.272 */            return i.getRepetitionCount()
/* 6.273 */        }
/* 6.274 */        return 0
/* 6.275 */    }
/* 6.276 */
/* 6.277 */    public func getFrameDurations(): Option < JSArrayEx < Float64 >> {
/* 6.278 */        if(let Some(i) <- decoder) {
/* 6.279 */            if(let Some(j) <- i.getFrameDurations()) {
/* 6.280 */                return JSArrayEx(j)
/* 6.281 */            }
/* 6.282 */            else {
/* 6.283 */                return None
/* 6.284 */            }
/* 6.285 */        }
/* 6.286 */        return None
/* 6.287 */    }
/* 6.288 */
/* 6.289 */    public func isAvifImageffi(): Int32 {
/* 6.290 */        if(let Some(i) <- decoder) {
/* 6.291 */            if(let Some(j) <- encoded) {
/* 6.292 */                return i.isAvifImageffi(j)
/* 6.293 */            }
/* 6.294 */        }
/* 6.295 */        return 0
/* 6.296 */    }
/* 6.297 */
/* 6.298 */    public func nextFrameIndexffi(): Int32 {
/* 6.299 */        if(let Some(i) <- decoder) {
/* 6.300 */            return i.nextFrameIndexffi()
/* 6.301 */        }
/* 6.302 */        return 0
/* 6.303 */    }
/* 6.304 */
/* 6.305 */    public func nextFrameffi(imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 6.306 */        let value: CJReturnValue = CJReturnValue()
/* 6.307 */        if(imageWidth < 0 || imageHeight < 0) {
/* 6.308 */            value.issuccess = false
/* 6.309 */            return value
/* 6.310 */        }
/* 6.311 */        let count: Int64 = getFrameCount()
/* 6.312 */        if(count <= 0) {
/* 6.313 */            value.issuccess = false
/* 6.314 */            return value
/* 6.315 */        }
/* 6.316 */        mDiskKey = getmd5key(this.mUri.toArray())
/* 6.317 */        if(count == 1) {
/* 6.318 */            mMemoryKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight)) + "notcomponent"
/* 6.319 */        }
/* 6.320 */        var realPicWidth = imageWidth
/* 6.321 */        var realPicHeight = imageHeight
/* 6.322 */        if(imageWidth == 0) {
/* 6.323 */            realPicWidth = Int32(getWidth())
/* 6.324 */        }
/* 6.325 */        if(imageHeight == 0) {
/* 6.326 */            realPicHeight = Int32(getHeight())
/* 6.327 */        }
/* 6.328 */        let color: Array < Byte >= Array < Byte >(Int64(realPicWidth * realPicHeight * 4), repeat: 0)
/* 6.329 */        if(let Some(i) <- decoder) {
/* 6.330 */            value.code = i.nextFrameffi(color, realPicWidth, realPicHeight)
/* 6.331 */            let cacheWidth = realPicWidth
/* 6.332 */            let cacheHeight = realPicHeight
/* 6.333 */            if(value.code == 0) {
/* 6.334 */                spawn { if(count == 1) {
/* 6.335 */                    let cacheBean: CacheBean = CacheBean(Option < PixelMap >.None, color)
/* 6.336 */                    cacheBean.setMemoryWidth(Int64(cacheWidth))
/* 6.337 */                    cacheBean.setMemoryHeight(Int64(cacheHeight))
/* 6.338 */                    memoryLruCache.put(mMemoryKey, cacheBean)
/* 6.339 */                }
/* 6.340 */
/* 6.341 */                if(let Some(j) <- encoded) {
/* 6.342 */                    let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
/* 6.343 */                    if(! fileExist && mUri.startsWith("http")) {
/* 6.344 */                        fileLruCache.put(mDiskKey, j.size, j)
/* 6.345 */                    }
/* 6.346 */                }
/* 6.347 */            }
/* 6.348 */            value.issuccess = true
/* 6.349 */            value.color = color
/* 6.350 */        }
/* 6.351 */        else {
/* 6.352 */            value.issuccess = false
/* 6.353 */        }
/* 6.354 */        return value
/* 6.355 */    }
/* 6.356 */    else {
/* 6.357 */        value.issuccess = false
/* 6.358 */        return value
/* 6.359 */    }
/* 6.360 */}
/* 6.361 */
/* 6.362 */public func nextFrameffiAsync(imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 6.363 */    let value: CJReturnValue = CJReturnValue()
/* 6.364 */    if(imageWidth < 0 || imageHeight < 0) {
/* 6.365 */        value.issuccess = false
/* 6.366 */        return value
/* 6.367 */    }
/* 6.368 */    let count: Int64 = getFrameCount()
/* 6.369 */    if(count <= 0) {
/* 6.370 */        value.issuccess = false
/* 6.371 */        return value
/* 6.372 */    }
/* 6.373 */    mDiskKey = getmd5key(this.mUri.toArray())
/* 6.374 */    if(count == 1) {
/* 6.375 */        mMemoryKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight)) + "notcomponent"
/* 6.376 */    }
/* 6.377 */    var realPicWidth = imageWidth
/* 6.378 */    var realPicHeight = imageHeight
/* 6.379 */    if(imageWidth == 0) {
/* 6.380 */        realPicWidth = Int32(getWidth())
/* 6.381 */    }
/* 6.382 */    if(imageHeight == 0) {
/* 6.383 */        realPicHeight = Int32(getHeight())
/* 6.384 */    }
/* 6.385 */    let color: Array < Byte >= Array < Byte >(Int64(realPicWidth * realPicHeight * 4), repeat: 0)
/* 6.386 */    if(let Some(i) <- decoder) {
/* 6.387 */        value.code = i.nextFrameffi(color, realPicWidth, realPicHeight)
/* 6.388 */        let cacheWidth = realPicWidth
/* 6.389 */        let cacheHeight = realPicHeight
/* 6.390 */        if(value.code == 0) {
/* 6.391 */            spawn { if(count == 1) {
/* 6.392 */                let cacheBean: CacheBean = CacheBean(Option < PixelMap >.None, color)
/* 6.393 */                cacheBean.setMemoryWidth(Int64(cacheWidth))
/* 6.394 */                cacheBean.setMemoryHeight(Int64(cacheHeight))
/* 6.395 */                memoryLruCache.put(mMemoryKey, cacheBean)
/* 6.396 */            }
/* 6.397 */
/* 6.398 */            if(let Some(j) <- encoded) {
/* 6.399 */                let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
/* 6.400 */                if(! fileExist && mUri.startsWith("http")) {
/* 6.401 */                    fileLruCache.put(mDiskKey, j.size, j)
/* 6.402 */                }
/* 6.403 */            }
/* 6.404 */        }
/* 6.405 */        value.issuccess = true
/* 6.406 */        value.color = color
/* 6.407 */    }
/* 6.408 */    else {
/* 6.409 */        value.issuccess = false
/* 6.410 */    }
/* 6.411 */    return value
/* 6.412 */}
/* 6.413 */else {
/* 6.414 */    value.issuccess = false
/* 6.415 */    return value
/* 6.416 */}
/* 6.417 */}
/* 6.418 */
/* 6.419 */public func nthFrameffi(index: Int32, imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 6.420 */let value: CJReturnValue = CJReturnValue()
/* 6.421 */if(imageWidth < 0 || imageHeight < 0) {
/* 6.422 */    value.issuccess = false
/* 6.423 */    return value
/* 6.424 */}
/* 6.425 */let count: Int64 = getFrameCount()
/* 6.426 */if(count <= 0) {
/* 6.427 */    value.issuccess = false
/* 6.428 */    return value
/* 6.429 */}
/* 6.430 */mDiskKey = getmd5key(this.mUri.toArray())
/* 6.431 */if(count == 1) {
/* 6.432 */    mMemoryKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight)) + "notcomponent"
/* 6.433 */}
/* 6.434 */var realPicWidth = imageWidth
/* 6.435 */var realPicHeight = imageHeight
/* 6.436 */if(imageWidth == 0) {
/* 6.437 */    realPicWidth = Int32(getWidth())
/* 6.438 */}
/* 6.439 */if(imageHeight == 0) {
/* 6.440 */    realPicHeight = Int32(getHeight())
/* 6.441 */}
/* 6.442 */let color: Array < Byte >= Array < Byte >(Int64(realPicWidth * realPicHeight * 4), repeat: 0)
/* 6.443 */if(let Some(i) <- decoder) {
/* 6.444 */    if(count == 1) {
/* 6.445 */        value.code = i.nthFrameffi(0, color, realPicWidth, realPicHeight)
/* 6.446 */    }
/* 6.447 */    else {
/* 6.448 */        value.code = i.nthFrameffi(index, color, realPicWidth, realPicHeight)
/* 6.449 */    }
/* 6.450 */    let cacheWidth = realPicWidth
/* 6.451 */    let cacheHeight = realPicHeight
/* 6.452 */    if(value.code == 0) {
/* 6.453 */        spawn { if(count == 1) {
/* 6.454 */            let cacheBean: CacheBean = CacheBean(Option < PixelMap >.None, color)
/* 6.455 */            cacheBean.setMemoryWidth(Int64(cacheWidth))
/* 6.456 */            cacheBean.setMemoryHeight(Int64(cacheHeight))
/* 6.457 */            memoryLruCache.put(mMemoryKey, cacheBean)
/* 6.458 */        }
/* 6.459 */
/* 6.460 */        if(let Some(j) <- encoded) {
/* 6.461 */            let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
/* 6.462 */            if(! fileExist && mUri.startsWith("http")) {
/* 6.463 */                fileLruCache.put(mDiskKey, j.size, j)
/* 6.464 */            }
/* 6.465 */        }
/* 6.466 */    }
/* 6.467 */    value.issuccess = true
/* 6.468 */    value.color = color
/* 6.469 */}
/* 6.470 */else {
/* 6.471 */    value.issuccess = false
/* 6.472 */}
/* 6.473 */return value
/* 6.474 */}
/* 6.475 */else {
/* 6.476 */value.issuccess = false
/* 6.477 */return value
/* 6.478 */}
/* 6.479 */}
/* 6.480 */
/* 6.481 */public func nthFrameffiAsync(index: Int32, imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 6.482 */let value: CJReturnValue = CJReturnValue()
/* 6.483 */if(imageWidth < 0 || imageHeight < 0) {
/* 6.484 */value.issuccess = false
/* 6.485 */return value
/* 6.486 */}
/* 6.487 */let count: Int64 = getFrameCount()
/* 6.488 */if(count <= 0) {
/* 6.489 */value.issuccess = false
/* 6.490 */return value
/* 6.491 */}
/* 6.492 */mDiskKey = getmd5key(this.mUri.toArray())
/* 6.493 */if(count == 1) {
/* 6.494 */mMemoryKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight)) + "notcomponent"
/* 6.495 */}
/* 6.496 */var realPicWidth = imageWidth
/* 6.497 */var realPicHeight = imageHeight
/* 6.498 */if(imageWidth == 0) {
/* 6.499 */realPicWidth = Int32(getWidth())
/* 6.500 */}
/* 6.501 */if(imageHeight == 0) {
/* 6.502 */realPicHeight = Int32(getHeight())
/* 6.503 */}
/* 6.504 */let color: Array < Byte >= Array < Byte >(Int64(realPicWidth * realPicHeight * 4), repeat: 0)
/* 6.505 */if(let Some(i) <- decoder) {
/* 6.506 */if(count == 1) {
/* 6.507 */    value.code = i.nthFrameffi(0, color, realPicWidth, realPicHeight)
/* 6.508 */}
/* 6.509 */else {
/* 6.510 */    value.code = i.nthFrameffi(index, color, realPicWidth, realPicHeight)
/* 6.511 */}
/* 6.512 */let cacheWidth = realPicWidth
/* 6.513 */let cacheHeight = realPicHeight
/* 6.514 */if(value.code == 0) {
/* 6.515 */    spawn { if(count == 1) {
/* 6.516 */        let cacheBean: CacheBean = CacheBean(Option < PixelMap >.None, color)
/* 6.517 */        cacheBean.setMemoryWidth(Int64(cacheWidth))
/* 6.518 */        cacheBean.setMemoryHeight(Int64(cacheHeight))
/* 6.519 */        memoryLruCache.put(mMemoryKey, cacheBean)
/* 6.520 */    }
/* 6.521 */
/* 6.522 */    if(let Some(j) <- encoded) {
/* 6.523 */        let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
/* 6.524 */        if(! fileExist && mUri.startsWith("http")) {
/* 6.525 */            fileLruCache.put(mDiskKey, j.size, j)
/* 6.526 */        }
/* 6.527 */    }
/* 6.528 */}
/* 6.529 */value.issuccess = true
/* 6.530 */value.color = color
/* 6.531 */}
/* 6.532 */else {
/* 6.533 */value.issuccess = false
/* 6.534 */}
/* 6.535 */return value
/* 6.536 */}
/* 6.537 */else {
/* 6.538 */value.issuccess = false
/* 6.539 */return value
/* 6.540 */}
/* 6.541 */}
/* 6.542 */
/* 6.543 */public func release(): Unit {
/* 6.544 */if(let Some(i) <- decoder) {
/* 6.545 */return i.release()
/* 6.546 */}
/* 6.547 */}
/* 6.548 */
/* 6.549 */
/* 6.550 */
/* 6.551 */public static func create_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.552 */
/* 6.553 */let thisArg = callInfo.thisArg
/* 6.554 */let thisObject = thisArg.asObject(context)
/* 6.555 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.556 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.557 */
/* 6.558 */let arg1774327353873065300 = String.fromJSValue(context, callInfo[0])
/* 6.559 */
/* 6.560 */JSCurrentJSContext.set(context)
/* 6.561 */let RET = clazz.create(arg1774327353873065300)
/* 6.562 */JSCurrentJSContext.unset()
/* 6.563 */RET.toJSValue(context)
/* 6.564 */}
/* 6.565 */


public static func createAsync_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
    let thisArg = callInfo.thisArg
    let thisObject = thisArg.asObject(context)
    let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
    let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

    let arg1774327353873343900 = String.fromJSValue(context, callInfo[0])

    JSCurrentJSContext.set(context)
    let promise = context.promiseCapability()
    spawn {
        let RET = clazz.createAsync(arg1774327353873343900)
        context.postJSTask {
            promise.resolve(RET.toJSValue(context))
        }
    }
    JSCurrentJSContext.unset()
    promise.toJSValue()
}


/* 6.580 */
/* 6.581 */public static func createWithThread_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.582 */
/* 6.583 */let thisArg = callInfo.thisArg
/* 6.584 */let thisObject = thisArg.asObject(context)
/* 6.585 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.586 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.587 */
/* 6.588 */let arg1774327353873991600 = String.fromJSValue(context, callInfo[0])
/* 6.589 */let arg1774327353874014800 = Int32.fromJSValue(context, callInfo[1])
/* 6.590 */
/* 6.591 */JSCurrentJSContext.set(context)
/* 6.592 */let RET = clazz.createWithThread(arg1774327353873991600, arg1774327353874014800)
/* 6.593 */JSCurrentJSContext.unset()
/* 6.594 */RET.toJSValue(context)
/* 6.595 */}
/* 6.596 */


public static func createWithThreadAsync_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
    let thisArg = callInfo.thisArg
    let thisObject = thisArg.asObject(context)
    let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
    let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

    let arg1774327353875012900 = String.fromJSValue(context, callInfo[0])
    let arg1774327353875038800 = Int32.fromJSValue(context, callInfo[1])

    JSCurrentJSContext.set(context)
    let promise = context.promiseCapability()
    spawn {
        let RET = clazz.createWithThreadAsync(arg1774327353875012900, arg1774327353875038800)
        context.postJSTask {
            promise.resolve(RET.toJSValue(context))
        }
    }
    JSCurrentJSContext.unset()
    promise.toJSValue()
}



/* 6.612 */
/* 6.613 */public static func getWidth_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.614 */
/* 6.615 */let thisArg = callInfo.thisArg
/* 6.616 */let thisObject = thisArg.asObject(context)
/* 6.617 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.618 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.619 */
/* 6.620 */
/* 6.621 */JSCurrentJSContext.set(context)
/* 6.622 */let RET = clazz.getWidth()
/* 6.623 */JSCurrentJSContext.unset()
/* 6.624 */RET.toJSValue(context)
/* 6.625 */}
/* 6.626 */
/* 6.627 */public static func getHeight_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.628 */
/* 6.629 */let thisArg = callInfo.thisArg
/* 6.630 */let thisObject = thisArg.asObject(context)
/* 6.631 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.632 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.633 */
/* 6.634 */
/* 6.635 */JSCurrentJSContext.set(context)
/* 6.636 */let RET = clazz.getHeight()
/* 6.637 */JSCurrentJSContext.unset()
/* 6.638 */RET.toJSValue(context)
/* 6.639 */}
/* 6.640 */
/* 6.641 */public static func getDepth_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.642 */
/* 6.643 */let thisArg = callInfo.thisArg
/* 6.644 */let thisObject = thisArg.asObject(context)
/* 6.645 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.646 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.647 */
/* 6.648 */
/* 6.649 */JSCurrentJSContext.set(context)
/* 6.650 */let RET = clazz.getDepth()
/* 6.651 */JSCurrentJSContext.unset()
/* 6.652 */RET.toJSValue(context)
/* 6.653 */}
/* 6.654 */
/* 6.655 */public static func getAlphaPresent_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.656 */
/* 6.657 */let thisArg = callInfo.thisArg
/* 6.658 */let thisObject = thisArg.asObject(context)
/* 6.659 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.660 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.661 */
/* 6.662 */
/* 6.663 */JSCurrentJSContext.set(context)
/* 6.664 */let RET = clazz.getAlphaPresent()
/* 6.665 */JSCurrentJSContext.unset()
/* 6.666 */RET.toJSValue(context)
/* 6.667 */}
/* 6.668 */
/* 6.669 */public static func getFrameCount_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.670 */
/* 6.671 */let thisArg = callInfo.thisArg
/* 6.672 */let thisObject = thisArg.asObject(context)
/* 6.673 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.674 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.675 */
/* 6.676 */
/* 6.677 */JSCurrentJSContext.set(context)
/* 6.678 */let RET = clazz.getFrameCount()
/* 6.679 */JSCurrentJSContext.unset()
/* 6.680 */RET.toJSValue(context)
/* 6.681 */}
/* 6.682 */
/* 6.683 */public static func getRepetitionCount_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.684 */
/* 6.685 */let thisArg = callInfo.thisArg
/* 6.686 */let thisObject = thisArg.asObject(context)
/* 6.687 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.688 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.689 */
/* 6.690 */
/* 6.691 */JSCurrentJSContext.set(context)
/* 6.692 */let RET = clazz.getRepetitionCount()
/* 6.693 */JSCurrentJSContext.unset()
/* 6.694 */RET.toJSValue(context)
/* 6.695 */}
/* 6.696 */
/* 6.697 */public static func getFrameDurations_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.698 */
/* 6.699 */let thisArg = callInfo.thisArg
/* 6.700 */let thisObject = thisArg.asObject(context)
/* 6.701 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.702 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.703 */
/* 6.704 */
/* 6.705 */JSCurrentJSContext.set(context)
/* 6.706 */let RET = clazz.getFrameDurations()
/* 6.707 */JSCurrentJSContext.unset()
/* 6.708 */RET.toJSValue(context)
/* 6.709 */}
/* 6.710 */
/* 6.711 */public static func isAvifImageffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.712 */
/* 6.713 */let thisArg = callInfo.thisArg
/* 6.714 */let thisObject = thisArg.asObject(context)
/* 6.715 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.716 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.717 */
/* 6.718 */
/* 6.719 */JSCurrentJSContext.set(context)
/* 6.720 */let RET = clazz.isAvifImageffi()
/* 6.721 */JSCurrentJSContext.unset()
/* 6.722 */RET.toJSValue(context)
/* 6.723 */}
/* 6.724 */
/* 6.725 */public static func nextFrameIndexffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.726 */
/* 6.727 */let thisArg = callInfo.thisArg
/* 6.728 */let thisObject = thisArg.asObject(context)
/* 6.729 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.730 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.731 */
/* 6.732 */
/* 6.733 */JSCurrentJSContext.set(context)
/* 6.734 */let RET = clazz.nextFrameIndexffi()
/* 6.735 */JSCurrentJSContext.unset()
/* 6.736 */RET.toJSValue(context)
/* 6.737 */}
/* 6.738 */
/* 6.739 */public static func nextFrameffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.740 */
/* 6.741 */let thisArg = callInfo.thisArg
/* 6.742 */let thisObject = thisArg.asObject(context)
/* 6.743 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.744 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.745 */
/* 6.746 */let arg1774327353877362200 = Int32.fromJSValue(context, callInfo[0])
/* 6.747 */let arg1774327353877388500 = Int32.fromJSValue(context, callInfo[1])
/* 6.748 */
/* 6.749 */JSCurrentJSContext.set(context)
/* 6.750 */let RET = clazz.nextFrameffi(arg1774327353877362200, arg1774327353877388500)
/* 6.751 */JSCurrentJSContext.unset()
/* 6.752 */RET.toJSValue(context)
/* 6.753 */}
/* 6.754 */


public static func nextFrameffiAsync_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
    let thisArg = callInfo.thisArg
    let thisObject = thisArg.asObject(context)
    let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
    let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

    let arg1774327353877909000 = Int32.fromJSValue(context, callInfo[0])
    let arg1774327353877933500 = Int32.fromJSValue(context, callInfo[1])

    JSCurrentJSContext.set(context)
    let promise = context.promiseCapability()
    spawn {
        let RET = clazz.nextFrameffiAsync(arg1774327353877909000, arg1774327353877933500)
        context.postJSTask {
            promise.resolve(RET.toJSValue(context))
        }
    }
    JSCurrentJSContext.unset()
    promise.toJSValue()
}


/* 6.770 */
/* 6.771 */public static func nthFrameffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.772 */
/* 6.773 */let thisArg = callInfo.thisArg
/* 6.774 */let thisObject = thisArg.asObject(context)
/* 6.775 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.776 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.777 */
/* 6.778 */let arg1774327353878559100 = Int32.fromJSValue(context, callInfo[0])
/* 6.779 */let arg1774327353878582600 = Int32.fromJSValue(context, callInfo[1])
/* 6.780 */let arg1774327353878606700 = Int32.fromJSValue(context, callInfo[2])
/* 6.781 */
/* 6.782 */JSCurrentJSContext.set(context)
/* 6.783 */let RET = clazz.nthFrameffi(arg1774327353878559100, arg1774327353878582600, arg1774327353878606700)
/* 6.784 */JSCurrentJSContext.unset()
/* 6.785 */RET.toJSValue(context)
/* 6.786 */}
/* 6.787 */


public static func nthFrameffiAsync_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
    let thisArg = callInfo.thisArg
    let thisObject = thisArg.asObject(context)
    let jsExternal = thisObject.getAttachInfo() ?? throw Exception("class: get external failed.")
    let clazz = jsExternal.cast<CJAvifDecoder>() ?? throw Exception("class: get clazz failed.")

    let arg1774327353879130000 = Int32.fromJSValue(context, callInfo[0])
    let arg1774327353879158000 = Int32.fromJSValue(context, callInfo[1])
    let arg1774327353879179900 = Int32.fromJSValue(context, callInfo[2])

    JSCurrentJSContext.set(context)
    let promise = context.promiseCapability()
    spawn {
        let RET = clazz.nthFrameffiAsync(arg1774327353879130000, arg1774327353879158000, arg1774327353879179900)
        context.postJSTask {
            promise.resolve(RET.toJSValue(context))
        }
    }
    JSCurrentJSContext.unset()
    promise.toJSValue()
}



/* 6.804 */
/* 6.805 */public static func release_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 6.806 */
/* 6.807 */let thisArg = callInfo.thisArg
/* 6.808 */let thisObject = thisArg.asObject(context)
/* 6.809 */let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.810 */let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.811 */
/* 6.812 */
/* 6.813 */JSCurrentJSContext.set(context)
/* 6.814 */let RET = clazz.release()
/* 6.815 */JSCurrentJSContext.unset()
/* 6.816 */RET.toJSValue(context)
/* 6.817 */}
/* 6.818 */
/* 6.819 */
/* 6.820 */
/* 6.821 */
/* 6.822 */
/* 6.823 */
/* 6.824 */
/* 6.825 */
/* 6.826 */public func toJSValue(context: JSContext): JSValue {
/* 6.827 */let ext = context.external(this)
/* 6.828 */let obj = context.object()
/* 6.829 */
/* 6.830 */
/* 6.831 */
/* 6.832 */obj["create"] =
/* 6.833 */context.function(create_ArkTS_Interop_Identifier).toJSValue()
/* 6.834 */
/* 6.835 */obj["createAsync"] =
/* 6.836 */context.function(createAsync_ArkTS_Interop_Identifier).toJSValue()
/* 6.837 */
/* 6.838 */obj["createWithThread"] =
/* 6.839 */context.function(createWithThread_ArkTS_Interop_Identifier).toJSValue()
/* 6.840 */
/* 6.841 */obj["createWithThreadAsync"] =
/* 6.842 */context.function(createWithThreadAsync_ArkTS_Interop_Identifier).toJSValue()
/* 6.843 */
/* 6.844 */obj["getWidth"] =
/* 6.845 */context.function(getWidth_ArkTS_Interop_Identifier).toJSValue()
/* 6.846 */
/* 6.847 */obj["getHeight"] =
/* 6.848 */context.function(getHeight_ArkTS_Interop_Identifier).toJSValue()
/* 6.849 */
/* 6.850 */obj["getDepth"] =
/* 6.851 */context.function(getDepth_ArkTS_Interop_Identifier).toJSValue()
/* 6.852 */
/* 6.853 */obj["getAlphaPresent"] =
/* 6.854 */context.function(getAlphaPresent_ArkTS_Interop_Identifier).toJSValue()
/* 6.855 */
/* 6.856 */obj["getFrameCount"] =
/* 6.857 */context.function(getFrameCount_ArkTS_Interop_Identifier).toJSValue()
/* 6.858 */
/* 6.859 */obj["getRepetitionCount"] =
/* 6.860 */context.function(getRepetitionCount_ArkTS_Interop_Identifier).toJSValue()
/* 6.861 */
/* 6.862 */obj["getFrameDurations"] =
/* 6.863 */context.function(getFrameDurations_ArkTS_Interop_Identifier).toJSValue()
/* 6.864 */
/* 6.865 */obj["isAvifImageffi"] =
/* 6.866 */context.function(isAvifImageffi_ArkTS_Interop_Identifier).toJSValue()
/* 6.867 */
/* 6.868 */obj["nextFrameIndexffi"] =
/* 6.869 */context.function(nextFrameIndexffi_ArkTS_Interop_Identifier).toJSValue()
/* 6.870 */
/* 6.871 */obj["nextFrameffi"] =
/* 6.872 */context.function(nextFrameffi_ArkTS_Interop_Identifier).toJSValue()
/* 6.873 */
/* 6.874 */obj["nextFrameffiAsync"] =
/* 6.875 */context.function(nextFrameffiAsync_ArkTS_Interop_Identifier).toJSValue()
/* 6.876 */
/* 6.877 */obj["nthFrameffi"] =
/* 6.878 */context.function(nthFrameffi_ArkTS_Interop_Identifier).toJSValue()
/* 6.879 */
/* 6.880 */obj["nthFrameffiAsync"] =
/* 6.881 */context.function(nthFrameffiAsync_ArkTS_Interop_Identifier).toJSValue()
/* 6.882 */
/* 6.883 */obj["release"] =
/* 6.884 */context.function(release_ArkTS_Interop_Identifier).toJSValue()
/* 6.885 */
/* 6.886 */obj.attachCJObject(ext)
/* 6.887 */obj.toJSValue()
/* 6.888 */}
/* 6.889 */
/* 6.890 */
/* 6.891 */public static func fromJSValue(context: JSContext, input: JSValue) {
/* 6.892 */let jsObj = input.asObject(context)
/* 6.893 */let jsExt = jsObj.getAttachInfo()??throw Exception("class: get external failed.")
/* 6.894 */let obj = jsExt.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 6.895 */return obj
/* 6.896 */}
/* 6.897 */public static func toArkTsType(): String {
/* 6.898 */"class"
/* 6.899 */}
/* 6.900 */
/* 6.901 */private var decoder: Option < AvifDecoder >= None
/* 6.902 */var mMemoryKey = ""
/* 6.903 */var mDiskKey = ""
/* 6.904 */var mUri = ""
/* 6.905 */var encoded:?Array < Byte >= None
/* 6.906 */func createLoginc(buffer: Array < UInt8 >, threads: Int32): Option < CJAvifDecoder > {
/* 6.907 */encoded = buffer
/* 6.908 */decoder = AvifDecoder(buffer, threads)
/* 6.909 */if(let Some(k) <- decoder) {
/* 6.910 */if(k.decoder == 0) {
/* 6.911 */return Option < CJAvifDecoder >.None
/* 6.912 */}
/* 6.913 */return this
/* 6.914 */}
/* 6.915 */else {
/* 6.916 */return Option < CJAvifDecoder >.None
/* 6.917 */}
/* 6.918 */}
/* 6.919 */
/* 6.920 */}
/* 6.921 */
/* ===== End of the Emit ===== */