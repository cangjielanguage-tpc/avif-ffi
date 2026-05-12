import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avif_hybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page2Test {
  @State avifImageModel2: AvifImageModel = new AvifImageModel()
  @State avifImageModel3: AvifImageModel = new AvifImageModel()
  @State avifImageModel5: AvifImageModel = new AvifImageModel()
  @State avifImageModel6: AvifImageModel = new AvifImageModel()
  @State avifImageModel8: AvifImageModel = new AvifImageModel()
  @State avifImageModel9: AvifImageModel = new AvifImageModel()
  @State avifImageModel10: AvifImageModel = new AvifImageModel()
  @State avifImageModel11: AvifImageModel = new AvifImageModel()
  @State avifImageModel12: AvifImageModel = new AvifImageModel()
  @State avifImageModel13: AvifImageModel = new AvifImageModel()
  @State ready: boolean = false


  async aboutToAppear(): Promise<void> {


      this.avifImageModel2.setUri("rawfile://a2.avif")

      this.avifImageModel3.setUri("rawfile://a3.avif")

      this.avifImageModel5.setUri("rawfile://a5.avif")

      this.avifImageModel6.setUri("rawfile://a6.avif")

      this.avifImageModel8.setUri("rawfile://a8.avif")

      this.avifImageModel9.setUri("rawfile://a9.avif")

      this.avifImageModel10.setUri("rawfile://a10.avif")

      this.avifImageModel11.setUri("rawfile://a11.avif")

      this.avifImageModel12.setUri("rawfile://a12.avif")

      this.avifImageModel13.setUri("rawfile://a13.avif")

    this.ready = true
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          if (this.ready) {
            AvifViewTS({ model: this.avifImageModel2 })
            AvifViewTS({ model: this.avifImageModel3 })
            AvifViewTS({ model: this.avifImageModel5 })
            AvifViewTS({ model: this.avifImageModel6 })
            AvifViewTS({ model: this.avifImageModel8 })
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

