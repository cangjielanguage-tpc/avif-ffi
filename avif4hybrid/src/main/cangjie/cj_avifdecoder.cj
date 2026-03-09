/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package ohos_app_cangjie_avif4hybrid

import ohos.ark_interop_macro.Interop

@Interop[ArkTS]
 public class CJAvifDecoder {
     public init() {
     }


     private var decoder: Option<AvifDecoder> = None


     public func create(encoded: Array<Byte>): Option<CJAvifDecoder> {
         return createWithThread(encoded, 1)
     }


     public func createWithThread(encoded: Array<Byte>, threads: Int32): Option<CJAvifDecoder> {
         decoder = AvifDecoder(encoded, threads)
         if(let Some(i) <- decoder){
             if (i.decoder == 0) {
                 return None
             }
             return this
         }else{
             return None
         }
     }


     public func getWidth(): Int64 {
         if (let Some(i) <- decoder) {
             return i.getWidth()
         }
         return 0
     }


     public func getHeight(): Int64 {
         if (let Some(i) <- decoder) {
             return i.getHeight()
         }
         return 0
     }


     public func getDepth(): Int64 {
         if (let Some(i) <- decoder) {
             return i.getDepth()
         }
         return 0
     }


     public func getAlphaPresent(): Bool {
         if (let Some(i) <- decoder) {
             return i.getAlphaPresent()
         }
         return false
     }


     public func getFrameCount(): Int64 {
         if (let Some(i) <- decoder) {
             return i.getFrameCount()
         }
         return 0
     }


     public func getRepetitionCount(): Int64 {
         if (let Some(i) <- decoder) {
             return i.getRepetitionCount()
         }
         return 0
     }


     public func getFrameDurations(): Option<JSArrayEx<Float64>> {
         if (let Some(i) <- decoder) {
             if(let Some(j) <- i.getFrameDurations()){
                 return JSArrayEx(j)
             }else{
                 return None
             }
         }
         return None
     }


     public func isAvifImageffi(encoded: Array<Byte>): Int32 {
         if (let Some(i) <- decoder) {
             return i.isAvifImageffi(encoded)
         }
         return 0
     }


     public func nextFrameIndexffi(): Int32 {
         if (let Some(i) <- decoder) {
             return i.nextFrameIndexffi()
         }
         return 0
     }


     public func nextFrameffi(imageWidth: Int32, imageHeight: Int32): CJReturnValue {
         let color:Array<Byte> = Array<Byte>(Int64(imageWidth*imageHeight*4),repeat:0)
         let value:CJReturnValue = CJReturnValue()
         if (let Some(i) <- decoder) {
             value.code =  i.nextFrameffi(color, imageWidth, imageHeight)
             value.color = color
             return value
         }
         value.code = -1
         return value
     }


     public func nthFrameffi(index: Int32,imageWidth: Int32, imageHeight: Int32): CJReturnValue {
         let color:Array<Byte> = Array<Byte>(Int64(imageWidth*imageHeight*4),repeat:0)
         let value:CJReturnValue = CJReturnValue()
         if (let Some(i) <- decoder) {
             value.code = i.nthFrameffi(index, color, imageWidth, imageHeight)
             value.color = color
             return value
         }
         value.code = -1
         return value
     }


     public func decodeffi(encoded: Array<Byte>, imageWidth: Int32, imageHeight: Int32): CJReturnValue {
         let color:Array<Byte> = Array<Byte>(Int64(imageWidth*imageHeight*4),repeat:0)
         let value:CJReturnValue = CJReturnValue()
         if (let Some(i) <- decoder) {
             value.issuccess = i.decodeffi(encoded, color, imageWidth, imageHeight)
             value.color = color
             return value
         }
         value.issuccess = false
         return value
     }


     public func release(): Unit {
         if (let Some(i) <- decoder) {
             return i.release()
         }
     }
 }