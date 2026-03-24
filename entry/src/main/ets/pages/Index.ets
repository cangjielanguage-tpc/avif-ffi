import { router } from '@kit.ArkUI';
import {AvifDecoderTS } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  build() {
    Scroll() {
      Column() {
        Row() {
          Text("")// 宽度
            .width(10)
          Button("1. 展示1")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(e => {
              // 点击动作触发该方法调用
              router.pushUrl({ url: 'pages/Page1' })
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

        Row() {
          Text("")// 宽度
            .width(10)
          Button("2. 展示2")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(e => {
              // 点击动作触发该方法调用
              router.pushUrl({ url: 'pages/Page2' })
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

        Row() {
          Text("")// 宽度
            .width(10)
          Button("3. 展示3")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(e => {
              // 点击动作触发该方法调用
              router.pushUrl({ url: 'pages/Page3' })
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

        Row() {
          Text("")// 宽度
            .width(10)
          Button("4. 展示4")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(e => {
              // 点击动作触发该方法调用
              router.pushUrl({ url: 'pages/Page4' })
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

        Row() {
          Text("")// 宽度
            .width(10)
          Button("5. 展示5")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(e => {
              // 点击动作触发该方法调用
              router.pushUrl({ url: 'pages/Page5' })
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

        Row() {
          Text("")// 宽度
            .width(10)
          Button("6. 展示6")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(e => {
              // 点击动作触发该方法调用
              router.pushUrl({ url: 'pages/Page6' })
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

        Row() {
          Text("")// 宽度
            .width(10)
          Button("8. 点击事件")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(async e => {
              // 点击动作触发该方法调用
              let decoderTs = new AvifDecoderTS()
              let des = await decoderTs.create("media://cat")
              let isavif = decoderTs.isAvifImageffi()
              hilog.error(0,"test1",isavif.toString())
              decoderTs.release()
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

        Row() {
          Text("")// 宽度
            .width(10)
          Button("9. 点击事件")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(async e => {
              // 点击动作触发该方法调用
              let decoderTs = new AvifDecoderTS()
              let des = await decoderTs.createWithThread("media://a3",2)
              let isavif = decoderTs.isAvifImageffi()
              hilog.error(0,"test2",isavif.toString())
              decoderTs.release()
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

        Row() {
          Text("")// 宽度
            .width(10)
          Button("10. 点击事件")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(async e => {
              // 点击动作触发该方法调用
              let decoderTs = new AvifDecoderTS()
              let des = await decoderTs.create("media://2")
              let isavif = decoderTs.isAvifImageffi()
              hilog.error(0,"test3",isavif.toString())
              decoderTs.release()
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

        Row() {
          Text("")// 宽度
            .width(10)
          Button("11. 点击事件")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(async e => {
              // 点击动作触发该方法调用
              let decoderTs = new AvifDecoderTS()
              let des = await decoderTs.create("rawfile://a2.avif")
              let isavif = decoderTs.isAvifImageffi()
              hilog.error(0,"test4",isavif.toString())
              decoderTs.release()
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')


        Row() {
          Text("")// 宽度
            .width(10)
          Button("12. 点击事件")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(async e => {
              // 点击动作触发该方法调用
              let decoderTs = new AvifDecoderTS()
              let des = await decoderTs.create("media://a26")
              let width = decoderTs.getWidth()
              let height = decoderTs.getHeight()
              let depth = decoderTs.getDepth()
              let alphapresent = decoderTs.getAlphaPresent()
              let framecount = decoderTs.getFrameCount()
              let repetitionCount = decoderTs.getRepetitionCount()
              let duretionlist = decoderTs.getFrameDurations()
              hilog.error(0,"test11","width="+width+"  height="+height+" depth="+depth)
              hilog.error(0,"test11","alphapresent="+alphapresent+"  framecount="+framecount+" repetitionCount="+repetitionCount)
              hilog.error(0,"test11","duretionlist="+duretionlist)
              decoderTs.release()
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

        Row() {
          Text("")// 宽度
            .width(10)
          Button("14. 点击事件")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(async e => {
              // 点击动作触发该方法调用
              let decoderTs = new AvifDecoderTS()
              let des = await decoderTs.create("media://a2")
              let index1 = decoderTs.nextFrameIndexffi()
              hilog.error(0,"test14","index1="+index1)
              decoderTs.release()
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .scrollBar(BarState.Off)
  }
}