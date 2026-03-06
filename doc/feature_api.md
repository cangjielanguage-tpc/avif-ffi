# avif-ffi

## 介绍

avif-ffi是一款仓颉显示avif图片的库,包括静态图和动态图

## 1 avif-hybrid

#### 1.1.1 API Description

component AvifViewTS 图片显示组件
```ets
export struct AvifViewTS {

    model?: AvifImageModel  //avif自定义组件绑定对象
}
```

class AvifImageModel 图片数据封装类
```ets
export class AvifImageModel {


    constructor () //构造函数

     /*
     * 设置图片的路径
     * @param 参数 uri - 图片的路径 
     * 其中resources/base/media/a2.avif 文件写成 media://a2 即可,不需要加.avif后缀
     * 其中resources/rawfile/a2.avif 文件写成 rawfile://a2.avif 即可,需要加.avif后缀
     * 其中沙箱路径 文件写成 file://沙箱路径/a2.avif 即可 需要加file://前缀 
     * 网络图片直接写url即可
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
    public setUri(uri: string): AvifImageModel
    
     /*
     * 设置图片对象的宽度
     * @param 参数 imagePicWidth - 图片对象的宽度，单位是像素
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
    public setImagePicWidth(imagePicWidth: number): AvifImageModel
    
    /*
     * 设置图片对象的高度
     * @param 参数 imagePicHeight - 图片对象的高度，单位是像素
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
    public setImagePicHeight(imagePicHeight: number): AvifImageModel

    /*
     * 设置图片控件的宽度
     * @param 参数 imageViewWidth - 图片控件的宽度，支持 '100vp'表示100vp '100px'表示100像素 '100%'表示百分比100
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setImageViewWidth(imageViewWidth: string): AvifImageModel

    /*
     * 设置图片控件的高度
     * @param 参数 imageViewHeight - 图片控件的高度，支持 '100vp'表示100vp '100px'表示100像素 '100%'表示百分比100
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setImageViewHeight(imageViewHeight: string): AvifImageModel

    /*
     * 设置图片和控件的对齐方式
     * @param 参数 imageFit - 图片和控件的对齐方式 ，String可填"fill","contain","cover","auto","scaledown"
     * "top_start","top","top_end","start","center","end","bottom_start","bottom","bottom_end"
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setImageFit(imageFit: string): AvifImageModel

    /*
     * 设置图片是否可拖拽
     * @param 参数 draggable - true 可拖拽 false 不可拖拽 
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setDraggable(draggable: boolean): AvifImageModel
  
    /*
     * 设置图片的左上圆角
     * @param 参数 topleftBorderRadius - 左上圆角的宽度 支持 '100vp'表示100vp '100px'表示100像素 '100%'表示百分比100
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setTopleftBorderRadius(topleftBorderRadius: string): AvifImageModel

    /*
     * 设置图片的右上圆角
     * @param 参数 toprightBorderRadius - 右上圆角的宽度 支持 '100vp'表示100vp '100px'表示100像素 '100%'表示百分比100
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public  setToprightBorderRadius(toprightBorderRadius: string): AvifImageModel
     
    /*
     * 设置图片的左下圆角
     * @param 参数 bottomleftBorderRadius - 左下圆角的宽度 支持 '100vp'表示100vp '100px'表示100像素 '100%'表示百分比100
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setBottomleftBorderRadius(bottomleftBorderRadius: string): AvifImageModel

    /*
     * 设置图片的右下圆角
     * @param 参数 bottomrightBorderRadius - 右下圆角的宽度 支持 '100vp'表示100vp '100px'表示100像素 '100%'表示百分比100
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setBottomrightBorderRadius(bottomrightBorderRadius: string): AvifImageModel

    /*
     * 图片数据加载成功触发回调，返回图片加载成功的状态值
     * @param callback - 图片加载成功的回调函数，loadingStatus表示图片加载成功的状态值，当loadingStatus的值为0时，表示图片数据加载成功。当loadingStatus的值为1时，表示图片解码成功。
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setOnComplete(callback: (loadingStatus: number) => void): AvifImageModel

}
```


class AvifDecoderTS avif解码器
```ets
export class AvifDecoderTS{


     constructor () //构造函数

     /*
     * 创建图片的解码器
     * @param 参数 uri - 图片的路径
     * 其中resources/base/media/a2.avif 文件写成 media://a2 即可,不需要加.avif后缀
     * 其中resources/rawfile/a2.avif 文件写成 rawfile://a2.avif 即可,需要加.avif后缀
     * 其中沙箱路径 文件写成 file://沙箱路径/a2.avif 即可 需要加file://前缀 
     * 网络图片直接写url即可
     *
     * @return 返回 CJAvifDecoder|undefined 类型，如果不为undefined则创建成功,否则创建失败
     */
     public create(uri:string):CJAvifDecoder|undefined
    
    
    /*
     * 创建图片的解码器
     * @param 参数 uri - 图片的路径
     * @param 参数 threads -  需要的线程数,小于0表示值为手机默认cpu核心数,等于0表示手机默认cpu核心数和2之间小的那个数，大于0并且不大于cpu核心数
     *
     * @return 返回 CJAvifDecoder|undefined 类型，如果不为undefined则创建成功,否则创建失败
     */
     public createWithThread(uri:string, threads: number):CJAvifDecoder|undefined
     
    /*
     * 获取avif文件对应图片的宽度,单位像素
     *
     * @return 返回 number 类型，avif文件对应图片的宽度,单位像素
     */
     public getWidth():number
     
     /*
     * 获取avif文件对应图片的高度,单位像素
     *
     * @return 返回 number 类型，avif文件对应图片的高度,单位像素
     */
     public getHeight():number

    /**
     * 获取avif文件对应图片的深度,单位像素
     *
     * @return 返回 number 类型，avif文件对应图片的深度,单位像素
     */
     public getDepth():number

    /**
     * 判断avif文件对应图片是否有alpha透明通道
     * 
     * 返回值 boolean 类型 - true表示有 false表示没有
     */
     public getAlphaPresent():boolean
     
    /**
     * 获取avif文件对应的图片帧数
     * 
     * 返回值 number 类型 - avif文件对应的图片帧数 静态图默认1帧
     */
     public getFrameCount():number
     
    /**
     * 获取动态图片的重复次数
     * 
     * 返回值 number 类型 - 动态图片的重复次数 静态图默认为0   动态图-1和0表示无限循环 大于0的数n表示图片会播放(n+1)次
     */
     public getRepetitionCount():number

    /**
     * 获取动态图片的每帧显示的时间长度的数组
     * 
     * 返回值 Array<number> | undefined 类型 - 动态图片的每帧显示的时间长度的数组 静态图默认为[1.000000] 动态图一般为长度大于1的数组比如[0.166667, 0.166667, 0.166667, 0.166667, 0.166667]
     */   
     public getFrameDurations(): Array<number> | undefined

    /**
     * 判断文件是否是avif图像
     *
     * 返回值 number 类型 - 是avif图像返回1 否则返回0
     */    
     public isAvifImageffi(): number
     
    /**
     * 获取下一次调用时将返回的帧的从0开始的索引。
     * 
     * 返回值 number - 返回的索引Index
     */
     public nextFrameIndexffi(): number
      
    /**
     * 将动画AVIF的下一帧图片的颜色像素赋值到color数组,以便于后续构造PixelMap展示
     * 
     * 参数 imageWidth - 解码生成的图片的宽度
     * 参数 imageHeight - 解码生成的图片的高度
     *
     * 返回值 CJReturnValue 类型 - 里面包含code issuccess color字段code表示状态码  issuccess表示是否成功 color表示图片的颜色数据对象
     */
     public nextFrameffi(imageWidth: number, imageHeight: number): CJReturnValue

    /**
     * 将动画AVIF的第index帧图片的颜色像素赋值到color数组,以便于后续构造PixelMap展示
     * 
     * 参数 index - 要解码的第index帧
     * 参数 imageWidth - 解码生成的图片的宽度
     * 参数 imageHeight - 解码生成的图片的高度
     * 
     * 返回值 CJReturnValue 类型 - 里面包含code issuccess color字段code表示状态码  issuccess表示是否成功 color表示图片的颜色数据对象
     */    
     public nthFrameffi(index: number, imageWidth: number, imageHeight: number): CJReturnValue

    /**
     * 将动画AVIF的下一帧图片的颜色像素赋值到color数组,以便于后续构造PixelMap展示
     * 
     * 参数 imageWidth - 解码生成的图片的宽度
     * 参数 imageHeight - 解码生成的图片的高度
     * 
     * 返回值 CJReturnValue 类型 - 里面包含code issuccess color字段code表示状态码  issuccess表示是否成功 color表示图片的颜色数据对象
     */   
     public decodeffi(imageWidth: number, imageHeight: number): CJReturnValue

    /**
     * 销毁avif图片的解码器,释放内存,以防出现资源浪费问题
     * 
     */   
     public release(): void

}
```

#### 1.1.2 其他接口

class CJReturnValue 图片解析返回类
```ets
export declare class CJReturnValue {

    constructor () //构造函数

    code: number  //状态码
    color: ArrayBuffer | undefined  //返回的图片的颜色数据
    issuccess: boolean  //是否成功 true 表示成功  false 表示失败 

}
```

```ets
export class GlobalUtils {

  /**
     * 设置内存缓存的最大内存对象个数和内存之和的上限，不设置的化默认值512和1024*1024*1024
     * 
     * 参数 countSize - 内存对象的个数，必须大于0,小于等于65536
     * 参数 memorySize - 内存之和的上限,必须大于0，小于等于 10 * 1024 * 1024 * 1024
     * 
     * 返回值 void 类型 
     */   
  static setMemoryLruCacheTS(countSize:number,memorySize:number):void
  
  /**
     * 设置文件缓存的最大文件对象个数和文件大小之和的上限，不设置的化默认值512和1024*1024*1024
     * 
     * 参数 countSize - 文件缓存对象的个数，必须大于0，小于等于Int64最大值
     * 参数 memorySize - 文件大小之和的上限，必须大于0，小于等于10 * 1024 * 1024 * 1024
     * 
     * 返回值 void 类型 
     */   
  static setFileLruCacheTS(countSize:number,memorySize:number):void
}
```

class CJAvifDecoder 仓颉测图片解析类(带缓存逻辑)
```cj
public class CJAvifDecoder {

     /**
     * 构造函数
     * 
     */   
    public init() 
    
     /*
     * 创建图片的解码器
     * @param 参数 uri - 图片的路径
     * 其中resources/base/media/a2.avif 文件写成 media://a2 即可,不需要加.avif后缀
     * 其中resources/rawfile/a2.avif 文件写成 rawfile://a2.avif 即可,需要加.avif后缀
     * 其中沙箱路径 文件写成 file://沙箱路径/a2.avif 即可 需要加file://前缀 
     * 网络图片直接写url即可
     *
     * @return 返回 Option<CJAvifDecoder>  类型，如果不为None则创建成功,否则创建失败
     */
    public func create(uri: String): Option<CJAvifDecoder> 
    
    /*
     * 创建图片的解码器
     * @param 参数 uri - 图片的路径
     * @param 参数 threads -  需要的线程数,小于0表示值为手机默认cpu核心数,等于0表示手机默认cpu核心数和2之间小的那个数，大于0并且不大于cpu核心数
     *
     * @return 返回 Option<CJAvifDecoder>  类型，如果不为None则创建成功,否则创建失败
     */
    public func createWithThread(uri: String, threads: Int32): Option<CJAvifDecoder> 
    
    /*
     * 获取avif文件对应图片的宽度,单位像素
     *
     * @return 返回 Int64 类型，avif文件对应图片的宽度,单位像素
     */
    public func getWidth(): Int64 
    
    /*
     * 获取avif文件对应图片的高度,单位像素
     *
     * @return 返回 Int64 类型，avif文件对应图片的高度,单位像素
     */
    public func getHeight(): Int64 
    
    /**
     * 获取avif文件对应图片的深度,单位像素
     *
     * @return 返回 Int64 类型，avif文件对应图片的深度,单位像素
     */
    public func getDepth(): Int64
    
    /**
     * 判断avif文件对应图片是否有alpha透明通道
     * 
     * 返回值 Bool 类型 - true表示有 false表示没有
     */ 
    public func getAlphaPresent(): Bool 
    
    /**
     * 获取avif文件对应的图片帧数
     * 
     * 返回值 Int64 类型 - avif文件对应的图片帧数 静态图默认1帧
     */
    public func getFrameCount(): Int64 
    
    /**
     * 获取动态图片的重复次数
     * 
     * 返回值 Int64 类型 - 动态图片的重复次数 静态图默认为0   动态图-1和0表示无限循环 大于0的数n表示图片会播放(n+1)次
     */
    public func getRepetitionCount(): Int64 
    
     /**
     * 获取动态图片的每帧显示的时间长度的数组
     * 
     * 返回值 Option<JSArrayEx<Float64>>  类型 - 动态图片的每帧显示的时间长度的数组 静态图默认为[1.000000] 动态图一般为长度大于1的数组比如[0.166667, 0.166667, 0.166667, 0.166667, 0.166667]
     */   
    public func getFrameDurations(): Option<JSArrayEx<Float64>> 
    
    /**
     * 判断文件是否是avif图像
     *
     * 返回值 Int32 类型 - 是avif图像返回1 否则返回0
     */    
    public func isAvifImageffi(): Int32 
    
    /**
     * 获取下一次调用时将返回的帧的从0开始的索引。
     * 
     * 返回值 Int32 - 返回的索引Index
     */
    public func nextFrameIndexffi(): Int32 
    
    /**
     * 将动画AVIF的下一帧图片的颜色像素赋值到color数组,以便于后续构造PixelMap展示
     * 
     * 参数 imageWidth - 解码生成的图片的宽度
     * 参数 imageHeight - 解码生成的图片的高度
     *
     * 返回值 CJReturnValue 类型 - 里面包含code issuccess color字段code表示状态码  issuccess表示是否成功 color表示图片的颜色数据对象
     */
    public func nextFrameffi(imageWidth: Int32, imageHeight: Int32): CJReturnValue 
    
     /**
     * 将动画AVIF的第index帧图片的颜色像素赋值到color数组,以便于后续构造PixelMap展示
     * 
     * 参数 index - 要解码的第index帧
     * 参数 imageWidth - 解码生成的图片的宽度
     * 参数 imageHeight - 解码生成的图片的高度
     * 
     * 返回值 CJReturnValue 类型 - 里面包含code issuccess color字段code表示状态码  issuccess表示是否成功 color表示图片的颜色数据对象
     */  
    public func nthFrameffi(index: Int32,imageWidth: Int32, imageHeight: Int32): CJReturnValue 
    
    /**
     * 将动画AVIF的下一帧图片的颜色像素赋值到color数组,以便于后续构造PixelMap展示
     * 
     * 参数 imageWidth - 解码生成的图片的宽度
     * 参数 imageHeight - 解码生成的图片的高度
     * 
     * 返回值 CJReturnValue 类型 - 里面包含code issuccess color字段code表示状态码  issuccess表示是否成功 color表示图片的颜色数据对象
     */   
    public func decodeffi(imageWidth: Int32, imageHeight: Int32): CJReturnValue 
    
     /**
     * 销毁avif图片的解码器,释放内存,以防出现资源浪费问题
     * 
     */   
    public func release(): Unit 

```
