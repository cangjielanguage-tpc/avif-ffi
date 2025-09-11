
## libavif4cj

### 介绍
libavif4cj是一款仓颉解码avif图片的库


### 1 libavif4cj 图片解码库

#### 1.1 AvifDecoder avif文件解码类

```cangjie
public class AvifDecoder {
    
    /**
     * 返回一个字符串，其中包含有关libavif版本、底层编解码器和libyuv版本（如果可用）。
     * 
     * @返回值 String libavif版本、底层编解码器和libyuv版本信息
     */
    public func versionStringffi():String
    
    /**
     * 返回一个描述avifResult枚举值的字符串
     * 
     * @参数 Int32 result avifResult的值
     * @返回值 String 包含avifResult描述的字符串
     */
    public func resultToStringffi(result:Int32):String
    
    
    
    /**
     * 判断文件是否是avif图像
     * 
     * @参数 Array<UInt8> 文件的字节数组信息
     * @返回值 Int32 是avif图像返回1 否则返回0
     */
    public func isAvifImageffi(encoded:Array<UInt8>):Int32


    /**
     * 解析AVIF标头并填充Info
     * 
     * @参数 Array<UInt8> 文件的字节数组信息
     * @返回值 Info  自定义类 里面包含avif的图像的一些信息如 width height depth alphaPresent
     */
    public func getInfoffi(encoded:Array<UInt8>):Info


     /**
     * 创建avif图片的解码器
     * 
     * @参数 Array<UInt8> 文件的字节数组信息
     * @参数 Int32 线程数
     * @返回值 Int64  解码器的C的内存地址的Int64表示形式
     */
    public func createDecoderffi(encoded:Array<UInt8>,threads:Int32):Int64

    
    /**
     * 销毁avif图片的解码器
     * 
     * @参数 Int64 解码器的C的内存地址的Int64表示形式
     */
    public func destroyDecoderffi(address:Int64):Unit
    
    
    
     /**
     * 获取下一次调用时将返回的帧的从0开始的索引。
     * 
     * @参数 Int64 解码器的C的内存地址的Int64表示形式
     * @返回值 Int32  返回的索引Index
     */
    public func nextFrameIndexffi(address:Int64):Int32


    /**
     * 将动画AVIF的下一帧解码为位图。
     * 
     * @参数 Int64 解码器的C的内存地址的Int64表示形式
     * @参数 Array<UInt8> 要接收的图像的像素的字节数组
     * @参数 ImageInfo 要接收的图像的图像信息
     * @返回值 Int32  返回0表示成功 其他错误码表示失败
     */
    public func nextFrameffi(address:Int64,color:Array<UInt8>,imageInfo:ImageInfo):Int32

    
     /**
     * 将动画AVIF的第index帧解码为位图。
     * 
     * @参数 Int64 解码器的C的内存地址的Int64表示形式
     * @参数 Int32 要解码的第index帧
     * @参数 Array<UInt8> 要接收的图像的像素的字节数组
     * @参数 ImageInfo 要接收的图像的图像信息
     * @返回值 Int32  返回0表示成功 其他错误码表示失败
     */
    public func nthFrameffi(address:Int64,index:Int32,color:Array<UInt8>,imageInfo:ImageInfo):Int32

    
    /**
     * 将动画AVIF的下一帧解码为位图。
     * 
     * @参数 Array<UInt8> 文件的字节数组信息
     * @参数 Array<UInt8> 要接收的图像的像素的字节数组
     * @参数 ImageInfo 要接收的图像的图像信息
     * @返回值 Bool  返回true表示成功 false表示失败
     */
    public func decodeffi(encoded:Array<UInt8>,color:Array<UInt8>,imageInfo:ImageInfo):Bool
  
    
}
```
