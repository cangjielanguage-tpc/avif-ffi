import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avif_hybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page4Test {
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

  url1 = 'https://pic8.iqiyipic.com/animated/20250806/3f/9e/5830642737316600_1754449128430_720_405.avif'
  url2 = 'https://pic3.iqiyipic.com/animated/20240214/9d/29/6955279253853500_1707880039133_592_333.avif'
  url3 = 'http://pic7.iqiyipic.com/animated/20250806/3b/1b/4816705105837600_1754459217014_592_333.avif'
  url4 = 'https://dx-pic6.iqiyipic.com/animated/20250722/61/cd/3079213879679200_1753185705381_592_333.avif'
  url5 = 'https://pic3.iqiyipic.com/animated/20250805/d7/17/3281359673308700_1754393441564_592_333.avif'
  url6 = 'https://pic4.iqiyipic.com/animated/20250716/32/9e/7442996091200700_1752635135587_592_333.avif'
  url7 = 'https://pic2.iqiyipic.com/animated/20250715/a6/8b/6241351651272300_1752580846633_592_333.avif'
  url8 = 'https://pic1.inter.ptqy.gitv.tv/animated/20250717/14/84/3170660786337100_1752720287778_480_270.avif'
  url9 = 'https://dx-pic2.iqiyipic.com/animated/20250712/fa/dc/6543768175923600_1752286242275_592_333.avif'
  url10 = 'https://dx-pic9.iqiyipic.com/animated/20250805/a0/77/5594003812234100_1754392241318_592_333.avif'
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

