<div align="center">
<h1>avif4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>


## 介绍

avif4cj是一个对avif图片进行解码的仓颉库，解码后图片可以显示在控件上


### 特性

本项目参考开源库libavif开发

- 🚀 支持avif图片解码。



### 源码目录

```shell
├── README.md                                 #整体介绍
├── doc                                       #文档目录
│   └── feature_api.md                        #API接口文档
├── avifso                                    #C源码目录 
├── libavif4cj                                #仓颉源码目录 
├── entry                                     #示例目录
└── hvigor                                    #构建工具目录
```

### 接口说明

主要类和函数接口说明详见 [API](./doc/feature_api.md)


## 使用说明

### 编译构建

描述具体的编译过程：

```shell
    1.先通过命令把代码下载下来,
      git clone -b 具体分支名 https://gitcode.com/Cangjie-TPC/avif4cj.git
          
    2.选择avifso模块,点击Build菜单,然后点击 Make Module 'avifso' 等待编译完成
    
    3.选择libavif4cj模块,点击Build菜单,然后点击 Make Module 'libavif4cj' 等待编译完成,项目则编译成功
    
```

### 功能示例

#### 1. 把avif4cj作为三方库依赖引入

```cj
用户如何在自己项目里引入avif4cj，具体步骤如下：
1. 在自己项目的根目录下,建一个thirdparty目录,然后通过git命令,把自己需要的ijk分支拉下来,比如
   git clone -b 分支名  https://gitcode.com/Cangjie-TPC/avif4cj.git
2. 把 thirdparty文件下的avif4cj项目用deveco编译通过，方法如上面的编译构建
3. 在自己项目的根目录的build-profile.json5文件里的modules节点下添加
    {
      "name": "libavif4cj",
      "srcPath": "./thirdparty/avif4cj/libavif4cj"
    },
    {
      "name": "avifso",
      "srcPath": "./thirdparty/avif4cj/avifso"
    }
   把avif4cj库的两个依赖变为modeule依赖形式.然后同步项目
4. 在自己项目的enrty里的oh-package.json5里的dependencies里加上 "libavif4cj": "file:../thirdparty/avif4cj/libavif4cj",然后同步项目
    "dependencies": {
    "libavif4cj": "file:../thirdparty/avif4cj/libavif4cj"
  }
   项目即依赖成功
```


#### 2. 在项目中显示avif图片
功能示例描述: 加载一个本地的rawfile下的avif图片。

示例代码如下：
```cangjie
package ohos_app_cangjie_entry

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*
import libavif4cj.*
import ohos.resource_manager.ResourceManager
import ohos.image.PixelMap
import ohos.image.InitializationOptions
import ohos.image.createPixelMap
import ohos.image.PixelMapFormat
import ohos.image.Size



@Entry
@Component
class EntryView {
    let size: Size = Size(width: 600, height: 400)
    let opts: InitializationOptions = InitializationOptions(size: size)
    let color: Array<UInt8> = Array<UInt8>(600 * 400 * 4, repeat: 0)
    @State
    var pixelMap: PixelMap = createPixelMap(color, opts)

    func build() {
        Row {
            Column {
                Image(pixelMap).width(600.px).height(400.px)

                Button("showpic")
                    .fontSize(20)
                    .onClick {
                        evt =>
                            let arr = getImageFromRawFile("a32.avif") //改avif图放在entry的src/main/resources/rawfile里面
                            let avif: AvifDecoder = AvifDecoder()
                            unsafe {
                                if (let Some(i) <- arr) {
                                    let address: Int64 = avif.createDecoderffi(i, 1)
                                    //创建pixelmap
                                    let mWidth = 600
                                    let mHeight = 400
                                    let colors: Array<UInt8> = Array<UInt8>(mWidth * mHeight * 4, repeat: 0)
                                    let pixelMap1 = createPixelMap(colors,InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888,
                                    size: Size(width: Int32(mWidth), height: Int32(mHeight))))
                                    avif.nextFrameffi(address, colors, pixelMap.getImageInfo())
                                    let size: Size = Size(width: 600, height: 400)
                                    let opts: InitializationOptions = InitializationOptions(PixelMapFormat.RGBA_8888,editable: true, pixelFormat: PixelMapFormat.RGBA_8888,
                                        size: Size(width: Int32(mWidth), height: Int32(mHeight)))
                                    pixelMap = createPixelMap(colors, opts)
                                }
                            }
                    }
            }.width(100.percent)
        }.height(100.percent)
    }

    private func getImageFromRawFile(rawFileName: String): ?Array<UInt8> {
        try {
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

DevEco Studio (5.1.1.823)
Cangjie Support Plugin 5.1.1.823
Cangjie Compiler: 1.0.1

## 开源协议

本项目基于 [View License](./LICENSE) ，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。