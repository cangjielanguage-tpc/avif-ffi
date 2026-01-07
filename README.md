<div align="center">
<h1>avif-ffi</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.5-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-86.2%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>


## 介绍

avif-ffi是一个对avif图片进行解码显示的仓颉库，解码后静态avif图片和动态avif图片都可以显示在控件上


### 特性

本项目参考开源库libavif开发

- 🚀 支持avif静态图片解码显示。
- 🚀 支持avif动态图片解码显示。
- 🚀 提供了自定义组件方式，方便用户使用。



### 源码目录

```shell
├── avif4cj                                   #源码目录 
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
    1.先通过命令把代码下载下来,比如下载develop分支
      git clone -b develop --depth 1 https://gitcode.com/Cangjie-TPC/avif-ffi.git
              
    2.选择avif4cj模块,点击Build菜单,然后点击 Make Module 'avif4cj' 等待编译完成,项目则编译成功
    
```

### 三方库导入使用

#### 1. 把avif-ffi作为三方库依赖引入

```cj
用户如何在自己项目里引入avif-ffi，具体步骤如下：

1. 通过git命令,把自己需要的avif-ffi分支拉下来,比如下载develop分支
   git clone -b develop --depth 1 https://gitcode.com/Cangjie-TPC/avif-ffi.git
   
2. 把avif-ffi项目用deveco编译通过，方法如上面的编译构建

3. 然后在avif4cj模块下的build/default/outputs/default/下找到avif4cj.har

4. 用户在自己应用的module下新建一个文件夹名为har,然后把avif4cj.har文件放入其中

5. 然后在用户module下的oh-package.json5下面添加依赖
   "dependencies": {
        "avif4cj": "file:./har/avif4cj.har"
   }
   
   或者在Terminal终端使用命令
   ohpm install  (指定到对应的har包路径) 回车执行 也会生成上面的依赖
   
   添加完后点击自动弹出的sync now同步
    
6. 同步完成后就可以在自己的代码文件里引用avif4cj里的类了
   import avif4cj.*
   
```


### 功能示例

#### 1. 在项目中显示avif图片

##### 1.1 用提供的api加载一个本地的rawfile下的avif图片。

示例代码如下：
```cangjie
package ohos_app_cangjie_entry

import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import avif4cj.*
import ohos.resource_manager.ResourceManager
import ohos.image.PixelMap
import ohos.image.InitializationOptions
import ohos.image.createPixelMap
import ohos.image.PixelMapFormat
import ohos.image.Size
import ohos.concurrency.launch
import ohos.base.*
import ohos.ability.getStageContext
import ohos.hilog.Hilog

@Entry
@Component
class EntryView {
    let size: Size = Size(width: 1, height: 1)
    let opts: InitializationOptions = InitializationOptions(size: size)
    let color: Array<UInt8> = Array<UInt8>(4, repeat: 0)
    @State
    var pixelMap: PixelMap = createPixelMap(color, opts)

    func build() {
        Row {
            Column {
                Image(pixelMap)
                    .width(600.px)
                    .height(400.px)
                    .objectFit(ImageFit.Contain)

                Button("showpic")
                    .fontSize(20)
                    .onClick {
                        evt =>
                            //需确保自己项目的raw下面有对应的文件
                            let arr = getImageFromRawFile("a52.avif")
                            if (let Some(i) <- arr) {
                                let avif: ?AvifDecoder = AvifDecoder.create(i)
                                if (let Some(j) <- avif) {
                                    //创建pixelmap
                                    spawn {
                                        let mWidth = j.getWidth()
                                        let mHeight = j.getHeight()
                                        let colors: Array<UInt8> = Array<UInt8>(mWidth * mHeight * 4, repeat: 0)
                                        j.nextFrameffi(colors, Int32(mWidth), Int32(mHeight))
                                        let size: Size = Size(width: Int32(mWidth), height: Int32(mHeight))
                                        let opts: InitializationOptions = InitializationOptions(editable: true,
                                            pixelFormat: PixelMapFormat.RGBA_8888,size: Size(width: Int32(mWidth), height: Int32(mHeight)))
                                        let tempPixelMap = createPixelMap(colors, opts)
                                        launch {
                                            pixelMap = tempPixelMap
                                        }
                                        j.release()
                                    }
                                }
                            }
                        }
            }.width(100.percent)
        }.height(100.percent)
    }

    private func getImageFromRawFile(rawFileName: String): ?Array<UInt8> {
        try {
            //globalAbilityContext为?AblityContext类型，自行提供
            let resourceManager = ResourceManager.getResourceManager(getStageContext(globalAbilityContext.getOrThrow()))
            let arr: Array<UInt8> = resourceManager.getRawFileContent(rawFileName)
            return arr
        } catch (e: Exception) {
            return None
        }
    }
    
    protected override func aboutToDisappear() {
        try{
            this.pixelMap.release()
        }catch (e:Exception){
           Hilog.error(0,"aviflog",e.toString())
        }
    }
}

```

执行结果如下：
图片在手机上成功展示。

```shell
正常显示图片
```


##### 1.2 用提供的自定义组件加载两个本地的rawfile下的avif图片,一个是静态图 一个是动态图

示例代码如下：
```cangjie

package ohos_app_cangjie_entry

import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.component.*
import ohos.base.*
import ohos.resource_manager.ResourceManager
import avif4cj.*
import ohos.ability.getStageContext

@Entry
@Component
class EntryView {

    var imageValue51:?Array<UInt8> = None
    var imageValue25:?Array<UInt8> = None

    protected override func aboutToAppear() {
        //需确保自己项目的raw下面有对应的文件
        imageValue51 = getImageFromRawFile("a51.avif") //静态图
        imageValue25 = getImageFromRawFile("a25.avif") //动态图
    }

    let scroller = Scroller()

    func build() {
        Scroll(this.scroller){
            Column(){
               /*
                * 参数 imageBuffer - avif文件的字节数组信息 必填
                * 参数 imageViewWidth - 图片显示控件的宽度 可缺省 默认值是 100.percent
                * 参数 imageViewHeight - 图片显示控件的高度 可缺省 默认值是 100.percent
                * 参数 imagePicWidth - 要显示的图片的宽度 单位是像素px 可缺省 默认值是图片原始宽度 
                * 参数 imagePicHeight - 要显示的图片的高度 单位是像素px 可缺省 默认值是图片原始高度 
                * 参数 imageFit - 图片和控件的对齐方式 可缺省 默认值是 ImageFit.Contain
                * 参数 isDraggable - 图片是否可拖拽 可缺省 默认值是 false
                * 参数 topleftBorderRadius - 图片的左上角的圆角弧度 可缺省 默认值是 0.vp
                * 参数 toprightBorderRadius - 图片的右上角的圆角弧度 可缺省 默认值是 0.vp
                * 参数 bottomleftBorderRadius - 图片的左下角的圆角弧度 可缺省 默认值是 0.vp
                * 参数 bottomrightBorderRadius - 图片的右下角的圆角弧度 可缺省 默认值是 0.vp
                * 参数 completeCallBack - 参数类型是 Option<(CJImageComplete)->Unit> 图片加载成功后的回调 可缺省 
                */
                AvifImage(imageBuffer:imageValue25,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:600,imagePicHeight:400,imageFit:ImageFit.None,
                topleftBorderRadius:20.vp,toprightBorderRadius:20.vp,bottomleftBorderRadius:20.vp,bottomrightBorderRadius:20.vp,
                completeCallBack:Option<(CJImageComplete)->Unit>.None,isDraggable:true)
                AvifImage(imageBuffer:imageValue51,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:600,imagePicHeight:400,imageFit:ImageFit.None,
                topleftBorderRadius:20.vp,toprightBorderRadius:20.vp,bottomleftBorderRadius:20.vp,bottomrightBorderRadius:20.vp,
                completeCallBack:Option<(CJImageComplete)->Unit>.None,isDraggable:true)
            }
        }
    }

    private func getImageFromRawFile(rawFileName: String): ?Array<UInt8> {
        try {
            //globalAbilityContext为?AblityContext类型，自行提供
            let resourceManager = ResourceManager.getResourceManager(getStageContext(globalAbilityContext.getOrThrow())) 
            let arr: Array<UInt8> = resourceManager.getRawFileContent(rawFileName)
            return arr
        } catch (e: Exception) {
            return None
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