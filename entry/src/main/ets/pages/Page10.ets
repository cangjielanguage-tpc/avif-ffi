import { AvifDecoderTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';

@Entry
@Component
struct page10Test {
  @State pixelMap: PixelMap | undefined = undefined
  @State mWidth: number = 0
  @State mHeight: number = 0

  async aboutToAppear(): Promise<void> {
    const res2 = $r("app.media.a15");
    let array2 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res2.id)
    const validData2 = array2 ?? new Uint8Array(); // 兜底空的 Uint8Array
    let decoderTs = new AvifDecoderTS()
    decoderTs.create(validData2)
    this.mWidth = decoderTs.getWidth()
    this.mHeight = decoderTs.getHeight()
    let cjreturnValue = decoderTs.decodeffi(validData2, this.mWidth, this.mHeight)
    let validReturnValue = cjreturnValue.color ?? new Uint8Array()
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

        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

