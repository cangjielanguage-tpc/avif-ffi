package libavif4cj

internal import ohos.base.nativeLog
import std.io.ByteBuffer
import ohos.image.PixelMap
import ohos.base.AppLog
import ohos.image.ImageInfo
import ohos.image.PixelMapFormat
import ohos.hilog.Hilog


//@FastNative
//foreign func avifCodecVersions(): CString


//@FastNative
//foreign func avifCodecVersions(): Unit
//
@FastNative
foreign func versionString(): CString

@FastNative
foreign func resultToString(result: Int32): CString

@FastNative
foreign func isAvifImage(result: CPointer<UInt8>,length:Int32): Int32

@FastNative
foreign func getInfo(result: CPointer<UInt8>,length:Int32): CPointer<Info>

@FastNative
foreign func encodedFree(encoded: CPointer<Info>): Unit

//uint8_t *address,int length, int threads
@FastNative
foreign func createDecoder(result: CPointer<UInt8>,length:Int32,threads:Int32):Int64

@FastNative
foreign func destroyDecoder(decoder:Int64):Unit

@FastNative
foreign func nextFrameIndex(decoder:Int64):Int32

@FastNative
foreign func nextFrame(decoder:Int64,pixels:CPointer<UInt8>,picwidth:Int32,picheight:Int32,stride:Int32,formatvalue:Int32):Int32

@FastNative
foreign func nthFrame(decoder:Int64,index:Int32,pixels:CPointer<UInt8>,picwidth:Int32,picheight:Int32,stride:Int32,formatvalue:Int32):Int32

@FastNative
foreign func decode(result: CPointer<UInt8>,length:Int32,pixels:CPointer<UInt8>,picwidth:Int32,picheight:Int32,stride:Int32,formatvalue:Int32):Bool

//bool decode(uint8_t *address,int length,uint8_t *pixels,uint32_t picwidth,uint32_t picheight,uint32_t stride,uint32_t formatvalue,int threads){

//bool getInfo(uint8_t *address, int length,InfoCpp info)

//  private static native boolean isAvifImage(ByteBuffer encoded, int length);
//@FastNative
//foreign func isAvifImage(encoded: CPointer<Unit>, length: Int32): Bool

////  public static native boolean getInfo(ByteBuffer encoded, int length, Info info);
//@FastNative
//foreign func getInfo(encoded: CPointer<Unit>, length: Int32,info:CPointer<Unit>): Bool
//
////  public static native boolean decode(ByteBuffer encoded, int length, Bitmap bitmap, int threads);
//@FastNative
//foreign func decode(encoded: CPointer<Unit>, length: Int32,bitmap:CPointer<Unit>,threads:Int32): Bool
//
//
////  private native int nextFrame(long decoder, Bitmap bitmap);
//@FastNative
//foreign func nextFrame(decoder: CPointer<Unit>,bitmap:CPointer<Unit>): Int32
//
////  private native int nextFrameIndex(long decoder);
//@FastNative
//foreign func nextFrameIndex(decoder: CPointer<Unit>): Int32
//
////  private native int nthFrame(long decoder, int n, Bitmap bitmap);
//@FastNative
//foreign func nthFrame(decoder: CPointer<Unit>,n:Int32,bitmap:CPointer<Unit>): Int32
//
//
////  public static native String resultToString(int result);
//@FastNative
//foreign func resultToString(result: Int32): CString
//

////  public static native String versionString();
//@FastNative
//foreign func versionString(): CString
//
//
////  private native long createDecoder(ByteBuffer encoded, int length, int threads);
//@FastNative
//foreign func createDecoder(encoded:CPointer<Unit>,length:Int32,threads:Int32): Int64
//
////  private native void destroyDecoder(long decoder);
//@FastNative
//foreign func destroyDecoder(decoder:CPointer<Unit>): Unit

public class AvifDecoder {

    private var decoder:Int64 = 0
    private var width:Int64 = 0
    private var height:Int64 = 0
    private var depth:Int64 = 0
    private var alphaPresent:Bool = false
    private var frameCount:Int64 = 0
    private var repetitionCount:Int64 = 0
    private var frameDurations:?Array<Float64> = None

//    private init(encoded:ByteBuffer, threads:Int64) {
//        //decoder = createDecoder(encoded, encoded.remaining(), threads);
//    }

//    public static func isAvifImage(buffer:ByteBuffer):Bool {
//        return AvifDecoder.isAvifImage(buffer, buffer.remaining());
//    }
//
//    public static func decode(encoded:ByteBuffer,length:Int64,bitmap:PixelMap):Bool {
//        return decode(encoded, length, bitmap, 0);
//    }
//
//      /** Get the width of the image. */
//    public func getWidth():Int64 {
//        return width
//    }
//
//  /** Get the height of the image. */
//    public func getHeight():Int64 {
//        return height
//    }
//
//  /** Get the depth (bit depth) of the image. */
//  public func getDepth():Int64 {
//        return depth
//  }
//
//  /** Returns true if the image contains a transparency/alpha channel, false otherwise. */
//  public func getAlphaPresent():Bool {
//    return alphaPresent
//  }
//
//  /** Get the number of frames in the image. */
//  public func getFrameCount():Int64 {
//    return frameCount
//  }
//
//  /**
//   * Get the number of repetitions for an animated image (see repetitionCount in avif.h for
//   * details).
//   */
//  public func getRepetitionCount():Int64 {
//    return repetitionCount
//  }
//
//  /** Get the duration for each frame in the image. */
//  public func getFrameDurations():?Array<Float64> {
//    return frameDurations
//  }
//
//  public func release():Unit {
//    if (decoder != 0) {
//        //destroyDecoder(decoder)
//    }
//    decoder = 0
//  }
//
//
//  public static func create(encoded:ByteBuffer):?AvifDecoder {
//    //return create(encoded, /* threads= */ 1)
//  }
//
//   public static func create(encoded:ByteBuffer, threads:Int64):?AvifDecoder {
//        var decoder:AvifDecoder = AvifDecoder(encoded, threads)
//        if(decoder.decoder == 0){
//            return None
//        }else{
//            return decoder
//        }
//    }
//
//
//    public func nextFrame(bitmap:PixelMap):Int64 {
//        //return nextFrame(decoder, bitmap);
//    }
//
//    public func nextFrameIndex():Int64 {
//      //  return nextFrameIndex(decoder);
//    }
//
//
//   public func nthFrame(n:Int64, bitmap:PixelMap):Int64 {
//    //return nthFrame(decoder, n, bitmap);
//  }


//    public func versionString():String {
//
//    }


      public func versionStringffi():String{
        unsafe {
           let cstr:CString = versionString()
           return cstr.toString()
        }
      }

    public func resultToStringffi(result:Int32):String{
        unsafe {
           let cstr:CString = resultToString(result)
           return cstr.toString()
        }
      }

    public func isAvifImageffi(encoded:Array<UInt8>):Int32{
        unsafe {
            let handle: CPointerHandle<UInt8> = acquireArrayRawData(encoded)
            let res:Int32 = isAvifImage(handle.pointer, Int32(encoded.size))
            return res
        }
    }

     public func getInfoffi(encoded:Array<UInt8>):Info{
        unsafe {
            let handle: CPointerHandle<UInt8> = acquireArrayRawData(encoded)
            var result: CPointer<Info> = getInfo(handle.pointer,Int32(encoded.size))
            var res: Info = result.read()
            var picWidth: UInt32 = res.width
            var picHeight: UInt32 = res.height
            var picDepth: UInt32 = res.depth
            var picalphaPresent: Bool = res.alphaPresent
            var frameCount: Int32 = res.frameCount
            var repetitionCount: Int32 = res.repetitionCount
            var frameDurations:CPointer<Float64> = res.frameDurations
            encodedFree(result)
            return Info(picWidth,picHeight,picDepth,picalphaPresent,frameCount,repetitionCount,frameDurations)
        }
    }


      public func createDecoderffi(encoded:Array<UInt8>,threads:Int32):Int64{
        unsafe {
            let handle: CPointerHandle<UInt8> = acquireArrayRawData(encoded)
            var address = createDecoder(handle.pointer,Int32(encoded.size),threads)
            return address
        }
      }



    public func destroyDecoderffi(address:Int64):Unit{
        unsafe {
            destroyDecoder(address)
        }
    }

    public func nextFrameIndexffi(address:Int64):Int32{
        unsafe {
            return nextFrameIndex(address);
        }
    }

    public func nextFrameffi(address:Int64,color:Array<UInt8>,imageWidth:Int32,imageHeight:Int32,format:PixelMapFormat):Int32{
        unsafe {
            //foreign func nextFrame(decoder:Int64,pixels:CPointer<UInt8>,picwidth:Int32,picheight:Int32,stride:Int32,formatvalue:Int32):Int32
            let handle: CPointerHandle<UInt8> = acquireArrayRawData(color)
            let format:Int32 = match (format) {
            	case PixelMapFormat.RGBA_F16 =>  0
                case PixelMapFormat.RGB_565 =>  1
                case _ => 2
            }
            Hilog.error(0,"avif nextFrameffi","----- 22222")
            Hilog.error(0,"avif nextFrameffi stride","format=${format}")
            return nextFrame(address,handle.pointer,imageWidth,imageHeight,imageWidth*4,format)
        }
    }

        public func nthFrameffi(address:Int64,index:Int32,color:Array<UInt8>,imageWidth:Int32,imageHeight:Int32,format:PixelMapFormat):Int32{
        unsafe {
            //foreign func nextFrame(decoder:Int64,pixels:CPointer<UInt8>,picwidth:Int32,picheight:Int32,stride:Int32,formatvalue:Int32):Int32
            let handle: CPointerHandle<UInt8> = acquireArrayRawData(color)
            let format:Int32 = match (format) {
            	case PixelMapFormat.RGBA_F16 =>  0
                case PixelMapFormat.RGB_565 =>  1
                case _ => 2
            }
            Hilog.error(0,"avif nextFrameffi","----- 22222")
            return nthFrame(address,index,handle.pointer,imageWidth,imageHeight,imageWidth*4,format)
        }
    }

     public func decodeffi(encoded:Array<UInt8>,color:Array<UInt8>,imageWidth:Int32,imageHeight:Int32,format:PixelMapFormat):Bool{
        unsafe {
            let handlePic: CPointerHandle<UInt8> = acquireArrayRawData(encoded)
            let handleColor: CPointerHandle<UInt8> = acquireArrayRawData(color)
            let format:Int32 = match (format) {
            	case PixelMapFormat.RGBA_F16 =>  0
                case PixelMapFormat.RGB_565 =>  1
                case _ => 2
            }
            Hilog.error(0,"avif nextFrameffi","----- 22222")
            return decode(handlePic.pointer,Int32(encoded.size),handleColor.pointer,imageWidth,imageHeight,imageWidth*4,format)
            return true
        }
    }


}
