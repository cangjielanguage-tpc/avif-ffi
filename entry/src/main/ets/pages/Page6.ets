import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avif_hybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page6Test {
  avifImageModel2: AvifImageModel = new AvifImageModel()
  avifImageModel3: AvifImageModel = new AvifImageModel()
  avifImageModel5: AvifImageModel = new AvifImageModel()
  avifImageModel6: AvifImageModel = new AvifImageModel()
  avifImageModel8: AvifImageModel = new AvifImageModel()
  avifImageModel9: AvifImageModel = new AvifImageModel()
  avifImageModel10: AvifImageModel = new AvifImageModel()
  avifImageModel11: AvifImageModel = new AvifImageModel()
  avifImageModel12: AvifImageModel = new AvifImageModel()
  avifImageModel13: AvifImageModel = new AvifImageModel()
  @State ready: boolean = false

  completeCallback(status: number): void {
    hilog.error(1, "1", 'status='+status)
  }

  async aboutToAppear(): Promise<void> {
      this.avifImageModel2.setUri("media://a2").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('50%').setToprightBorderRadius('50%').setBottomleftBorderRadius('50%').setBottomrightBorderRadius('50%').setOnComplete(this.completeCallback).setDraggable(false)
      this.avifImageModel3.setUri("media://a3").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp').setOnComplete(this.completeCallback).setDraggable(true)
      this.avifImageModel5.setUri("media://a5").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp').setOnComplete(this.completeCallback).setDraggable(true)
      this.avifImageModel6.setUri("media://a6").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp').setOnComplete(this.completeCallback).setDraggable(true)
      this.avifImageModel8.setUri("media://a8").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp').setOnComplete(this.completeCallback).setDraggable(true)
      this.avifImageModel9.setUri("media://a9").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp').setOnComplete(this.completeCallback).setDraggable(false)
      this.avifImageModel10.setUri("media://a10").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp').setOnComplete(this.completeCallback).setDraggable(true)
      this.avifImageModel11.setUri("media://a11").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp').setOnComplete(this.completeCallback).setDraggable(true)
      this.avifImageModel12.setUri("media://a12").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp').setOnComplete(this.completeCallback).setDraggable(true)
      this.avifImageModel13.setUri("media://a13").setImageViewWidth('600px').setImageViewHeight('400px').setTopleftBorderRadius('20vp').setToprightBorderRadius('20vp').setBottomleftBorderRadius('20vp').setBottomrightBorderRadius('20vp').setOnComplete(this.completeCallback).setDraggable(true)
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

