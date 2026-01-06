import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page11Test {
  avifImageModel2: AvifImageModel = new AvifImageModel()
  avifImageModel22: AvifImageModel = new AvifImageModel()
  @State ready: boolean = false

  completeCallback(status: number): void {
    hilog.error(1, "1", 'complete')
  }

  async aboutToAppear(): Promise<void> {
    const res2 = $r("app.media.a2");
    const res22 = $r("app.media.a22");


    let array2 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res2.id)
    let array22 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res22.id)


    if (array2) {
      this.avifImageModel2.setImageBuffer(array2)
        .setImageViewWidth('600px')
        .setImageViewHeight('400px')
        .setTopleftBorderRadius('20vp')
        .setToprightBorderRadius('20vp')
        .setBottomleftBorderRadius('20vp')
        .setBottomrightBorderRadius('20vp')
        .setOnComplete(this.completeCallback)
        .setDraggable(false)
    }
    if (array22) {
      this.avifImageModel22.setImageBuffer(array22)
        .setImageViewWidth('600px')
        .setImageViewHeight('400px')
        .setTopleftBorderRadius('20vp')
        .setToprightBorderRadius('20vp')
        .setBottomleftBorderRadius('20vp')
        .setBottomrightBorderRadius('20vp')
        .setOnComplete(this.completeCallback)
        .setDraggable(true)
    }
    this.ready = true
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          if (this.ready) {
            AvifViewTS({ model: this.avifImageModel2 })
            AvifViewTS({ model: this.avifImageModel22 })
          }
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

