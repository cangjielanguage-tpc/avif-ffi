import { AvifDecoderTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';

@Entry
@Component
struct page9Test {
  @State pixelMap: PixelMap | undefined = undefined
  @State mWidth: number = 0
  @State mHeight: number = 0

  async aboutToAppear(): Promise<void> {
    let decoderTs = new AvifDecoderTS()
    decoderTs.create("media://a24")
    this.mWidth = decoderTs.getWidth()
    this.mHeight = decoderTs.getHeight()
    let cjreturnValue = decoderTs.nthFrameffi(3, this.mWidth, this.mHeight)
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
            .onClick((event: ClickEvent) => {
            })
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

