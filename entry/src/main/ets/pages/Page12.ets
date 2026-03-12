import { AvifDecoderTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';
import { CJReturnValue } from '@cangjie-tpc/avifhybrid/src/main/cangjie/types/libohos_app_cangjie_avif4hybrid/Index';

@Entry
@Component
struct page12Test {
  // @State pixelMap: PixelMap | undefined = undefined
  // @State mWidth: number = 0
  // @State mHeight: number = 0
  // @State isLoop:boolean = true
  //
  // async aboutToAppear(): Promise<void> {
  //   let decoderTs = new AvifDecoderTS()
  //   //这是resources/base/meida下的文件
  //   //decoderTs.create("media://a22")
  //   //这是resources/rawfile下的文件
  //   //decoderTs.create("rawfile://a23.avif")
  //   //这是网络图片
  //   decoderTs.create("https://pic8.iqiyipic.com/animated/20250806/3f/9e/5830642737316600_1754449128430_720_405.avif")
  //   this.mWidth = decoderTs.getWidth()
  //   this.mHeight = decoderTs.getHeight()
  //   let count =  decoderTs.getFrameCount()
  //   let duritionTime:Array<number>|undefined = decoderTs.getFrameDurations()
  //   if(duritionTime){
  //       while (this.isLoop){
  //         for (let i = 0; i < count; i++) {
  //           let cjreturnValue: CJReturnValue = decoderTs.nthFrameffi(i,this.mWidth, this.mHeight)
  //           let validReturnValue = cjreturnValue.color ?? new Uint8Array()
  //           let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: this.mHeight, width: this.mWidth } }
  //           this.pixelMap = await image.createPixelMap(validReturnValue, opts)
  //           setTimeout(() => {
  //           }, duritionTime[i]);
  //         }
  //      }
  //   }
  //   decoderTs.release()
  // }
  //
  // aboutToDisappear(): void {
  //   if (this.pixelMap) {
  //     this.pixelMap.release()
  //   }
  // }
  //
  build() {
    Row() {
      Scroll() {
        Column() {
          // Image(this.pixelMap)
          //   .width(this.mWidth)
          //   .height(this.mHeight)
          //   .objectFit(ImageFit.Fill)
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}