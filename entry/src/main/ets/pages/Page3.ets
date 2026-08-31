import { AvifDecoderTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
@Entry
@Component
struct page3Test {
  @State pixelMap: PixelMap | undefined = undefined
  @State mWidth: number = 0
  @State mHeight: number = 0

  async aboutToAppear(): Promise<void> {
    let decoderTs = new AvifDecoderTS()
    const createResult = await decoderTs.create("media://a24")
    if (!createResult.issuccess) {
      hilog.error(0, "aviflog", `创建解码器失败，code=${createResult.code}，message=${createResult.codeMessage}`)
      decoderTs.release()
      return
    }
    this.mWidth = decoderTs.getWidth()
    this.mHeight = decoderTs.getHeight()
    let cjreturnValue = await decoderTs.nthFrameffi(3, this.mWidth, this.mHeight)
    if (!cjreturnValue.issuccess) {
      console.error(`解码指定帧失败，code=${cjreturnValue.code}，message=${cjreturnValue.codeMessage}`)
      decoderTs.release()
      return
    }
    let validReturnValue:ArrayBuffer = cjreturnValue.color ?? new ArrayBuffer(0)
    let opts: image.InitializationOptions =
      { editable: true, pixelFormat: 3, size: { height: this.mHeight, width: this.mWidth } }
    this.pixelMap = await image.createPixelMap(validReturnValue, opts)
    decoderTs.release()
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
            .onClick((event: ClickEvent) => {
            })
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

