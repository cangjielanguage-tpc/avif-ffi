import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avif_hybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page14Test {
  @State avifImageModel1: AvifImageModel = new AvifImageModel()


  @State ready: boolean = false
  @State isABLoad: boolean = false

  url1 = 'https://pic1.iqiyipic.com/image/20240622/65/fc/v_177081820_m_601_m1_592_333.avif'

  async aboutToAppear(): Promise<void> {

    this.avifImageModel1.setUri(this.url1).setImageViewWidth('600px').setImageViewHeight('400px')

    this.ready = true
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          if (this.ready) {
            AvifViewTS({ model: this.avifImageModel1, useCangjieComponent: this.isABLoad})
          }
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}
