import { AvifDecoderTS, CjCacheCheckTS, CJReturnValue } from '@cangjie-tpc/avif_hybrid';
import { image } from '@kit.ImageKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page12Test {
  @State pixelMap: PixelMap | undefined = undefined
  @State mWidth: number = 0
  @State mHeight: number = 0



  async aboutToAppear(): Promise<void> {
    let uri = "https://pic1.iqiyipic.com/image/20240622/65/fc/v_177081820_m_601_m1_592_333.avif"
    let cacheCheck = new CjCacheCheckTS()
    let cJReturnValue = cacheCheck.getMemoryCache(uri,100,100)
    if(cJReturnValue.issuccess){
      hilog.error(0,"aviflog","走的是内存缓存"+cJReturnValue.memoryHeight+"---"+cJReturnValue.memoryWidth)
      if(cJReturnValue.color){
        let array = new Uint8Array(cJReturnValue.color)
        hilog.error(0,"aviflog","走的是内存缓存"+array.length)
      }
      let validReturnValue = cJReturnValue.color ?? new Uint8Array()
      let opts: image.InitializationOptions =
        { editable: true, pixelFormat: 3, size: { height: cJReturnValue.memoryHeight, width: cJReturnValue.memoryWidth } }
      this.pixelMap = await image.createPixelMap(validReturnValue, opts)
    }else{
      let decoderTs = await AvifDecoderTS.create(uri)
      if(!decoderTs){
        return
      }
      let cjreturnValue: CJReturnValue =await decoderTs.nextFrameffi(100,100)
      let validReturnValue = cjreturnValue.color ?? new Uint8Array()
      if(cjreturnValue.color){
        let array = new Uint8Array(cjreturnValue.color)
        hilog.error(0,"aviflog","数据"+array.length)
      }
      let opts: image.InitializationOptions =
        { editable: true, pixelFormat: 3, size: { height: 100, width: 100 } }
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
            .objectFit(ImageFit.Fill)
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

