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
/* 8.80 */    public func create(encoded: Array < Byte >): Option < CJAvifDecoder > {
/* 8.81 */        return createWithThread(encoded, 1)
/* 8.82 */    }
/* 8.83 */
/* 8.84 */    public func createWithThread(encoded: Array < Byte >, threads: Int32): Option < CJAvifDecoder > {
/* 8.85 */        decoder = AvifDecoder(encoded, threads)
/* 8.86 */        if(let Some(i) <- decoder) {
/* 8.87 */            if(i.decoder == 0) {
/* 8.88 */                return None
/* 8.89 */            }
/* 8.90 */            return this
/* 8.91 */        }
/* 8.92 */        else {
/* 8.93 */            return None
/* 8.94 */        }
/* 8.95 */    }
/* 8.96 */
/* 8.97 */    public func getWidth(): Int64 {
/* 8.98 */        if(let Some(i) <- decoder) {
/* 8.99 */            return i.getWidth()
/* 8.100 */        }
/* 8.101 */        return 0
/* 8.102 */    }
/* 8.103 */
/* 8.104 */    public func getHeight(): Int64 {
/* 8.105 */        if(let Some(i) <- decoder) {
/* 8.106 */            return i.getHeight()
/* 8.107 */        }
/* 8.108 */        return 0
/* 8.109 */    }
/* 8.110 */
/* 8.111 */    public func getDepth(): Int64 {
/* 8.112 */        if(let Some(i) <- decoder) {
/* 8.113 */            return i.getDepth()
/* 8.114 */        }
/* 8.115 */        return 0
/* 8.116 */    }
/* 8.117 */
/* 8.118 */    public func getAlphaPresent(): Bool {
/* 8.119 */        if(let Some(i) <- decoder) {
/* 8.120 */            return i.getAlphaPresent()
/* 8.121 */        }
/* 8.122 */        return false
/* 8.123 */    }
/* 8.124 */
/* 8.125 */    public func getFrameCount(): Int64 {
/* 8.126 */        if(let Some(i) <- decoder) {
/* 8.127 */            return i.getFrameCount()
/* 8.128 */        }
/* 8.129 */        return 0
/* 8.130 */    }
/* 8.131 */
/* 8.132 */    public func getRepetitionCount(): Int64 {
/* 8.133 */        if(let Some(i) <- decoder) {
/* 8.134 */            return i.getRepetitionCount()
/* 8.135 */        }
/* 8.136 */        return 0
/* 8.137 */    }
/* 8.138 */
/* 8.139 */    public func getFrameDurations(): Option < JSArrayEx < Float64 >> {
/* 8.140 */        if(let Some(i) <- decoder) {
/* 8.141 */            if(let Some(j) <- i.getFrameDurations()) {
/* 8.142 */                return JSArrayEx(j)
/* 8.143 */            }
/* 8.144 */            else {
/* 8.145 */                return None
/* 8.146 */            }
/* 8.147 */        }
/* 8.148 */        return None
/* 8.149 */    }
/* 8.150 */
/* 8.151 */    public func isAvifImageffi(encoded: Array < Byte >): Int32 {
/* 8.152 */        if(let Some(i) <- decoder) {
/* 8.153 */            return i.isAvifImageffi(encoded)
/* 8.154 */        }
/* 8.155 */        return 0
/* 8.156 */    }
/* 8.157 */
/* 8.158 */    public func nextFrameIndexffi(): Int32 {
/* 8.159 */        if(let Some(i) <- decoder) {
/* 8.160 */            return i.nextFrameIndexffi()
/* 8.161 */        }
/* 8.162 */        return 0
/* 8.163 */    }
/* 8.164 */
/* 8.165 */    public func nextFrameffi(imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 8.166 */        let color: Array < Byte >= Array < Byte >(Int64(imageWidth * imageHeight * 4), repeat: 0)
/* 8.167 */        let value: CJReturnValue = CJReturnValue()
/* 8.168 */        if(let Some(i) <- decoder) {
/* 8.169 */            value.code = i.nextFrameffi(color, imageWidth, imageHeight)
/* 8.170 */            value.color = color
/* 8.171 */            return value
/* 8.172 */        }
/* 8.173 */        value.code = - 1
/* 8.174 */        return value
/* 8.175 */    }
/* 8.176 */
/* 8.177 */    public func nthFrameffi(index: Int32, imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 8.178 */        let color: Array < Byte >= Array < Byte >(Int64(imageWidth * imageHeight * 4), repeat: 0)
/* 8.179 */        let value: CJReturnValue = CJReturnValue()
/* 8.180 */        if(let Some(i) <- decoder) {
/* 8.181 */            value.code = i.nthFrameffi(index, color, imageWidth, imageHeight)
/* 8.182 */            value.color = color
/* 8.183 */            return value
/* 8.184 */        }
/* 8.185 */        value.code = - 1
/* 8.186 */        return value
/* 8.187 */    }
/* 8.188 */
/* 8.189 */    public func decodeffi(encoded: Array < Byte >, imageWidth: Int32, imageHeight: Int32): CJReturnValue {
/* 8.190 */        let color: Array < Byte >= Array < Byte >(Int64(imageWidth * imageHeight * 4), repeat: 0)
/* 8.191 */        let value: CJReturnValue = CJReturnValue()
/* 8.192 */        if(let Some(i) <- decoder) {
/* 8.193 */            value.issuccess = i.decodeffi(encoded, color, imageWidth, imageHeight)
/* 8.194 */            value.color = color
/* 8.195 */            return value
/* 8.196 */        }
/* 8.197 */        value.issuccess = false
/* 8.198 */        return value
/* 8.199 */    }
/* 8.200 */
/* 8.201 */    public func release(): Unit {
/* 8.202 */        if(let Some(i) <- decoder) {
/* 8.203 */            return i.release()
/* 8.204 */        }
/* 8.205 */    }
/* 8.206 */
/* 8.207 */
/* 8.208 */
/* 8.209 */    public static func create_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.210 */
/* 8.211 */        let thisArg = callInfo.thisArg
/* 8.212 */        let thisObject = thisArg.asObject(context)
/* 8.213 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.214 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.215 */
/* 8.216 */        let arg1772418864131209300 = Array < Byte >.fromJSValue(context, callInfo[0])
/* 8.217 */
/* 8.218 */        JSCurrentJSContext.set(context)
/* 8.219 */        let RET = clazz.create(arg1772418864131209300)
/* 8.220 */        JSCurrentJSContext.unset()
/* 8.221 */        RET.toJSValue(context)
/* 8.222 */    }
/* 8.223 */
/* 8.224 */    public static func createWithThread_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.225 */
/* 8.226 */        let thisArg = callInfo.thisArg
/* 8.227 */        let thisObject = thisArg.asObject(context)
/* 8.228 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.229 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.230 */
/* 8.231 */        let arg1772418864131468100 = Array < Byte >.fromJSValue(context, callInfo[0])
/* 8.232 */        let arg1772418864131492800 = Int32.fromJSValue(context, callInfo[1])
/* 8.233 */
/* 8.234 */        JSCurrentJSContext.set(context)
/* 8.235 */        let RET = clazz.createWithThread(arg1772418864131468100, arg1772418864131492800)
/* 8.236 */        JSCurrentJSContext.unset()
/* 8.237 */        RET.toJSValue(context)
/* 8.238 */    }
/* 8.239 */
/* 8.240 */    public static func getWidth_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.241 */
/* 8.242 */        let thisArg = callInfo.thisArg
/* 8.243 */        let thisObject = thisArg.asObject(context)
/* 8.244 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.245 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.246 */
/* 8.247 */
/* 8.248 */        JSCurrentJSContext.set(context)
/* 8.249 */        let RET = clazz.getWidth()
/* 8.250 */        JSCurrentJSContext.unset()
/* 8.251 */        RET.toJSValue(context)
/* 8.252 */    }
/* 8.253 */
/* 8.254 */    public static func getHeight_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.255 */
/* 8.256 */        let thisArg = callInfo.thisArg
/* 8.257 */        let thisObject = thisArg.asObject(context)
/* 8.258 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.259 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.260 */
/* 8.261 */
/* 8.262 */        JSCurrentJSContext.set(context)
/* 8.263 */        let RET = clazz.getHeight()
/* 8.264 */        JSCurrentJSContext.unset()
/* 8.265 */        RET.toJSValue(context)
/* 8.266 */    }
/* 8.267 */
/* 8.268 */    public static func getDepth_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.269 */
/* 8.270 */        let thisArg = callInfo.thisArg
/* 8.271 */        let thisObject = thisArg.asObject(context)
/* 8.272 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.273 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.274 */
/* 8.275 */
/* 8.276 */        JSCurrentJSContext.set(context)
/* 8.277 */        let RET = clazz.getDepth()
/* 8.278 */        JSCurrentJSContext.unset()
/* 8.279 */        RET.toJSValue(context)
/* 8.280 */    }
/* 8.281 */
/* 8.282 */    public static func getAlphaPresent_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.283 */
/* 8.284 */        let thisArg = callInfo.thisArg
/* 8.285 */        let thisObject = thisArg.asObject(context)
/* 8.286 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.287 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.288 */
/* 8.289 */
/* 8.290 */        JSCurrentJSContext.set(context)
/* 8.291 */        let RET = clazz.getAlphaPresent()
/* 8.292 */        JSCurrentJSContext.unset()
/* 8.293 */        RET.toJSValue(context)
/* 8.294 */    }
/* 8.295 */
/* 8.296 */    public static func getFrameCount_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.297 */
/* 8.298 */        let thisArg = callInfo.thisArg
/* 8.299 */        let thisObject = thisArg.asObject(context)
/* 8.300 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.301 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.302 */
/* 8.303 */
/* 8.304 */        JSCurrentJSContext.set(context)
/* 8.305 */        let RET = clazz.getFrameCount()
/* 8.306 */        JSCurrentJSContext.unset()
/* 8.307 */        RET.toJSValue(context)
/* 8.308 */    }
/* 8.309 */
/* 8.310 */    public static func getRepetitionCount_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.311 */
/* 8.312 */        let thisArg = callInfo.thisArg
/* 8.313 */        let thisObject = thisArg.asObject(context)
/* 8.314 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.315 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.316 */
/* 8.317 */
/* 8.318 */        JSCurrentJSContext.set(context)
/* 8.319 */        let RET = clazz.getRepetitionCount()
/* 8.320 */        JSCurrentJSContext.unset()
/* 8.321 */        RET.toJSValue(context)
/* 8.322 */    }
/* 8.323 */
/* 8.324 */    public static func getFrameDurations_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.325 */
/* 8.326 */        let thisArg = callInfo.thisArg
/* 8.327 */        let thisObject = thisArg.asObject(context)
/* 8.328 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.329 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.330 */
/* 8.331 */
/* 8.332 */        JSCurrentJSContext.set(context)
/* 8.333 */        let RET = clazz.getFrameDurations()
/* 8.334 */        JSCurrentJSContext.unset()
/* 8.335 */        RET.toJSValue(context)
/* 8.336 */    }
/* 8.337 */
/* 8.338 */    public static func isAvifImageffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.339 */
/* 8.340 */        let thisArg = callInfo.thisArg
/* 8.341 */        let thisObject = thisArg.asObject(context)
/* 8.342 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.343 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.344 */
/* 8.345 */        let arg1772418864132964900 = Array < Byte >.fromJSValue(context, callInfo[0])
/* 8.346 */
/* 8.347 */        JSCurrentJSContext.set(context)
/* 8.348 */        let RET = clazz.isAvifImageffi(arg1772418864132964900)
/* 8.349 */        JSCurrentJSContext.unset()
/* 8.350 */        RET.toJSValue(context)
/* 8.351 */    }
/* 8.352 */
/* 8.353 */    public static func nextFrameIndexffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.354 */
/* 8.355 */        let thisArg = callInfo.thisArg
/* 8.356 */        let thisObject = thisArg.asObject(context)
/* 8.357 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.358 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.359 */
/* 8.360 */
/* 8.361 */        JSCurrentJSContext.set(context)
/* 8.362 */        let RET = clazz.nextFrameIndexffi()
/* 8.363 */        JSCurrentJSContext.unset()
/* 8.364 */        RET.toJSValue(context)
/* 8.365 */    }
/* 8.366 */
/* 8.367 */    public static func nextFrameffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.368 */
/* 8.369 */        let thisArg = callInfo.thisArg
/* 8.370 */        let thisObject = thisArg.asObject(context)
/* 8.371 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.372 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.373 */
/* 8.374 */        let arg1772418864133410500 = Int32.fromJSValue(context, callInfo[0])
/* 8.375 */        let arg1772418864133435700 = Int32.fromJSValue(context, callInfo[1])
/* 8.376 */
/* 8.377 */        JSCurrentJSContext.set(context)
/* 8.378 */        let RET = clazz.nextFrameffi(arg1772418864133410500, arg1772418864133435700)
/* 8.379 */        JSCurrentJSContext.unset()
/* 8.380 */        RET.toJSValue(context)
/* 8.381 */    }
/* 8.382 */
/* 8.383 */    public static func nthFrameffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.384 */
/* 8.385 */        let thisArg = callInfo.thisArg
/* 8.386 */        let thisObject = thisArg.asObject(context)
/* 8.387 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.388 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.389 */
/* 8.390 */        let arg1772418864133678200 = Int32.fromJSValue(context, callInfo[0])
/* 8.391 */        let arg1772418864133701600 = Int32.fromJSValue(context, callInfo[1])
/* 8.392 */        let arg1772418864133724400 = Int32.fromJSValue(context, callInfo[2])
/* 8.393 */
/* 8.394 */        JSCurrentJSContext.set(context)
/* 8.395 */        let RET = clazz.nthFrameffi(arg1772418864133678200, arg1772418864133701600, arg1772418864133724400)
/* 8.396 */        JSCurrentJSContext.unset()
/* 8.397 */        RET.toJSValue(context)
/* 8.398 */    }
/* 8.399 */
/* 8.400 */    public static func decodeffi_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.401 */
/* 8.402 */        let thisArg = callInfo.thisArg
/* 8.403 */        let thisObject = thisArg.asObject(context)
/* 8.404 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.405 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.406 */
/* 8.407 */        let arg1772418864133980900 = Array < Byte >.fromJSValue(context, callInfo[0])
/* 8.408 */        let arg1772418864134007100 = Int32.fromJSValue(context, callInfo[1])
/* 8.409 */        let arg1772418864134031700 = Int32.fromJSValue(context, callInfo[2])
/* 8.410 */
/* 8.411 */        JSCurrentJSContext.set(context)
/* 8.412 */        let RET = clazz.decodeffi(arg1772418864133980900, arg1772418864134007100, arg1772418864134031700)
/* 8.413 */        JSCurrentJSContext.unset()
/* 8.414 */        RET.toJSValue(context)
/* 8.415 */    }
/* 8.416 */
/* 8.417 */    public static func release_ArkTS_Interop_Identifier(context: JSContext, callInfo: JSCallInfo): JSValue {
/* 8.418 */
/* 8.419 */        let thisArg = callInfo.thisArg
/* 8.420 */        let thisObject = thisArg.asObject(context)
/* 8.421 */        let jsExternal = thisObject.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.422 */        let clazz = jsExternal.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.423 */
/* 8.424 */
/* 8.425 */        JSCurrentJSContext.set(context)
/* 8.426 */        let RET = clazz.release()
/* 8.427 */        JSCurrentJSContext.unset()
/* 8.428 */        RET.toJSValue(context)
/* 8.429 */    }
/* 8.430 */
/* 8.431 */
/* 8.432 */
/* 8.433 */
/* 8.434 */
/* 8.435 */
/* 8.436 */
/* 8.437 */
/* 8.438 */    public func toJSValue(context: JSContext): JSValue {
/* 8.439 */        let ext = context.external(this)
/* 8.440 */        let obj = context.object()
/* 8.441 */
/* 8.442 */
/* 8.443 */
/* 8.444 */        obj["create"] =
/* 8.445 */        context.function(create_ArkTS_Interop_Identifier).toJSValue()
/* 8.446 */
/* 8.447 */        obj["createWithThread"] =
/* 8.448 */        context.function(createWithThread_ArkTS_Interop_Identifier).toJSValue()
/* 8.449 */
/* 8.450 */        obj["getWidth"] =
/* 8.451 */        context.function(getWidth_ArkTS_Interop_Identifier).toJSValue()
/* 8.452 */
/* 8.453 */        obj["getHeight"] =
/* 8.454 */        context.function(getHeight_ArkTS_Interop_Identifier).toJSValue()
/* 8.455 */
/* 8.456 */        obj["getDepth"] =
/* 8.457 */        context.function(getDepth_ArkTS_Interop_Identifier).toJSValue()
/* 8.458 */
/* 8.459 */        obj["getAlphaPresent"] =
/* 8.460 */        context.function(getAlphaPresent_ArkTS_Interop_Identifier).toJSValue()
/* 8.461 */
/* 8.462 */        obj["getFrameCount"] =
/* 8.463 */        context.function(getFrameCount_ArkTS_Interop_Identifier).toJSValue()
/* 8.464 */
/* 8.465 */        obj["getRepetitionCount"] =
/* 8.466 */        context.function(getRepetitionCount_ArkTS_Interop_Identifier).toJSValue()
/* 8.467 */
/* 8.468 */        obj["getFrameDurations"] =
/* 8.469 */        context.function(getFrameDurations_ArkTS_Interop_Identifier).toJSValue()
/* 8.470 */
/* 8.471 */        obj["isAvifImageffi"] =
/* 8.472 */        context.function(isAvifImageffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.473 */
/* 8.474 */        obj["nextFrameIndexffi"] =
/* 8.475 */        context.function(nextFrameIndexffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.476 */
/* 8.477 */        obj["nextFrameffi"] =
/* 8.478 */        context.function(nextFrameffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.479 */
/* 8.480 */        obj["nthFrameffi"] =
/* 8.481 */        context.function(nthFrameffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.482 */
/* 8.483 */        obj["decodeffi"] =
/* 8.484 */        context.function(decodeffi_ArkTS_Interop_Identifier).toJSValue()
/* 8.485 */
/* 8.486 */        obj["release"] =
/* 8.487 */        context.function(release_ArkTS_Interop_Identifier).toJSValue()
/* 8.488 */
/* 8.489 */        obj.attachCJObject(ext)
/* 8.490 */        obj.toJSValue()
/* 8.491 */    }
/* 8.492 */
/* 8.493 */
/* 8.494 */    public static func fromJSValue(context: JSContext, input: JSValue) {
/* 8.495 */        let jsObj = input.asObject(context)
/* 8.496 */        let jsExt = jsObj.getAttachInfo()??throw Exception("class: get external failed.")
/* 8.497 */        let obj = jsExt.cast < CJAvifDecoder >()??throw Exception("class: get clazz failed.")
/* 8.498 */        return obj
/* 8.499 */    }
/* 8.500 */    public static func toArkTsType(): String {
/* 8.501 */        "class"
/* 8.502 */    }
/* 8.503 */
/* 8.504 */    private var decoder: Option < AvifDecoder >= None
/* 8.505 */
/* 8.506 */}
/* 8.507 */
/* ===== End of the Emit ===== */