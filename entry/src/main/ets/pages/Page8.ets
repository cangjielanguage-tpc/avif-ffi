import { AvifDecoderTS, CjCacheCheckTS } from '@cangjie-tpc/avifhybrid';
import { image } from '@kit.ImageKit';
import { CJReturnValue } from '@cangjie-tpc/avifhybrid/src/main/cangjie/types/libohos_app_cangjie_avif4hybrid/Index';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page8Test {
  @State pixelMap: PixelMap | undefined = undefined
  @State mWidth: number = 0
  @State mHeight: number = 0



  async aboutToAppear(): Promise<void> {
    let uri = "https://pic1.iqiyipic.com/image/20240622/65/fc/v_177081820_m_601_m1_592_333.avif"
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
      const decodeRes = await decoderTs.create(uri)
      this.mWidth = decoderTs.getWidth()
      this.mHeight = decoderTs.getHeight()
      let cjreturnValue: CJReturnValue = await decoderTs.nextFrameffi(0,0)
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

