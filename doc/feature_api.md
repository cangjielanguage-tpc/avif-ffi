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
     * 注意：未设置图片路径时会抛出imagebuffer can not be none的异常
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
     public setImageViewWidth(imageViewWidth: Length): AvifImageModel

    /*
     * 设置图片控件的高度
     * @param 参数 imageViewHeight - 图片控件的高度，支持 '100vp'表示100vp '100px'表示100像素 '100%'表示百分比100
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setImageViewHeight(imageViewHeight: Length): AvifImageModel

    /*
     * 设置图片和控件的对齐方式
     * @param 参数 imageFit - 图片和控件的对齐方式 
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setImageFit(imageFit: ImageFit): AvifImageModel

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
     public setTopleftBorderRadius(topleftBorderRadius: Length): AvifImageModel

    /*
     * 设置图片的右上圆角
     * @param 参数 toprightBorderRadius - 右上圆角的宽度 支持 '100vp'表示100vp '100px'表示100像素 '100%'表示百分比100
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public  setToprightBorderRadius(toprightBorderRadius: Length): AvifImageModel
     
    /*
     * 设置图片的左下圆角
     * @param 参数 bottomleftBorderRadius - 左下圆角的宽度 支持 '100vp'表示100vp '100px'表示100像素 '100%'表示百分比100
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setBottomleftBorderRadius(bottomleftBorderRadius: Length): AvifImageModel

    /*
     * 设置图片的右下圆角
     * @param 参数 bottomrightBorderRadius - 右下圆角的宽度 支持 '100vp'表示100vp '100px'表示100像素 '100%'表示百分比100
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setBottomrightBorderRadius(bottomrightBorderRadius: Length): AvifImageModel

    /*
     * 图片数据加载成功触发回调，返回图片加载成功的状态值
     * @param callback - 图片加载成功的回调函数，loadingStatus表示图片加载成功的状态值，当loadingStatus的值为0时，表示图片数据加载成功。当loadingStatus的值为1时，表示图片解码成功。
     *
     * @return 返回 AvifImageModel 类型，支持链式调用
     */
     public setOnComplete(callback: (loadingStatus: number) => void): AvifImageModel

}
```

class CjCacheCheckTS avif内存缓存检查类
只有单图有内存缓存，多图由于占据内存缓存会特别大，所以多图没有设置内存缓存

```ets
export class CjCacheCheckTS{

  constructor () //构造函数
  
    /**
     * 根据uri,width和height获取图片的内存缓存（仅单图有内存缓存，多图由于所占内存太大没有设置内存缓存），内存对象的宽高如果和原图一样，宽高可设置0,0,如果这样的话，
     * 在调用public func nextFrameffi(imageWidth: Int32, imageHeight: Int32): CJReturnValue接口的时候,这边的宽高也要设置0，0这样才能匹配上内存缓存的key,找到内存缓存 
     * 如果设置宽高非0，那么nextFrameffi的宽高也要一致，才能找到对应的内存换存
     * 
     * 参数 uri - 图片的uri
     * 参数 imagePicWidth - 预期的图片的宽度
     * 参数 imagePicHeight - 预期的图片的高度
     * 
     * 返回值 CJReturnValue 类型 - 里面包含code issuccess color memoryWidth memoryHeight 字段 
     * code表示状态码  issuccess表示是否成功 color表示图片的颜色数据对象 memoryWidth表示内存缓存宽  memoryHeight表示内存缓存高 
     */ 
   public getMemoryCache(uri:string,imagePicWidth:number,imagePicHeight:number):CJReturnValue
   
}

```


class AvifDecoderTS avif解码器
```ets
export class AvifDecoderTS{

    /*
     * 静态方法 异步创建图片的解码器
     * @param 参数 uri - 图片的路径
     * @param 参数 threads -  需要的线程数,小于0表示值为手机默认cpu核心数,等于0表示手机默认cpu核心数和2之间小的那个数，大于0并且不大于cpu核心数
     * 其中resources/base/media/a2.avif 文件写成 media://a2 即可,写成media://a2.avif也可
     * 其中resources/rawfile/a2.avif 文件写成 rawfile://a2.avif 即可,需要加.avif后缀
     * 其中沙箱路径 文件写成 file://沙箱路径/a2.avif 即可 需要加file://前缀 
     * 网络图片直接写url即可
     *
     * @return 返回 Promise<AvifDecoderTS|undefined> 类型，如果不为undefined则创建成功,否则创建失败
     */
     public static async create(uri: string, threads: number=1): Promise<AvifDecoderTS|undefined>
     
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
     * 静态方法，判断文件是否是avif图像
     *
     * 参数 buffer - 图片的原始字节数据
     * 返回值 number 类型 - 是avif图像返回1 否则返回0
     */    
     public static isAvifImageffi(buffer:ArrayBuffer): number {
     
    /**
     * 获取下一次调用时将返回的帧的从0开始的索引。
     * 
     * 返回值 number - 返回的索引Index
     */
     public nextFrameIndexffi(): number
      
    /**
     * 异步将动画AVIF的下一帧图片的颜色像素赋值到color数组,以便于后续构造PixelMap展示
     * 
     * 参数 imageWidth - 解码生成的图片的宽度
     * 参数 imageHeight - 解码生成的图片的高度
     *
     * 返回值 CJReturnValue 类型 - 里面包含code issuccess color字段code表示状态码  issuccess表示是否成功 color表示图片的颜色数据对象
     */
     public async nextFrameffi(imageWidth: number, imageHeight: number): Promise<CJReturnValue>{

    /**
     * 异步将动画AVIF的第index帧图片的颜色像素赋值到color数组,以便于后续构造PixelMap展示
     * 
     * 参数 index - 要解码的第index帧
     * 参数 imageWidth - 解码生成的图片的宽度
     * 参数 imageHeight - 解码生成的图片的高度
     * 
     * 返回值 CJReturnValue 类型 - 里面包含code issuccess color字段code表示状态码  issuccess表示是否成功 color表示图片的颜色数据对象
     */    
     public async nthFrameffi(index: number, imageWidth: number, imageHeight: number): Promise<CJReturnValue>{

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
    memoryWidth:Int64  //内存图片的宽
    memoryHeight:Int64  //内存图片的高

}
```

```ets
export class GlobalUtils {

  /**
     * 设置内存缓存的最大内存对象个数和内存之和的上限，不设置的化默认值256和40*1024*1024,强烈建立使用默认值
     * 
     * 参数 countSize - 内存对象的个数，必须大于0,小于等于65536
     * 参数 memorySize - 内存之和的上限,必须大于0，小于等于 10 * 1024 * 1024 * 1024
     * 
     * 返回值 void 类型 
     */   
  static setMemoryLruCacheTS(countSize:number,memorySize:number):void
  
  /**
     * 设置文件缓存的最大文件对象个数和文件大小之和的上限，不设置的化默认值1500和256*1024*1024，强烈建立使用默认值
     * 
     * 参数 countSize - 文件缓存对象的个数，必须大于0，小于等于Int64最大值
     * 参数 memorySize - 文件大小之和的上限，必须大于0，小于等于10 * 1024 * 1024 * 1024
     * 
     * 返回值 void 类型 
     */   
  static setFileLruCacheTS(countSize:number,memorySize:number):void
  
    /**
     * 获取文件缓存中允许的最大文件数量
     * 
     * 返回值 number 类型 表示文件缓存中允许的最大文件数量
     */   
  static getFileMaxCountSizeTS():number
  
    /**
     * 获取文件缓存中允许的所有文件的总大小
     * 
     * 返回值 number 类型 表示文件缓存中允许的所有文件的总大小
     */   
  static getFileMaxMemorySizeTS():number
  
    /**
     * 获取内存缓存中允许的最大的内存对象数量
     * 
     * 返回值 number 表示内存缓存中允许的最大的内存对象数量
     */   
  static getMemoryMaxCountSizeTS():number
  
    /**
     * 获取内存缓存中允许的最大的所有内存对象的总大小
     * 
     * 返回值 number 表示内存缓存中允许的最大的所有内存对象的总大小
     */   
  static getMemoryMaxMemorySizeTS():number
  
  /**
     * 设置Context对象到仓颉
     * 
     * 参数 context - Context上下文对象
     * 
     * 返回值 void 类型 
     */   
  static setAvifContext(context:Context):void

}
```

