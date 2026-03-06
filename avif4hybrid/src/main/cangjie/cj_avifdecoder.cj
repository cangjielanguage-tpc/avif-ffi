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
/* 8.48 */            clazz.addMethod("decodeffi",
/* 8.49 */            context.function(decodeffi_ArkTS_Interop_Identifier))
/* 8.50 */
/* 8.51 */            clazz.addMethod("release",
/* 8.52 */            context.function(release_ArkTS_Interop_Identifier))
/* 8.53 */
/* 8.54 */            return clazz
/* 8.55 */        }
/* 8.56 */    }
/* 8.57 */
/* 8.58 */
/* 8.59 */    public init() {
/* 8.60 */    }
/* 8.61 */
/* 8.62 */    public static func jsConstructor(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.63 */
/* 8.64 */        JSCurrentJSContext.set(context)
/* 8.65 */        let clazz = CJAvifDecoder()
/* 8.66 */        JSCurrentJSContext.unset()
/* 8.67 */        let thisArg = callInfo.thisArg
/* 8.68 */        let thisObject = thisArg.asObject(context)
/* 8.69 */        let jsExternal = context.external(clazz)
/* 8.70 */        thisObject.attachCJObject(jsExternal)
/* 8.71 */        return thisObject.toJSValue()
/* 8.72 */    }
/* 8.73 */
/* 8.74 */
/* 8.75 */
/* 8.76 */
/* 8.77 */
/* 8.78 */
/* 8.79 */
/* 8.80 */    public func create(uri: String): Option < CJAvifDecoder > {
/* 8.81 */        return createWithThread(uri, 1)
/* 8.82 */    }
/* 8.83 */
/* 8.84 */    public func createWithThread(uri: String, threads: Int32): Option < CJAvifDecoder > {
/* 8.85 */        this.mUri = uri
/* 8.86 */        if(uri.startsWith("http")) {
/* 8.87 */            let imageBuffer = getImageFromNet(uri)
/* 8.88 */            if(let Some(i) <- imageBuffer) {
/* 8.89 */                return createLoginc(i, threads)
/* 8.90 */            }
/* 8.91 */            else {
/* 8.92 */                Hilog.error(0, "getImageFromRawFile", "获取网络文件内容失败")
/* 8.93 */                return Option < CJAvifDecoder >.None
/* 8.94 */            }
/* 8.95 */        }
/* 8.96 */        else if(uri.startsWith("rawfile://")) {
/* 8.97 */            let fileName = uri.removePrefix("rawfile://")
/* 8.98 */            let imageBuffer = getImageFromRawFile(fileName)
/* 8.99 */            if(let Some(i) <- imageBuffer) {
/* 8.100 */                return createLoginc(i, threads)
/* 8.101 */            }
/* 8.102 */            else {
/* 8.103 */                Hilog.error(0, "getImageFromRawFile", "获取raw文件内容失败")
/* 8.104 */                return Option < CJAvifDecoder >.None
/* 8.105 */            }
/* 8.106 */        }
/* 8.107 */        else if(uri.startsWith("media://")) {
/* 8.108 */            let mediaName = uri.removePrefix("media://")
/* 8.109 */            let imageBuffer = getImageFromMedia(mediaName)
/* 8.110 */            if(let Some(i) <- imageBuffer) {
/* 8.111 */                return createLoginc(i, threads)
/* 8.112 */            }
/* 8.113 */            else {
/* 8.114 */                Hilog.error(0, "getImageFromMedia", "获取media文件内容失败")
/* 8.115 */                return Option < CJAvifDecoder >.None
/* 8.116 */            }
/* 8.117 */        }
/* 8.118 */        else if(uri.startsWith("file://")) {
/* 8.119 */            let localFilePath = uri.removePrefix("file://")
/* 8.120 */            let imageBuffer:?Array < UInt8 >= FileUtils.getInstance().readFileSync(localFilePath)
/* 8.121 */            if(let Some(i) <- imageBuffer) {
/* 8.122 */                return createLoginc(i, threads)
/* 8.123 */            }
/* 8.124 */            else {
/* 8.125 */                Hilog.error(0, "readFileSync", "读取本地文件失败")
/* 8.126 */                return Option < CJAvifDecoder >.None
/* 8.127 */            }
/* 8.128 */        }
/* 8.129 */        else {
/* 8.130 */            let localFilePath = uri
/* 8.131 */            let imageBuffer:?Array < UInt8 >= FileUtils.getInstance().readFileSync(localFilePath)
/* 8.132 */            if(let Some(i) <- imageBuffer) {
/* 8.133 */                return createLoginc(i, threads)
/* 8.134 */            }
/* 8.135 */            else {
/* 8.136 */                Hilog.error(0, "readFileSync", "读取内容失败")
/* 8.137 */                return Option < CJAvifDecoder >.None
/* 8.138 */            }
/* 8.139 */        }
/* 8.140 */    }
/* 8.141 */
/* 8.142 */    public func getWidth(): Int64 {
/* 8.143 */        if(let Some(i) <- decoder) {
/* 8.144 */            return i.getWidth()
/* 8.145 */        }
/* 8.146 */        return 0
/* 8.147 */    }
/* 8.148 */
/* 8.149 */    public func getHeight(): Int64 {
/* 8.150 */        if(let Some(i) <- decoder) {
/* 8.151 */            return i.getHeight()
/* 8.152 */        }
/* 8.153 */        return 0
/* 8.154 */    }
/* 8.155 */
/* 8.156 */    public func getDepth(): Int64 {
/* 8.157 */        if(let Some(i) <- decoder) {
/* 8.158 */            return i.getDepth()
/* 8.159 */        }
/* 8.160 */        return 0
/* 8.161 */    }
/* 8.162 */
/* 8.163 */    public func getAlphaPresent(): Bool {
/* 8.164 */        if(let Some(i) <- decoder) {
/* 8.165 */            return i.getAlphaPresent()
/* 8.166 */        }
/* 8.167 */        return false
/* 8.168 */    }
/* 8.169 */
/* 8.170 */    public func getFrameCount(): Int64 {
/* 8.171 */        if(let Some(i) <- decoder) {
/* 8.172 */            return i.getFrameCount()
/* 8.173 */        }
/* 8.174 */        return 0
/* 8.175 */    }
/* 8.176 */
/* 8.177 */    public func getRepetitionCount(): Int64 {
/* 8.178 */        if(let Some(i) <- decoder) {
/* 8.179 */            return i.getRepetitionCount()
/* 8.180 */        }
/* 8.181 */        return 0
/* 8.182 */    }
/* 8.183 */
/* 8.184 */    public func getFrameDurations(): Option < JSArrayEx < Float64 >> {
/* 8.185 */        if(let Some(i) <- decoder) {
/* 8.186 */            if(let Some(j) <- i.getFrameDurations()) {
/* 8.187 */                return JSArrayEx(j)
/* 8.188 */            }
/* 8.189 */            else {
/* 8.190 */                return None
/* 8.191 */            }
/* 8.192 */        }
/* 8.193 */        return None
/* 8.194 */    }
/* 8.195 */
/* 8.196 */    public func isAvifImageffi(): Int32 {
/* 8.197 */        if(let Some(i) <- decoder) {
/* 8.198 */            if(let Some(j) <- encoded) {
/* 8.199 */                return i.isAvifImageffi(j)
/* 8.200 */            }
/* 8.201 */        }
/* 8.202 */        return 0
/* 8.203 */    }
/* 8.204 */
/* 8.205 */    public func nextFrameIndexffi(): Int32 {
/* 8.206 */        if(let Some(i) <- decoder) {
/* 8.207 */            return i.nextFrameIndexffi()
/* 8.208 */        }
/* 8.209 */        return 0
/* 8.210 */    }
/* 8.211 */
/* 8.212 */    public func nextFrameffi(imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 8.213 */        let value: CJReturnValue = CJReturnValue()
/* 8.214 */        if(imageWidth <= 0 || imageHeight <= 0) {
/* 8.215 */            value.issuccess = false
/* 8.216 */            return value
/* 8.217 */        }
/* 8.218 */        let count: Int64 = getFrameCount()
/* 8.219 */        if(count <= 0) {
/* 8.220 */            value.issuccess = false
/* 8.221 */            return value
/* 8.222 */        }
/* 8.223 */        if(count == 1) {
/* 8.224 */            mKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
/* 8.225 */        }
/* 8.226 */        else {
/* 8.227 */            let index: Int32 = nextFrameIndexffi()
/* 8.228 */            mKey = getmd5keyWithIndex(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight), index)
/* 8.229 */        }
/* 8.230 */        let memPixelMap:?CacheBean = memoryLruCache.get(mKey)
/* 8.231 */        if(let Some(cache) <- memPixelMap) {
/* 8.232 */            let pixelMap = cache.getPixelMap()
/* 8.233 */            if(let Some(i) <- pixelMap) {
/* 8.234 */                let readBuffer: Array < Byte >= Array < Byte >(Int64(imageWidth * imageHeight * 4), repeat: 0)
/* 8.235 */                i.readPixelsToBuffer(readBuffer)
/* 8.236 */                value.color = convertBGRAtoRGBA(readBuffer)
/* 8.237 */                value.issuccess = true
/* 8.238 */                return value
/* 8.239 */            }
/* 8.240 */        }
/* 8.241 */        let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mKey)
/* 8.242 */        if(fileExist) {
/* 8.243 */            let source:?Array < UInt8 >= fileLruCache.get(mKey)
/* 8.244 */            if(let Some(i) <- source) {
/* 8.245 */                let colors = i[4 .. i.size]
/* 8.246 */                spawn { let finalWidth: Int32 = Int32(UInt16(i[0]) << 8 | UInt16(i[1]))
/* 8.247 */
/* 8.248 */                    let finalHeight: Int32 = Int32(UInt16(i[2]) << 8 | UInt16(i[3]))
/* 8.249 */
/* 8.250 */                    let size2: Size = Size(width: Int32(finalWidth), height: Int32(finalHeight))
/* 8.251 */
/* 8.252 */                    let opts: InitializationOptions = InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
/* 8.253 */
/* 8.254 */                    let tempPixelMap = createPixelMap(colors, opts)
/* 8.255 */
/* 8.256 */                    let cacheBean: CacheBean = CacheBean(Option < MultiPixelMap >.None, tempPixelMap)
/* 8.257 */
/* 8.258 */                memoryLruCache.put(mKey, cacheBean) }
/* 8.259 */                value.color = colors
/* 8.260 */                value.issuccess = true
/* 8.261 */                return value
/* 8.262 */            }
/* 8.263 */        }
/* 8.264 */        let color: Array < Byte >= Array < Byte >(Int64(imageWidth * imageHeight * 4), repeat: 0)
/* 8.265 */        if(let Some(i) <- decoder) {
/* 8.266 */            value.code = i.nextFrameffi(color, imageWidth, imageHeight)
/* 8.267 */            if(value.code == 0) {
/* 8.268 */                spawn { let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
/* 8.269 */
/* 8.270 */                    let opts: InitializationOptions = InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
/* 8.271 */
/* 8.272 */                    let tempPixelMap = createPixelMap(color, opts)
/* 8.273 */
/* 8.274 */                    let cacheBean: CacheBean = CacheBean(Option < MultiPixelMap >.None, tempPixelMap)
/* 8.275 */
/* 8.276 */                    memoryLruCache.put(mKey, cacheBean)
/* 8.277 */                fileLruCache.put(mKey, color.size + 4, color, Int64(imageWidth), Int64(imageHeight)) }
/* 8.278 */                value.issuccess = true
/* 8.279 */                value.color = color
/* 8.280 */            }
/* 8.281 */            else {
/* 8.282 */                value.issuccess = false
/* 8.283 */            }
/* 8.284 */            return value
/* 8.285 */        }
/* 8.286 */        else {
/* 8.287 */            value.issuccess = false
/* 8.288 */            return value
/* 8.289 */        }
/* 8.290 */    }
/* 8.291 */
/* 8.292 */    public func nthFrameffi(index: Int32, imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 8.293 */        let value: CJReturnValue = CJReturnValue()
/* 8.294 */        if(imageWidth <= 0 || imageHeight <= 0) {
/* 8.295 */            value.issuccess = false
/* 8.296 */            return value
/* 8.297 */        }
/* 8.298 */        let count: Int64 = getFrameCount()
/* 8.299 */        if(count <= 0) {
/* 8.300 */            value.issuccess = false
/* 8.301 */            return value
/* 8.302 */        }
/* 8.303 */        if(count == 1) {
/* 8.304 */            mKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
/* 8.305 */        }
/* 8.306 */        else {
/* 8.307 */            mKey = getmd5keyWithIndex(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight), index)
/* 8.308 */        }
/* 8.309 */        let memPixelMap:?CacheBean = memoryLruCache.get(mKey)
/* 8.310 */        if(let Some(cache) <- memPixelMap) {
/* 8.311 */            let pixelMap = cache.getPixelMap()
/* 8.312 */            if(let Some(i) <- pixelMap) {
/* 8.313 */                let readBuffer: Array < Byte >= Array < Byte >(Int64(imageWidth * imageHeight * 4), repeat: 0)
/* 8.314 */                i.readPixelsToBuffer(readBuffer)
/* 8.315 */                value.color = convertBGRAtoRGBA(readBuffer)
/* 8.316 */                value.issuccess = true
/* 8.317 */                return value
/* 8.318 */            }
/* 8.319 */        }
/* 8.320 */        let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mKey)
/* 8.321 */        if(fileExist) {
/* 8.322 */            let source:?Array < UInt8 >= fileLruCache.get(mKey)
/* 8.323 */            if(let Some(i) <- source) {
/* 8.324 */                let colors = i[4 .. i.size]
/* 8.325 */                spawn { let finalWidth: Int32 = Int32(UInt16(i[0]) << 8 | UInt16(i[1]))
/* 8.326 */
/* 8.327 */                    let finalHeight: Int32 = Int32(UInt16(i[2]) << 8 | UInt16(i[3]))
/* 8.328 */
/* 8.329 */                    let size2: Size = Size(width: Int32(finalWidth), height: Int32(finalHeight))
/* 8.330 */
/* 8.331 */                    let opts: InitializationOptions = InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
/* 8.332 */
/* 8.333 */                    let tempPixelMap = createPixelMap(colors, opts)
/* 8.334 */
/* 8.335 */                    let cacheBean: CacheBean = CacheBean(Option < MultiPixelMap >.None, tempPixelMap)
/* 8.336 */
/* 8.337 */                memoryLruCache.put(mKey, cacheBean) }
/* 8.338 */                value.color = colors
/* 8.339 */                value.issuccess = true
/* 8.340 */                return value
/* 8.341 */            }
/* 8.342 */        }
/* 8.343 */        let color: Array < Byte >= Array < Byte >(Int64(imageWidth * imageHeight * 4), repeat: 0)
/* 8.344 */        if(let Some(i) <- decoder) {
/* 8.345 */            if(count == 1) {
/* 8.346 */                value.code = i.nthFrameffi(0, color, imageWidth, imageHeight)
/* 8.347 */            }
/* 8.348 */            else {
/* 8.349 */                value.code = i.nthFrameffi(index, color, imageWidth, imageHeight)
/* 8.350 */            }
/* 8.351 */            if(value.code == 0) {
/* 8.352 */                spawn { let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
/* 8.353 */
/* 8.354 */                    let opts: InitializationOptions = InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
/* 8.355 */
/* 8.356 */                    let tempPixelMap = createPixelMap(color, opts)
/* 8.357 */
/* 8.358 */                    let cacheBean: CacheBean = CacheBean(Option < MultiPixelMap >.None, tempPixelMap)
/* 8.359 */
/* 8.360 */                    memoryLruCache.put(mKey, cacheBean)
/* 8.361 */                fileLruCache.put(mKey, color.size + 4, color, Int64(imageWidth), Int64(imageHeight)) }
/* 8.362 */                value.issuccess = true
/* 8.363 */                value.color = color
/* 8.364 */            }
/* 8.365 */            else {
/* 8.366 */                value.issuccess = false
/* 8.367 */            }
/* 8.368 */            return value
/* 8.369 */        }
/* 8.370 */        else {
/* 8.371 */            value.issuccess = false
/* 8.372 */            return value
/* 8.373 */        }
/* 8.374 */    }
/* 8.375 */
/* 8.376 */    public func decodeffi(imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 8.377 */        let value: CJReturnValue = CJReturnValue()
/* 8.378 */        if(imageWidth <= 0 || imageHeight <= 0) {
/* 8.379 */            value.issuccess = false
/* 8.380 */            return value
/* 8.381 */        }
/* 8.382 */        let count: Int64 = getFrameCount()
/* 8.383 */        if(count <= 0) {
/* 8.384 */            value.issuccess = false
/* 8.385 */            return value
/* 8.386 */        }
/* 8.387 */        if(encoded.isNone()) {
/* 8.388 */            value.issuccess = false
/* 8.389 */            return value
/* 8.390 */        }
/* 8.391 */        if(count == 1) {
/* 8.392 */            mKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
/* 8.393 */        }
/* 8.394 */        else {
/* 8.395 */            mKey = getmd5keyWithIndex(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight), 0)
/* 8.396 */        }
/* 8.397 */        let memPixelMap:?CacheBean = memoryLruCache.get(mKey)
/* 8.398 */        if(let Some(cache) <- memPixelMap) {
/* 8.399 */            let pixelMap = cache.getPixelMap()
/* 8.400 */            if(let Some(i) <- pixelMap) {
/* 8.401 */                let readBuffer: Array < Byte >= Array < Byte >(Int64(imageWidth * imageHeight * 4), repeat: 0)
/* 8.402 */                i.readPixelsToBuffer(readBuffer)
/* 8.403 */                value.color = convertBGRAtoRGBA(readBuffer)
/* 8.404 */                value.issuccess = true
/* 8.405 */                return value
/* 8.406 */            }
/* 8.407 */        }
/* 8.408 */        let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mKey)
/* 8.409 */        if(fileExist) {
/* 8.410 */            let source:?Array < UInt8 >= fileLruCache.get(mKey)
/* 8.411 */            if(let Some(i) <- source) {
/* 8.412 */                let colors = i[4 .. i.size]
/* 8.413 */                spawn { let finalWidth: Int32 = Int32(UInt16(i[0]) << 8 | UInt16(i[1]))
/* 8.414 */
/* 8.415 */                    let finalHeight: Int32 = Int32(UInt16(i[2]) << 8 | UInt16(i[3]))
/* 8.416 */
/* 8.417 */                    let size2: Size = Size(width: Int32(finalWidth), height: Int32(finalHeight))
/* 8.418 */
/* 8.419 */                    let opts: InitializationOptions = InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
/* 8.420 */
/* 8.421 */                    let tempPixelMap = createPixelMap(colors, opts)
/* 8.422 */
/* 8.423 */                    let cacheBean: CacheBean = CacheBean(Option < MultiPixelMap >.None, tempPixelMap)
/* 8.424 */
/* 8.425 */                memoryLruCache.put(mKey, cacheBean) }
/* 8.426 */                value.color = colors
/* 8.427 */                value.issuccess = true
/* 8.428 */                return value
/* 8.429 */            }
/* 8.430 */        }
/* 8.431 */        let color: Array < Byte >= Array < Byte >(Int64(imageWidth * imageHeight * 4), repeat: 0)
/* 8.432 */        if(let Some(i) <- decoder) {
/* 8.433 */            value.issuccess = i.decodeffi(encoded.getOrThrow(), color, imageWidth, imageHeight)
/* 8.434 */            if(value.issuccess) {
/* 8.435 */                spawn { let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
/* 8.436 */
/* 8.437 */                    let opts: InitializationOptions = InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
/* 8.438 */
/* 8.439 */                    let tempPixelMap = createPixelMap(color, opts)
/* 8.440 */
/* 8.441 */                    let cacheBean: CacheBean = CacheBean(Option < MultiPixelMap >.None, tempPixelMap)
/* 8.442 */
/* 8.443 */                    memoryLruCache.put(mKey, cacheBean)
/* 8.444 */                fileLruCache.put(mKey, color.size + 4, color, Int64(imageWidth), Int64(imageHeight)) }
/* 8.445 */                value.color = color
/* 8.446 */            }
/* 8.447 */            else {
/* 8.448 */                value.issuccess = false
/* 8.449 */            }
/* 8.450 */            return value
/* 8.451 */        }
/* 8.452 */        else {
/* 8.453 */            value.issuccess = false
/* 8.454 */            return value
/* 8.455 */        }
/* 8.456 */    }
/* 8.457 */
/* 8.458 */    public func release(): Unit {
/* 8.459 */        if(let Some(i) <- decoder) {
/* 8.460 */            return i.release()
/* 8.461 */        }
/* 8.462 */    }
/* 8.463 */
/* 8.464 */
/* 8.465 */
/* 8.466 */    public static func create_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.467 */
/* 8.468 */        let thisArg = callInfo.thisArg
/* 8.469 */        let thisObject = thisArg.asObject(context)
/* 8.470 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.471 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.472 */
/* 8.473 */        let arg1772765505569856200 = String.fromJSValue(context, callInfo[0])
/* 8.474 */
/* 8.475 */        JSCurrentJSContext.set(context)
/* 8.476 */        let RET = clazz.create(arg1772765505569856200)
/* 8.477 */        JSCurrentJSContext.unset()
/* 8.478 */        RET.toJSValue(context)
/* 8.479 */    }
/* 8.480 */
/* 8.481 */    public static func createWithThread_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.482 */
/* 8.483 */        let thisArg = callInfo.thisArg
/* 8.484 */        let thisObject = thisArg.asObject(context)
/* 8.485 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.486 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.487 */
/* 8.488 */        let arg1772765505570482400 = String.fromJSValue(context, callInfo[0])
/* 8.489 */        let arg1772765505570508300 = Int32.fromJSValue(context, callInfo[1])
/* 8.490 */
/* 8.491 */        JSCurrentJSContext.set(context)
/* 8.492 */        let RET = clazz.createWithThread(arg1772765505570482400, arg1772765505570508300)
/* 8.493 */        JSCurrentJSContext.unset()
/* 8.494 */        RET.toJSValue(context)
/* 8.495 */    }
/* 8.496 */
/* 8.497 */    public static func getWidth_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.498 */
/* 8.499 */        let thisArg = callInfo.thisArg
/* 8.500 */        let thisObject = thisArg.asObject(context)
/* 8.501 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.502 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.503 */
/* 8.504 */
/* 8.505 */        JSCurrentJSContext.set(context)
/* 8.506 */        let RET = clazz.getWidth()
/* 8.507 */        JSCurrentJSContext.unset()
/* 8.508 */        RET.toJSValue(context)
/* 8.509 */    }
/* 8.510 */
/* 8.511 */    public static func getHeight_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.512 */
/* 8.513 */        let thisArg = callInfo.thisArg
/* 8.514 */        let thisObject = thisArg.asObject(context)
/* 8.515 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.516 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.517 */
/* 8.518 */
/* 8.519 */        JSCurrentJSContext.set(context)
/* 8.520 */        let RET = clazz.getHeight()
/* 8.521 */        JSCurrentJSContext.unset()
/* 8.522 */        RET.toJSValue(context)
/* 8.523 */    }
/* 8.524 */
/* 8.525 */    public static func getDepth_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.526 */
/* 8.527 */        let thisArg = callInfo.thisArg
/* 8.528 */        let thisObject = thisArg.asObject(context)
/* 8.529 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.530 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.531 */
/* 8.532 */
/* 8.533 */        JSCurrentJSContext.set(context)
/* 8.534 */        let RET = clazz.getDepth()
/* 8.535 */        JSCurrentJSContext.unset()
/* 8.536 */        RET.toJSValue(context)
/* 8.537 */    }
/* 8.538 */
/* 8.539 */    public static func getAlphaPresent_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.540 */
/* 8.541 */        let thisArg = callInfo.thisArg
/* 8.542 */        let thisObject = thisArg.asObject(context)
/* 8.543 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.544 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.545 */
/* 8.546 */
/* 8.547 */        JSCurrentJSContext.set(context)
/* 8.548 */        let RET = clazz.getAlphaPresent()
/* 8.549 */        JSCurrentJSContext.unset()
/* 8.550 */        RET.toJSValue(context)
/* 8.551 */    }
/* 8.552 */
/* 8.553 */    public static func getFrameCount_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.554 */
/* 8.555 */        let thisArg = callInfo.thisArg
/* 8.556 */        let thisObject = thisArg.asObject(context)
/* 8.557 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.558 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.559 */
/* 8.560 */
/* 8.561 */        JSCurrentJSContext.set(context)
/* 8.562 */        let RET = clazz.getFrameCount()
/* 8.563 */        JSCurrentJSContext.unset()
/* 8.564 */        RET.toJSValue(context)
/* 8.565 */    }
/* 8.566 */
/* 8.567 */    public static func getRepetitionCount_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.568 */
/* 8.569 */        let thisArg = callInfo.thisArg
/* 8.570 */        let thisObject = thisArg.asObject(context)
/* 8.571 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.572 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.573 */
/* 8.574 */
/* 8.575 */        JSCurrentJSContext.set(context)
/* 8.576 */        let RET = clazz.getRepetitionCount()
/* 8.577 */        JSCurrentJSContext.unset()
/* 8.578 */        RET.toJSValue(context)
/* 8.579 */    }
/* 8.580 */
/* 8.581 */    public static func getFrameDurations_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.582 */
/* 8.583 */        let thisArg = callInfo.thisArg
/* 8.584 */        let thisObject = thisArg.asObject(context)
/* 8.585 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.586 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.587 */
/* 8.588 */
/* 8.589 */        JSCurrentJSContext.set(context)
/* 8.590 */        let RET = clazz.getFrameDurations()
/* 8.591 */        JSCurrentJSContext.unset()
/* 8.592 */        RET.toJSValue(context)
/* 8.593 */    }
/* 8.594 */
/* 8.595 */    public static func isAvifImageffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.596 */
/* 8.597 */        let thisArg = callInfo.thisArg
/* 8.598 */        let thisObject = thisArg.asObject(context)
/* 8.599 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.600 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.601 */
/* 8.602 */
/* 8.603 */        JSCurrentJSContext.set(context)
/* 8.604 */        let RET = clazz.isAvifImageffi()
/* 8.605 */        JSCurrentJSContext.unset()
/* 8.606 */        RET.toJSValue(context)
/* 8.607 */    }
/* 8.608 */
/* 8.609 */    public static func nextFrameIndexffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.610 */
/* 8.611 */        let thisArg = callInfo.thisArg
/* 8.612 */        let thisObject = thisArg.asObject(context)
/* 8.613 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.614 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.615 */
/* 8.616 */
/* 8.617 */        JSCurrentJSContext.set(context)
/* 8.618 */        let RET = clazz.nextFrameIndexffi()
/* 8.619 */        JSCurrentJSContext.unset()
/* 8.620 */        RET.toJSValue(context)
/* 8.621 */    }
/* 8.622 */
/* 8.623 */    public static func nextFrameffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.624 */
/* 8.625 */        let thisArg = callInfo.thisArg
/* 8.626 */        let thisObject = thisArg.asObject(context)
/* 8.627 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.628 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.629 */
/* 8.630 */        let arg1772765505573220300 = Int32.fromJSValue(context, callInfo[0])
/* 8.631 */        let arg1772765505573248100 = Int32.fromJSValue(context, callInfo[1])
/* 8.632 */
/* 8.633 */        JSCurrentJSContext.set(context)
/* 8.634 */        let RET = clazz.nextFrameffi(arg1772765505573220300, arg1772765505573248100)
/* 8.635 */        JSCurrentJSContext.unset()
/* 8.636 */        RET.toJSValue(context)
/* 8.637 */    }
/* 8.638 */
/* 8.639 */    public static func nthFrameffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.640 */
/* 8.641 */        let thisArg = callInfo.thisArg
/* 8.642 */        let thisObject = thisArg.asObject(context)
/* 8.643 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.644 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.645 */
/* 8.646 */        let arg1772765505574178100 = Int32.fromJSValue(context, callInfo[0])
/* 8.647 */        let arg1772765505574201300 = Int32.fromJSValue(context, callInfo[1])
/* 8.648 */        let arg1772765505574270300 = Int32.fromJSValue(context, callInfo[2])
/* 8.649 */
/* 8.650 */        JSCurrentJSContext.set(context)
/* 8.651 */        let RET = clazz.nthFrameffi(arg1772765505574178100, arg1772765505574201300, arg1772765505574270300)
/* 8.652 */        JSCurrentJSContext.unset()
/* 8.653 */        RET.toJSValue(context)
/* 8.654 */    }
/* 8.655 */
/* 8.656 */    public static func decodeffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.657 */
/* 8.658 */        let thisArg = callInfo.thisArg
/* 8.659 */        let thisObject = thisArg.asObject(context)
/* 8.660 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.661 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.662 */
/* 8.663 */        let arg1772765505575249600 = Int32.fromJSValue(context, callInfo[0])
/* 8.664 */        let arg1772765505575287700 = Int32.fromJSValue(context, callInfo[1])
/* 8.665 */
/* 8.666 */        JSCurrentJSContext.set(context)
/* 8.667 */        let RET = clazz.decodeffi(arg1772765505575249600, arg1772765505575287700)
/* 8.668 */        JSCurrentJSContext.unset()
/* 8.669 */        RET.toJSValue(context)
/* 8.670 */    }
/* 8.671 */
/* 8.672 */    public static func release_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.673 */
/* 8.674 */        let thisArg = callInfo.thisArg
/* 8.675 */        let thisObject = thisArg.asObject(context)
/* 8.676 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.677 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.678 */
/* 8.679 */
/* 8.680 */        JSCurrentJSContext.set(context)
/* 8.681 */        let RET = clazz.release()
/* 8.682 */        JSCurrentJSContext.unset()
/* 8.683 */        RET.toJSValue(context)
/* 8.684 */    }
/* 8.685 */
/* 8.686 */
/* 8.687 */
/* 8.688 */
/* 8.689 */
/* 8.690 */
/* 8.691 */
/* 8.692 */
/* 8.693 */    public func toJSValue(context: JSContext): JSValue {
/* 8.694 */        let ext = context.external(this)
/* 8.695 */        let obj = context.object()
/* 8.696 */
/* 8.697 */
/* 8.698 */
/* 8.699 */        obj["create"] =
/* 8.700 */        context.function(create_ArkTS_Interop_Identifier).toJSValue()
/* 8.701 */
/* 8.702 */        obj["createWithThread"] =
/* 8.703 */        context.function(createWithThread_ArkTS_Interop_Identifier).toJSValue()
/* 8.704 */
/* 8.705 */        obj["getWidth"] =
/* 8.706 */        context.function(getWidth_ArkTS_Interop_Identifier).toJSValue()
/* 8.707 */
/* 8.708 */        obj["getHeight"] =
/* 8.709 */        context.function(getHeight_ArkTS_Interop_Identifier).toJSValue()
/* 8.710 */
/* 8.711 */        obj["getDepth"] =
/* 8.712 */        context.function(getDepth_ArkTS_Interop_Identifier).toJSValue()
/* 8.713 */
/* 8.714 */        obj["getAlphaPresent"] =
/* 8.715 */        context.function(getAlphaPresent_ArkTS_Interop_Identifier).toJSValue()
/* 8.716 */
/* 8.717 */        obj["getFrameCount"] =
/* 8.718 */        context.function(getFrameCount_ArkTS_Interop_Identifier).toJSValue()
/* 8.719 */
/* 8.720 */        obj["getRepetitionCount"] =
/* 8.721 */        context.function(getRepetitionCount_ArkTS_Interop_Identifier).toJSValue()
/* 8.722 */
/* 8.723 */        obj["getFrameDurations"] =
/* 8.724 */        context.function(getFrameDurations_ArkTS_Interop_Identifier).toJSValue()
/* 8.725 */
/* 8.726 */        obj["isAvifImageffi"] =
/* 8.727 */        context.function(isAvifImageffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.728 */
/* 8.729 */        obj["nextFrameIndexffi"] =
/* 8.730 */        context.function(nextFrameIndexffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.731 */
/* 8.732 */        obj["nextFrameffi"] =
/* 8.733 */        context.function(nextFrameffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.734 */
/* 8.735 */        obj["nthFrameffi"] =
/* 8.736 */        context.function(nthFrameffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.737 */
/* 8.738 */        obj["decodeffi"] =
/* 8.739 */        context.function(decodeffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.740 */
/* 8.741 */        obj["release"] =
/* 8.742 */        context.function(release_ArkTS_Interop_Identifier).toJSValue()
/* 8.743 */
/* 8.744 */        obj.attachCJObject(ext)
/* 8.745 */        obj.toJSValue()
/* 8.746 */    }
/* 8.747 */
/* 8.748 */
/* 8.749 */    public static func fromJSValue(context: JSContext, input: JSValue) {
/* 8.750 */        let jsObj = input.asObject(context)
/* 8.751 */        let jsExt = jsObj.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.752 */        let obj = jsExt.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.753 */        return obj
/* 8.754 */    }
/* 8.755 */    public static func toArkTsType(): String {
/* 8.756 */        "class"
/* 8.757 */    }
/* 8.758 */
/* 8.759 */    private var decoder: Option < AvifDecoder >= None
/* 8.760 */    var mKey = ""
/* 8.761 */    var mUri = ""
/* 8.762 */    var encoded:?Array < Byte >= None
/* 8.763 */    private func createLoginc(buffer: Array < UInt8 >, threads: Int32): Option < CJAvifDecoder > {
/* 8.764 */        encoded = buffer
/* 8.765 */        decoder = AvifDecoder(buffer, threads)
/* 8.766 */        if(let Some(k) <- decoder) {
/* 8.767 */            if(k.decoder == 0) {
/* 8.768 */                return Option < CJAvifDecoder >.None
/* 8.769 */            }
/* 8.770 */            return this
/* 8.771 */        }
/* 8.772 */        else {
/* 8.773 */            return Option < CJAvifDecoder >.None
/* 8.774 */        }
/* 8.775 */    }
/* 8.776 */
/* 8.777 */}
/* 8.778 */
/* ===== End of the Emit ===== */