import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page5Test {
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

      this.avifImageModel2.setUri("media://a2").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel3.setUri("media://a3").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel5.setUri("media://a5").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel6.setUri("media://a6").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel8.setUri("media://a8").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel9.setUri("media://a9").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel10.setUri("media://a10").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel11.setUri("media://a11").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel12.setUri("media://a12").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel13.setUri("media://a13").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

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

