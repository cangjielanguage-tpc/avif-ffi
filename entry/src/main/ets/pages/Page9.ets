import { AvifViewTS, AvifImageModel, CJReturnValueTS } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';
import {AvifDecoderTS,CJInfoTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';

@Entry
@Component
struct page9Test {

  @State ready: boolean = false
  @State pixelMap: PixelMap | string | Resource | ImageContent | undefined = ImageContent.EMPTY
  @State mWidth: number = 0
  @State mHeight: number  = 0


//   const color: ArrayBuffer = new ArrayBuffer(num); //96为需要创建的像素buffer大小，取值为：height * width *4
//   let opts: image.InitializationOptions = {
//   editable: true, pixelFormat: 3, size: {
//     height: 4, width: 6
//   }
// }
//   let pixelmap: PixelMap = await image.createPixelMap(color, opts)

  async aboutToAppear(): Promise<void> {
    const res2 = $r("app.media.a24");
    let array2 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res2.id)
    const validData2 = array2 ?? new Uint8Array(); // 兜底空的 Uint8Array
    let decoderTs = new AvifDecoderTS()
    decoderTs.create(validData2)
    this.mWidth = decoderTs.getWidth()
    this.mHeight = decoderTs.getHeight()
    let cjreturnValue = decoderTs.nthFrameffi(3,this.mWidth,this.mHeight)
    let validReturnValue = cjreturnValue.color?? new Uint8Array()
    let opts: image.InitializationOptions = {editable: true,pixelFormat: 3,size:{height:this.mHeight,width:this.mWidth}}
    this.pixelMap = await image.createPixelMap(validReturnValue, opts)
    this.ready = true
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          if (this.ready) {
            Image(this.pixelMap)
              .width(this.mWidth)
              .height(this.mHeight)
              .objectFit(ImageFit.Fill)
              .onClick((event: ClickEvent) => {
              })
          }
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

