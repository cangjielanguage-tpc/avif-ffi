import { router } from '@kit.ArkUI';

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
          Button("7. 设置图片解码尺寸")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(e => {
              // 点击动作触发该方法调用
              router.pushUrl({ url: 'pages/setSourceSize' })
            })
          Text("")// 宽度
            .width(10)
        }
        .width('100%')

        Row() {
          Text("")// 宽度
            .width(10)
          Button("8. 设置组件默认拖拽 Draggable")
            .height(50)// 高度
            .layoutWeight(1)// 容器尺寸确定时，元素与兄弟节点主轴布局尺寸按照权重进行分配，忽略本身尺寸设置仅在Row/Column/Flex布局中生效
            .fontColor(0xFFFFFFFF)// 文本颜色
            .backgroundColor(0xFFFF0000)// 背景颜色
            .margin({ top: 5, bottom: 5 })// 外边距
            .align(Alignment.Center)// 内容对齐方式
            .fontSize(14)// 字体大小
            .onClick(e => {
              // 点击动作触发该方法调用
              router.pushUrl({ url: 'pages/setDraggable' })
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