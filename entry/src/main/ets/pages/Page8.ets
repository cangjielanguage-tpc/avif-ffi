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

