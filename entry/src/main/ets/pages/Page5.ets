import { AvifDecoderTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';
import { CJReturnValue } from '@cangjie-tpc/avifhybrid/src/main/cangjie/types/libohos_app_cangjie_avif4hybrid/Index';

@Entry
@Component
struct page5Test {
  @State pixelMap: PixelMap | undefined = undefined
  @State mWidth: number = 0
  @State mHeight: number = 0

  async aboutToAppear(): Promise<void> {
    let decoderTs = new AvifDecoderTS()
    decoderTs.create("https://pic1.iqiyipic.com/image/20240622/65/fc/v_177081820_m_601_m1_592_333.avif")
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

