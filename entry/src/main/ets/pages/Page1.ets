import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page1Test {
  @State avifImageModel1: AvifImageModel = new AvifImageModel()
  @State avifImageModel2: AvifImageModel = new AvifImageModel()
  @State avifImageModel3: AvifImageModel = new AvifImageModel()
  @State avifImageModel4: AvifImageModel = new AvifImageModel()
  @State avifImageModel5: AvifImageModel = new AvifImageModel()
  @State avifImageModel6: AvifImageModel = new AvifImageModel()
  @State avifImageModel7: AvifImageModel = new AvifImageModel()
  @State avifImageModel8: AvifImageModel = new AvifImageModel()
  @State avifImageModel9: AvifImageModel = new AvifImageModel()
  @State avifImageModel10: AvifImageModel = new AvifImageModel()

  @State ready: boolean = false

  url1 = 'https://pic1.iqiyipic.com/image/20240622/65/fc/v_177081820_m_601_m1_592_333.avif'
  url2 = 'https://pic7.inter.ptqy.gitv.tv/image/20230620/40/02/v_173008524_m_601_284_160.avif'
  url3 = 'https://pic8.iqiyipic.com/image/20250701/ac/18/a_100628502_m_601_m2_579_772.avif'
  url4 = 'https://m.inter.ptqy.gitv.tv/u4/image/20250214/18/3c/pv_7438183095956800_d_601_592_333.avif'
  url5 = 'https://pic2.inter.ptqy.gitv.tv/image/20211129/8d/7c/a_502637340006_d_705_402_556.avif'
  url6 = 'https://pic9.iqiyipic.com/image/20240920/e5/43/a_100517696_m_601_m35_720_405.avif'
  url7 = 'https://pic7.inter.ptqy.gitv.tv/image/20231120/8a/0a/v_174528982_m_601_480_270.avif'
  url8 = 'https://pic7.iqiyipic.com/image/20250616/7c/3a/v_181993728_m_601_579_772.avif'
  url9 = 'https://m.inter.ptqy.gitv.tv/u4/image/20250411/95/b9/pv_3885390556513500_d_601_284_160.avif'
  url10 = 'https://m.inter.ptqy.gitv.tv/u2/image/20241001/34/21/pv_8048631305885900_d_616_0_720.avif'
  async aboutToAppear(): Promise<void> {




      this.avifImageModel1.setUri(this.url1).setImageViewWidth('600px').setImageViewHeight('400px')

      this.avifImageModel2.setUri(this.url2).setImageViewWidth('600px').setImageViewHeight('400px')

      this.avifImageModel3.setUri(this.url3).setImageViewWidth('600px').setImageViewHeight('400px')

      this.avifImageModel4.setUri(this.url4).setImageViewWidth('600px').setImageViewHeight('400px')

      this.avifImageModel5.setUri(this.url5).setImageViewWidth('600px').setImageViewHeight('400px')

      this.avifImageModel6.setUri(this.url6).setImageViewWidth('600px').setImageViewHeight('400px')

      this.avifImageModel7.setUri(this.url7).setImageViewWidth('600px').setImageViewHeight('400px')

      this.avifImageModel8.setUri(this.url8).setImageViewWidth('600px').setImageViewHeight('400px')

      this.avifImageModel9.setUri(this.url9).setImageViewWidth('600px').setImageViewHeight('400px')

      this.avifImageModel10.setUri(this.url10).setImageViewWidth('600px').setImageViewHeight('400px')

    this.ready = true
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          if (this.ready) {
            AvifViewTS({ model: this.avifImageModel1 })
            AvifViewTS({ model: this.avifImageModel2 })
            AvifViewTS({ model: this.avifImageModel3 })
            AvifViewTS({ model: this.avifImageModel4 })
            AvifViewTS({ model: this.avifImageModel5 })
            AvifViewTS({ model: this.avifImageModel6 })
            AvifViewTS({ model: this.avifImageModel7 })
            AvifViewTS({ model: this.avifImageModel8 })
            AvifViewTS({ model: this.avifImageModel9 })
            AvifViewTS({ model: this.avifImageModel10 })
          }
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

