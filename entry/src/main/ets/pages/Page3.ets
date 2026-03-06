import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page3Test {
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
  @State avifImageModel14: AvifImageModel = new AvifImageModel()
  @State avifImageModel15: AvifImageModel = new AvifImageModel()
  @State avifImageModel16: AvifImageModel = new AvifImageModel()
  @State avifImageModel17: AvifImageModel = new AvifImageModel()
  @State ready: boolean = false


  async aboutToAppear(): Promise<void> {

      this.avifImageModel2.setUri("media://a2")

      this.avifImageModel3.setUri("media://a3")

      this.avifImageModel5.setUri("media://a5")

      this.avifImageModel6.setUri("media://a6")

      this.avifImageModel8.setUri("media://a8")

      this.avifImageModel9.setUri("media://a9")

      this.avifImageModel10.setUri("media://a10")

      this.avifImageModel11.setUri("media://a11")

      this.avifImageModel12.setUri("media://a12")

      this.avifImageModel13.setUri("media://a13")

      this.avifImageModel14.setUri("media://a14")

      this.avifImageModel15.setUri("media://a15")

      this.avifImageModel16.setUri("media://a16")

      this.avifImageModel17.setUri("media://a17")

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
            AvifViewTS({ model: this.avifImageModel14 })
            AvifViewTS({ model: this.avifImageModel15 })
            AvifViewTS({ model: this.avifImageModel16 })
            AvifViewTS({ model: this.avifImageModel17 })
          }
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

