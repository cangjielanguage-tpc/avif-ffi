import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page3Test {
  @State avifImageModel9: AvifImageModel = new AvifImageModel()
  @State avifImageModel10: AvifImageModel = new AvifImageModel()
  @State avifImageModel11: AvifImageModel = new AvifImageModel()
  @State avifImageModel12: AvifImageModel = new AvifImageModel()
  @State avifImageModel13: AvifImageModel = new AvifImageModel()

  @State ready: boolean = false


  async aboutToAppear(): Promise<void> {


      this.avifImageModel9.setUri("media://a9")

      this.avifImageModel10.setUri("media://a10")

      this.avifImageModel11.setUri("media://a11")

      this.avifImageModel12.setUri("media://a12")

      this.avifImageModel13.setUri("media://a13")

    this.ready = true
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          if (this.ready) {
            AvifViewTS({ model: this.avifImageModel9 })
            AvifViewTS({ model: this.avifImageModel10 })
            AvifViewTS({ model: this.avifImageModel11 })
            AvifViewTS({ model: this.avifImageModel12 })
            AvifViewTS({ model: this.avifImageModel13 })

          }
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

