<div align="center">
<h1>avif-ffi</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.5-brightgreen" style="display: inline-block;" />
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
├── avif4hybrid                               #源码目录 
├── doc                                       #文档目录
│   └── feature_api.md                        #API接口文档
├── entry                                     #示例目录
├── hvigor                                    #构建工具目录
├── CHANGELOG                                 #CHANGELOG文件
└── README.md                                 #整体介绍
```

### 接口说明

主要类和函数接口说明详见 [API](./doc/feature_api.md)


## 使用说明

### 编译构建

描述具体的编译过程：

```shell
    1.先通过命令把代码下载下来
      git clone -b 分支名 --depth 1 https://gitcode.com/Cangjie-TPC/avif-ffi.git
              
    2.在deveco里选择avif4hybrid模块,点击Build菜单,然后点击 Make Module 'avif4hybrid' 等待编译完成,项目则编译成功
    
```

### 三方库导入使用

#### 1. 把avif-ffi作为三方库依赖引入

```ets
用户如何在自己项目里引入avif-ffi，具体步骤如下：

1. 通过git命令,把自己需要的avif-ffi分支拉下来
   git clone -b 分支名 --depth 1 https://gitcode.com/Cangjie-TPC/avif-ffi.git
   
2. 把avif-ffi项目用deveco编译通过，方法如上面的编译构建

3. 然后在avif4hybrid模块下的build/default/outputs/default/下找到avif4hybrid.har

4. 用户在自己应用的module下新建一个文件夹名为har,然后把avif4hybrid.har文件放入其中

5. 然后在用户module下的oh-package.json5下面添加依赖
   "dependencies": {
        "@cangjie-tpc/avifhybrid": "file:./har/avif4hybrid.har"
   }
   添加完后点击自动弹出的sync now同步
    
6. 同步完成后就可以在自己的代码文件里引用avif4hybrid里的类了
   
```


### 功能示例

#### 1. 在项目中显示avif图片

##### 1.1 用提供的api加载一个url下的avif图片。内存图片为原图大小

示例代码如下：
```ets

import { AvifDecoderTS, CjCacheCheckTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';
import { CJReturnValue } from '@cangjie-tpc/avifhybrid/src/main/cangjie/types/libohos_app_cangjie_avif4hybrid/Index';
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
    //这里的0，0表示内存缓存的宽高为原图的宽高
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
      let decoderTs = new AvifDecoderTS()
      decoderTs.create(uri)
      this.mWidth = decoderTs.getWidth()
      this.mHeight = decoderTs.getHeight()
      //这里的0,0表示解码图片为原图宽高,如果要用到内存缓存，不要写实际的宽高，不然内存缓存的key会匹配不上
      let cjreturnValue: CJReturnValue = decoderTs.nextFrameffi(0,0)
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


##### 1.2 用提供的api加载一个url下的avif图片。内存图片为100*100

示例代码如下：
```ets

import { AvifDecoderTS, CjCacheCheckTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';
import { CJReturnValue } from '@cangjie-tpc/avifhybrid/src/main/cangjie/types/libohos_app_cangjie_avif4hybrid/Index';
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
    //这里的100，100表示内存缓存的宽高为100像素
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
      let decoderTs = new AvifDecoderTS()
      decoderTs.create(uri)
      //这里的100，100表示要解码成的图片内存大小，和上面的getMemoryCache匹配之后,即可找到对应的内存缓存
      let cjreturnValue: CJReturnValue = decoderTs.nextFrameffi(100,100)
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

DevEco Studio (5.1.1.851)

Cangjie Support Plugin 5.1.1.851

Cangjie Compiler: 1.0.5

## 开源协议

本项目基于 [Apache-2.0 License](./LICENSE)，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。