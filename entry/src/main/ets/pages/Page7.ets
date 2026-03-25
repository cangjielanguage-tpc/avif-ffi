import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page7Test {
  avifImageModel1: AvifImageModel = new AvifImageModel()
  avifImageModel2: AvifImageModel = new AvifImageModel()
  avifImageModel3: AvifImageModel = new AvifImageModel()
  avifImageModel4: AvifImageModel = new AvifImageModel()
  avifImageModel5: AvifImageModel = new AvifImageModel()
  avifImageModel6: AvifImageModel = new AvifImageModel()

  @State ready: boolean = false

  completeCallback(status: number): void {
    hilog.error(1, "1", 'complete')
  }

  async aboutToAppear(): Promise<void> {

      this.avifImageModel1.setUri("https://pic1.iqiyipic.com/image/20240622/65/fc/v_177081820_m_601_m1_592_333.avif")
        .setImageViewWidth('600px')
        .setImageViewHeight('400px')
        .setTopleftBorderRadius('20vp')
        .setToprightBorderRadius('20vp')
        .setBottomleftBorderRadius('20vp')
        .setBottomrightBorderRadius('20vp')
        .setOnComplete(this.completeCallback)
        .setDraggable(false)

      this.avifImageModel2.setUri("https://pic8.iqiyipic.com/animated/20250806/3f/9e/5830642737316600_1754449128430_720_405.avif")
        .setImageViewWidth('600px')
        .setImageViewHeight('400px')
        .setTopleftBorderRadius('20vp')
        .setToprightBorderRadius('20vp')
        .setBottomleftBorderRadius('20vp')
        .setBottomrightBorderRadius('20vp')
        .setOnComplete(this.completeCallback)
        .setDraggable(true)

    this.avifImageModel3.setUri("media://a2")
      .setImageViewWidth('600px')
      .setImageViewHeight('400px')
      .setTopleftBorderRadius('20vp')
      .setToprightBorderRadius('20vp')
      .setBottomleftBorderRadius('20vp')
      .setBottomrightBorderRadius('20vp')
      .setOnComplete(this.completeCallback)
      .setDraggable(true)

    this.avifImageModel4.setUri("media://a22")
      .setImageViewWidth('600px')
      .setImageViewHeight('400px')
      .setTopleftBorderRadius('20vp')
      .setToprightBorderRadius('20vp')
      .setBottomleftBorderRadius('20vp')
      .setBottomrightBorderRadius('20vp')
      .setOnComplete(this.completeCallback)
      .setDraggable(true)

    this.avifImageModel5.setUri("rawfile://a3.avif")
      .setImageViewWidth('600px')
      .setImageViewHeight('400px')
      .setTopleftBorderRadius('20vp')
      .setToprightBorderRadius('20vp')
      .setBottomleftBorderRadius('20vp')
      .setBottomrightBorderRadius('20vp')
      .setOnComplete(this.completeCallback)
      .setDraggable(true)

    this.avifImageModel6.setUri("rawfile://a23.avif")
      .setImageViewWidth('600px')
      .setImageViewHeight('400px')
      .setTopleftBorderRadius('20vp')
      .setToprightBorderRadius('20vp')
      .setBottomleftBorderRadius('20vp')
      .setBottomrightBorderRadius('20vp')
      .setOnComplete(this.completeCallback)
      .setDraggable(true)

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
          }
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}