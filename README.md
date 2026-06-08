<div align="center">
<h1>avif-ffi</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.1.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.1.3-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-NA%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>


## 介绍

avif-ffi是一个对avif图片进行解码显示的库，解码后静态avif图片和动态avif图片都可以显示在控件上


### 特性

本项目参考开源库libavif开发

- 🚀 支持avif静态图片解码显示。
- 🚀 支持avif动态图片解码显示。
- 🚀 提供了自定义组件方式，方便用户使用。
- 🚀 增加了缓存功能



### 源码目录

```shell
─avif_hybrid
  └─src
      └─main
          ├─cangjie
          ├─ets
          └─resources
```

- `avif_hybrid` 工程模块 - 编译生成一个har包
- `avif_hybrid src` 模块代码目录
- `avif_hybrid src main` 模块项目目录
- `avif_hybrid src main cangjie` 仓颉代码目录
- `avif_hybrid src main ets` ets代码目录
- `avif_hybrid src main resources` 资源文件目录



### 接口说明

主要类和函数接口说明详见 [API](https://gitcode.com/Cangjie-TPC/avif-ffi/blob/avif-ffi_hybrid-cangjie-plugin-5.1.1_xc/doc/feature_api.md)


## 使用说明

### 三方库导入使用

```ets
      
    1. 本地编译安装
       
        描述具体的编译过程：

        1.先通过命令把代码下载下来
        git clone -b avif-ffi_hybrid-cangjie-plugin-5.1.1_xc https://gitcode.com/Cangjie-TPC/avif-ffi.git
              
        2.在deveco里选择avif_hybrid模块,点击Build菜单,然后点击 Make Module 'avif_hybrid' 等待编译完成,项目则编译成功
    
        3. 然后在avif_hybrid模块下的build/default/outputs/default/下找到avif_hybrid.har
        
        4. 用户在自己应用的module下新建一个文件夹名为har,然后把avif_hybrid.har文件放入其中

        5. 然后在用户module下的oh-package.json5下面添加依赖
           "dependencies": {
                "@cangjie-tpc/avif_hybrid": "file:./har/avif_hybrid.har"
           }
           添加完后点击自动弹出的sync now同步
    
        6. 在项目中使用avif项目        
        import { AvifDecoderTS,CjCacheCheckTS,GlobalUtils,global_customLib,CJReturnValue } from '@cangjie-tpc/avif_hybrid';
    
```

### 功能示例

#### 1. 在项目中显示avif图片


##### 1.1 用提供的自定义组件加载两个本地的resources下的media下的avif图片,一个是静态图 一个是动态图

示例代码如下：
```ets
import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page11Test {
  avifImageModel1: AvifImageModel = new AvifImageModel()
  avifImageModel2: AvifImageModel = new AvifImageModel()
  avifImageModel3: AvifImageModel = new AvifImageModel()
  avifImageModel4: AvifImageModel = new AvifImageModel()
  avifImageModel5: AvifImageModel = new AvifImageModel()
  avifImageModel6: AvifImageModel = new AvifImageModel()

  @State ready: boolean = false

  completeCallback(status: number): void {
    hilog.error(1, "1", 'complete')
  }

  async aboutToAppear(): Promise<void> {

      this.avifImageModel1.setUri("https://pic1.iqiyipic.com/image/20240622/65/fc/v_177081820_m_601_m1_592_333.avif")
        .setImageViewWidth('600px')
        .setImageViewHeight('400px')
        .setTopleftBorderRadius('20vp')
        .setToprightBorderRadius('20vp')
        .setBottomleftBorderRadius('20vp')
        .setBottomrightBorderRadius('20vp')
        .setOnComplete(this.completeCallback)
        .setDraggable(false)

      this.avifImageModel2.setUri("https://pic8.iqiyipic.com/animated/20250806/3f/9e/5830642737316600_1754449128430_720_405.avif")
        .setImageViewWidth('600px')
        .setImageViewHeight('400px')
        .setTopleftBorderRadius('20vp')
        .setToprightBorderRadius('20vp')
        .setBottomleftBorderRadius('20vp')
        .setBottomrightBorderRadius('20vp')
        .setOnComplete(this.completeCallback)
        .setDraggable(true)

    this.avifImageModel3.setUri("media://a2")
      .setImageViewWidth('600px')
      .setImageViewHeight('400px')
      .setTopleftBorderRadius('20vp')
      .setToprightBorderRadius('20vp')
      .setBottomleftBorderRadius('20vp')
      .setBottomrightBorderRadius('20vp')
      .setOnComplete(this.completeCallback)
      .setDraggable(true)

    this.avifImageModel4.setUri("media://a22")
      .setImageViewWidth('600px')
      .setImageViewHeight('400px')
      .setTopleftBorderRadius('20vp')
      .setToprightBorderRadius('20vp')
      .setBottomleftBorderRadius('20vp')
      .setBottomrightBorderRadius('20vp')
      .setOnComplete(this.completeCallback)
      .setDraggable(true)

    this.avifImageModel5.setUri("rawfile://a3.avif")
      .setImageViewWidth('600px')
      .setImageViewHeight('400px')
      .setTopleftBorderRadius('20vp')
      .setToprightBorderRadius('20vp')
      .setBottomleftBorderRadius('20vp')
      .setBottomrightBorderRadius('20vp')
      .setOnComplete(this.completeCallback)
      .setDraggable(true)

    this.avifImageModel6.setUri("rawfile://a23.avif")
      .setImageViewWidth('600px')
      .setImageViewHeight('400px')
      .setTopleftBorderRadius('20vp')
      .setToprightBorderRadius('20vp')
      .setBottomleftBorderRadius('20vp')
      .setBottomrightBorderRadius('20vp')
      .setOnComplete(this.completeCallback)
      .setDraggable(true)

       this.ready = true
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          if (this.ready) {
            AvifViewTS({ model: this.avifImageModel1 })
            AvifViewTS({ model: this.avifImageModel2 })
            AvifViewTS({ model: this.avifImageModel3 })
            AvifViewTS({ model: this.avifImageModel4 })
            AvifViewTS({ model: this.avifImageModel5 })
            AvifViewTS({ model: this.avifImageModel6 })
          }
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}
```

执行结果如下：
图片在手机上成功展示。

```shell
正常显示图片
```


##### 1.2 用提供的api加载一个url下的avif图片。内存图片为原图大小

示例代码如下：
```ets


import { AvifDecoderTS, CjCacheCheckTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page1Test {
  @State pixelMap: PixelMap | undefined = undefined
  @State mWidth: number = 0
  @State mHeight: number = 0



  async aboutToAppear(): Promise<void> {
    let uri = "https://pic1.iqiyipic.com/image/20240622/65/fc/v_177081820_m_601_m1_592_333.avif"
    let cacheCheck = new CjCacheCheckTS()
    let cJReturnValue = cacheCheck.getMemoryCache(uri,0,0)
    if(cJReturnValue.issuccess){
      hilog.error(0,"aviflog","走的是内存缓存"+cJReturnValue.memoryHeight+"---"+cJReturnValue.memoryWidth)
      if(cJReturnValue.color){
        let array = new Uint8Array(cJReturnValue.color)
        hilog.error(0,"aviflog","走的是内存缓存"+array.length)
      }
      this.mWidth = cJReturnValue.memoryWidth
      this.mHeight = cJReturnValue.memoryHeight
      let validReturnValue = cJReturnValue.color ?? new Uint8Array()
      let opts: image.InitializationOptions =
        { editable: true, pixelFormat: 3, size: { height: cJReturnValue.memoryHeight, width: cJReturnValue.memoryWidth } }
      this.pixelMap = await image.createPixelMap(validReturnValue, opts)
    }else{
      let decoderTs = await AvifDecoderTS.create(uri)
      if(!decoderTs){
        return
      }
      this.mWidth = decoderTs.getWidth()
      this.mHeight = decoderTs.getHeight()
      let cjreturnValue = await decoderTs.nextFrameffi(0,0)
      let validReturnValue = cjreturnValue.color ?? new Uint8Array()
      if(cjreturnValue.color){
        let array = new Uint8Array(cjreturnValue.color)
        hilog.error(0,"aviflog","数据"+array.length)
      }
      let opts: image.InitializationOptions =
        { editable: true, pixelFormat: 3, size: { height: this.mHeight, width: this.mWidth } }
      this.pixelMap = await image.createPixelMap(validReturnValue, opts)
      decoderTs.release()
    }
  }

  aboutToDisappear(): void {
    if (this.pixelMap) {
      this.pixelMap.release()
    }
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          Image(this.pixelMap)
            .width(this.mWidth)
            .height(this.mHeight)
            .objectFit(ImageFit.Fill)
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}


```

执行结果如下：
图片在手机上成功展示。

```shell
正常显示图片
```

##### 1.3 用提供的api加载一个url下的avif图片。内存图片为100*100

示例代码如下：
```ets

import { AvifDecoderTS, CjCacheCheckTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page5Test {
  @State pixelMap: PixelMap | undefined = undefined
  @State mWidth: number = 0
  @State mHeight: number = 0


  async aboutToAppear(): Promise<void> {
    let uri = "https://pic1.iqiyipic.com/image/20240622/65/fc/v_177081820_m_601_m1_592_333.avif"
    let cacheCheck = new CjCacheCheckTS()
    let cJReturnValue = cacheCheck.getMemoryCache(uri,100,100)
    if(cJReturnValue.issuccess){
      hilog.error(0,"aviflog","走的是内存缓存"+cJReturnValue.memoryHeight+"---"+cJReturnValue.memoryWidth)
      if(cJReturnValue.color){
        let array = new Uint8Array(cJReturnValue.color)
        hilog.error(0,"aviflog","走的是内存缓存"+array.length)
      }
      let validReturnValue = cJReturnValue.color ?? new Uint8Array()
      let opts: image.InitializationOptions =
        { editable: true, pixelFormat: 3, size: { height: cJReturnValue.memoryHeight, width: cJReturnValue.memoryWidth } }
      this.pixelMap = await image.createPixelMap(validReturnValue, opts)
    }else{
      let decoderTs = await AvifDecoderTS.create(uri)
      if(!decoderTs){
        return
      }
      let cjreturnValue =await decoderTs.nextFrameffi(100,100)
      let validReturnValue = cjreturnValue.color ?? new Uint8Array()
      if(cjreturnValue.color){
        let array = new Uint8Array(cjreturnValue.color)
        hilog.error(0,"aviflog","数据"+array.length)
      }
      let opts: image.InitializationOptions =
        { editable: true, pixelFormat: 3, size: { height: 100, width: 100 } }
      this.pixelMap = await image.createPixelMap(validReturnValue, opts)
      decoderTs.release()
    }
  }

  aboutToDisappear(): void {
    if (this.pixelMap) {
      this.pixelMap.release()
    }
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          Image(this.pixelMap)
            .objectFit(ImageFit.Fill)
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}



```

执行结果如下：
图片在手机上成功展示。

```shell
正常显示图片
```



## 约束与限制

在下述版本验证通过:

| 编号 | 依赖构建工具                                 | 版本号    |
| ---- | -------------------------------------------- | --------- |
| 1    | **DevEco Studio 6.1.1 Release**              | 6.1.1.280 |
| 2    | **cjc**                                      | v1.1.3    |
| 3    | **DevEco Studio-Cangjie Plugin 6.1.1 Beta1** | 6.1.1.280 |
| 4    | **compatibility-sdk-6.1.1.280**              | 6.1.1.280 |
     
  avif依赖三方库：
  
  | 编号 | 依赖三方库         | 版本号      |
  |----|---------------|----------|
  | 1  | stdx          | v1.1.3.1 |

## 开源协议

本项目基于 [Apache-2.0 License](https://gitcode.com/Cangjie-TPC/avif-ffi/blob/avif-ffi_hybrid-cangjie-plugin-5.1.1_xc/LICENSE)，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。