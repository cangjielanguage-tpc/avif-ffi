<div align="center">
<h1>avif-ffi</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.1.0-brightgreen" style="display: inline-block;" />
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


##### 1.1 用提供的自定义组件加载两个本地的resources下的media下的avif图片,一个是静态图 一个是动态图

示例代码如下：
```ets
import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page11Test {
  avifImageModel2: AvifImageModel = new AvifImageModel()
  avifImageModel22: AvifImageModel = new AvifImageModel()
  @State ready: boolean = false

  completeCallback(status: number): void {
    hilog.error(1, "1", 'complete')
  }

  async aboutToAppear(): Promise<void> {
    const res2 = $r("app.media.a2");
    const res22 = $r("app.media.a22");


    let array2 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res2.id)
    let array22 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res22.id)


    if (array2) {
      this.avifImageModel2.setImageBuffer(array2)
        .setImageViewWidth('600px')
        .setImageViewHeight('400px')
        .setTopleftBorderRadius('20vp')
        .setToprightBorderRadius('20vp')
        .setBottomleftBorderRadius('20vp')
        .setBottomrightBorderRadius('20vp')
        .setOnComplete(this.completeCallback)
        .setDraggable(false)
    }
    if (array22) {
      this.avifImageModel22.setImageBuffer(array22)
        .setImageViewWidth('600px')
        .setImageViewHeight('400px')
        .setTopleftBorderRadius('20vp')
        .setToprightBorderRadius('20vp')
        .setBottomleftBorderRadius('20vp')
        .setBottomrightBorderRadius('20vp')
        .setOnComplete(this.completeCallback)
        .setDraggable(true)
    }
    this.ready = true
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          if (this.ready) {
            AvifViewTS({ model: this.avifImageModel2 })
            AvifViewTS({ model: this.avifImageModel22 })
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


##### 1.2 用提供的api加载一个本地的resources下的media下的avif图片。

示例代码如下：
```ets

import { AvifDecoderTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';
import { CJReturnValue } from '@cangjie-tpc/avifhybrid/src/main/cangjie/types/libohos_app_cangjie_avif4hybrid/Index';

@Entry
@Component
struct page8Test {
  @State pixelMap: PixelMap | undefined = undefined
  @State mWidth: number = 0
  @State mHeight: number = 0

  async aboutToAppear(): Promise<void> {
    const res2 = $r("app.media.a6");
    let array2 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res2.id)
    const validData2 = array2 ?? new Uint8Array(); 
    let decoderTs = new AvifDecoderTS()
    decoderTs.create(validData2)
    this.mWidth = decoderTs.getWidth()
    this.mHeight = decoderTs.getHeight()
    let cjreturnValue: CJReturnValue = decoderTs.nextFrameffi(this.mWidth, this.mHeight)
    let validReturnValue = cjreturnValue.color ?? new Uint8Array()
    let opts: image.InitializationOptions =
      { editable: true, pixelFormat: 3, size: { height: this.mHeight, width: this.mWidth } }
    this.pixelMap = await image.createPixelMap(validReturnValue, opts)
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


## 约束与限制

DevEco Studio 6.0.0 Release(6.0.0.875)

## 开源协议

本项目基于 [Apache-2.0 License](./LICENSE)，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。