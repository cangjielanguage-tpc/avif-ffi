import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page6Test {
  @State avifImageModel2: AvifImageModel = new AvifImageModel()
  @State avifImageModel3: AvifImageModel = new AvifImageModel()
  @State avifImageModel5: AvifImageModel = new AvifImageModel()
  @State avifImageModel6: AvifImageModel = new AvifImageModel()
  @State avifImageModel8: AvifImageModel = new AvifImageModel()

  @State ready: boolean = false

  async aboutToAppear(): Promise<void> {

      this.avifImageModel2.setUri("media://a2").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel3.setUri("media://a3").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel5.setUri("media://a5").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel6.setUri("media://a6").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

      this.avifImageModel8.setUri("media://a8").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp')

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

          }
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

