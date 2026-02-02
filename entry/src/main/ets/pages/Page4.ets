import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page4Test {
  @State avifImageModel1: AvifImageModel = new AvifImageModel()
  @State avifImageModel2: AvifImageModel = new AvifImageModel()
  @State avifImageModel3: AvifImageModel = new AvifImageModel()
  @State avifImageModel4: AvifImageModel = new AvifImageModel()
  @State avifImageModel5: AvifImageModel = new AvifImageModel()

  @State ready: boolean = false

  url1 = 'https://pic8.iqiyipic.com/animated/20250806/3f/9e/5830642737316600_1754449128430_720_405.avif'
  url2 = 'https://pic3.iqiyipic.com/animated/20240214/9d/29/6955279253853500_1707880039133_592_333.avif'
  url3 = 'http://pic7.iqiyipic.com/animated/20250806/3b/1b/4816705105837600_1754459217014_592_333.avif'
  url4 = 'https://dx-pic6.iqiyipic.com/animated/20250722/61/cd/3079213879679200_1753185705381_592_333.avif'
  url5 = 'https://pic3.iqiyipic.com/animated/20250805/d7/17/3281359673308700_1754393441564_592_333.avif'

  async aboutToAppear(): Promise<void> {




      this.avifImageModel1.setUri(this.url1)

      this.avifImageModel2.setUri(this.url2)

      this.avifImageModel3.setUri(this.url3)

      this.avifImageModel4.setUri(this.url4)

      this.avifImageModel5.setUri(this.url5)

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

          }
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

