import { AvifDecoderTS,CjCacheCheckTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';
import { CJReturnValue } from '@cangjie-tpc/avifhybrid/src/main/cangjie/types/libohos_app_cangjie_avif4hybrid/Index';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page2Test {
  @State pixelMap: PixelMap | undefined = undefined
  @State mWidth: number = 0
  @State mHeight: number = 0

  async aboutToAppear(): Promise<void> {
    let uri = "media://a2"
    let cacheCheck = new CjCacheCheckTS()
    let cJReturnValue = cacheCheck.getMemoryCache(uri,0,0)
    if(cJReturnValue.issuccess){
      hilog.error(0,"aviflog","走的是内存缓存"+cJReturnValue.memoryHeight+"---"+cJReturnValue.memoryWidth)
      if(cJReturnValue.color){
        let array = new Uint8Array(cJReturnValue.color)
        hilog.error(0,"aviflog","走的是内存缓存"+array.length)
      }
      this.mWidth = cJReturnValue.memoryWidth
      this.mHeight = cJReturnValue.memoryHeight
      let validReturnValue = cJReturnValue.color ?? new Uint8Array()
      let opts: image.InitializationOptions =
        { editable: true, pixelFormat: 3, size: { height: cJReturnValue.memoryHeight, width: cJReturnValue.memoryWidth } }
      this.pixelMap = await image.createPixelMap(validReturnValue, opts)
    }else{
      let decoderTs = new AvifDecoderTS()
      const createResult = await decoderTs.create(uri)
      if (!createResult.issuccess) {
        hilog.error(0, "aviflog", `创建解码器失败，code=${createResult.code}，message=${createResult.codeMessage}`)
        decoderTs.release()
        return
      }
      this.mWidth = decoderTs.getWidth()
      this.mHeight = decoderTs.getHeight()
      let cjreturnValue: CJReturnValue = await decoderTs.nextFrameffi(0,0)
      if (!cjreturnValue.issuccess) {
        hilog.error(0, "aviflog", `解码当前帧失败，code=${cjreturnValue.code}，message=${cjreturnValue.codeMessage}`)
        decoderTs.release()
        return
      }
      let validReturnValue = cjreturnValue.color ?? new Uint8Array()
      if(cjreturnValue.color){
        let array = new Uint8Array(cjreturnValue.color)
        hilog.error(0,"aviflog","数据"+array.length)
      }
      let opts: image.InitializationOptions =
        { editable: true, pixelFormat: 3, size: { height: this.mHeight, width: this.mWidth } }
      this.pixelMap = await image.createPixelMap(validReturnValue, opts)
      decoderTs.release()
    }







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