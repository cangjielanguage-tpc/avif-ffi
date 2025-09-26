
## avif4cj


### 介绍
avif4cj是一款仓颉显示avif图片的库,包括静态图和动态图


### 1 avif4cj 图片解码库


#### 1.1 AvifDecoder avif文件解码类

```cangjie
public class AvifDecoder {
    
    /**
     * 创建avif图片的解码器
     * 
     * @参数 Array<UInt8> avif文件的字节数组信息
     * @返回值 ?AvifDecoder avif图片的解码器对象
     */
    public static func create(encoded: Array<UInt8>): ?AvifDecoder
    
    /**
     * 创建avif图片的解码器
     * 
     * @参数 Array<UInt8> avif文件的字节数组信息
     * @参数 Int32 需要的线程数,小于0表示值为手机默认cpu核心数,等于0表示手机默认cpu核心数和2之间小的那个数，大于0则为有效值
     * @返回值 ?AvifDecoder avif图片的解码器对象
     */
    public static func create(encoded: Array<UInt8>, threads: Int32): ?AvifDecoder
    
    /**
     * 获取avif文件对应图片的宽度,单位像素
     * 
     * @返回值 Int64 avif文件对应图片的宽度,单位像素
     */
    public func getWidth(): Int64
    
    /**
     * 获取avif文件对应图片的高度,单位像素
     * 
     * @返回值 Int64 avif文件对应图片的高度,单位像素
     */
    public func getHeight(): Int64
    
    /**
     * 获取avif文件对应图片的深度
     * 
     * @返回值 Int64 avif文件对应图片的深度
     */
    public func getDepth(): Int64

    /**
     * 判断avif文件对应图片是否有alpha透明通道
     * 
     * @返回值 Bool true表示有 false表示没有
     */
    public func getAlphaPresent(): Bool
    
    /**
     * 获取avif文件对应的图片帧数
     * 
     * @返回值 Int64 avif文件对应的图片帧数 静态图默认1帧
     */
    public func getFrameCount(): Int64
    
    /**
     * 获取动态图片的重复次数
     * 
     * @返回值 Int64 动态图片的重复次数 静态图默认为0   动态图-1和0表示无限循环 大于0的数n表示图片会播放(n+1)次
     */
    public func getRepetitionCount(): Int64
    
    /**
     * 获取动态图片的每帧显示的时间长度的数组
     * 
     * @返回值 ?Array<Float64> 动态图片的每帧显示的时间长度的数组 静态图默认为[1.000000] 动态图一般为长度大于1的数组比如[0.166667, 0.166667, 0.166667, 0.166667, 0.166667]
     */
    public func getFrameDurations(): ?Array<Float64>
    
    /**
     * 判断文件是否是avif图像
     * 
     * @参数 Array<UInt8> avif文件的字节数组信息
     * @返回值 Int32 是avif图像返回1 否则返回0
     */
    
    public func isAvifImageffi(encoded:Array<UInt8>):Int32
    
    /**
     * 获取AVIF文件信息并填充到Cjinfo
     * 
     * @参数 Array<UInt8> avif文件的字节数组信息
     * @返回值 Cjinfo 自定义类 里面包含avif的图像的一些信息如 width height depth alphaPresent frameCount repetitionCount frameDurations
     */
    public func getInfoffi(encoded:Array<UInt8>):Cjinfo
    
     /**
     * 获取下一次调用时将返回的帧的从0开始的索引。
     * 
     * @返回值 Int32  返回的索引Index
     */
    public func nextFrameIndexffi():Int32
    
    /**
     * 将动画AVIF的下一帧解码为位图。
     * 
     * @参数 Array<UInt8> 要接收的图像的像素的字节数组
     * @参数 Int32 解码生成的图片的宽度
     * @参数 Int32 解码生成的图片的高度
     * @参数 PixelMapFormat 解码生成的图片的像素格式
     * @返回值 Int32  返回0表示成功 其他错误码表示失败
     */
    public func nextFrameffi(color: Array<UInt8>, imageWidth: Int32, imageHeight: Int32, format: PixelMapFormat): Int32
    
     /**
     * 将动画AVIF的第index帧解码为位图。
     * 
     * @参数 Int32 要解码的第index帧
     * @参数 Array<UInt8> 要接收的图像的像素的字节数组
     * @参数 Int32 解码生成的图片的宽度
     * @参数 Int32 解码生成的图片的高度
     * @参数 PixelMapFormat 解码生成的图片的像素格式
     * @返回值 Int32  返回0表示成功 其他错误码表示失败
     */
    public func nthFrameffi(index: Int32, color: Array<UInt8>, imageWidth: Int32, imageHeight: Int32, format: PixelMapFormat): Int32
    
    /**
     * 将动画AVIF的下一帧解码为位图。
     * 
     * @参数 Array<UInt8> avif文件的字节数组信息
     * @参数 Array<UInt8> 要接收的图像的像素的字节数组
     * @参数 Int32 解码生成的图片的宽度
     * @参数 Int32 解码生成的图片的高度
     * @参数 PixelMapFormat 解码生成的图片的像素格式
     * @返回值 Bool  返回true表示成功 false表示失败
     */
    public func decodeffi(encoded: Array<UInt8>, color: Array<UInt8>, imageWidth: Int32, imageHeight: Int32, format: PixelMapFormat): Bool
    
    /**
     * 销毁释放avif图片的解码器
     * 
     */
    public func release(): Unit
    
}
```

#### 1.2 Cjinfo avif图片信息类

```cangjie

public class Cjinfo  {
    
    //avif图片的宽度 单位像素
    public var width: UInt32 = 0
    //avif图片的高度 单位像素
    public var height: UInt32 = 0
    //avif图片的深度
    public var depth: UInt32 = 0
    //avif图片是否有alpha透明通道
    public var alphaPresent: Bool = false
    //avif图片中有多少帧 静态图默认1帧
    public var frameCount: Int32 = 0
    //avif动态图片循环播放几次 静态图默认为0   动态图-1和0表示无限循环 大于0的数n表示图片会播放(n+1)次
    public var repetitionCount: Int32 = 0
    //avif动态图片每帧显示时长组成的数组 静态图默认为[1.000000] 动态图一般为长度大于1的数组比如[0.166667, 0.166667, 0.166667, 0.166667, 0.166667]
    public var frameDurations: Array<Float64> = Array<Float64>()
    
}
```