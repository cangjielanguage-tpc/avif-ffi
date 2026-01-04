import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page3Test {
  @State avifImageModel22: AvifImageModel = new AvifImageModel()
  @State avifImageModel23: AvifImageModel = new AvifImageModel()
  @State avifImageModel24: AvifImageModel = new AvifImageModel()
  @State avifImageModel25: AvifImageModel = new AvifImageModel()
  @State avifImageModel26: AvifImageModel = new AvifImageModel()
  @State avifImageModelb4: AvifImageModel = new AvifImageModel()
  @State avifImageModelb5: AvifImageModel = new AvifImageModel()

  @State ready: boolean = false

  async aboutToAppear(): Promise<void> {
    const res22 = $r("app.media.a22");
    const res23 = $r("app.media.a23");
    const res24 = $r("app.media.a24");
    const res25 = $r("app.media.a25");
    const res26 = $r("app.media.a26");
    const resb4 = $r("app.media.b4");
    const resb5 = $r("app.media.b5");

    let array22 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res22.id)
    let array23 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res23.id)
    let array24 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res24.id)
    let array25 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res25.id)
    let array26 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res26.id)
    let arrayb4 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(resb4.id)
    let arrayb5 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(resb5.id)

    if (array22) {
      this.avifImageModel22.setImageBuffer(array22).setImageViewWidth('600px').setImageViewHeight('400px')
    }
    if (array23) {
      this.avifImageModel23.setImageBuffer(array23).setImageViewWidth('600px').setImageViewHeight('400px')
    }
    if (array24) {
      this.avifImageModel24.setImageBuffer(array24).setImageViewWidth('600px').setImageViewHeight('400px')
    }
    if (array25) {
      this.avifImageModel25.setImageBuffer(array25).setImageViewWidth('600px').setImageViewHeight('400px')
    }
    if (array26) {
      this.avifImageModel26.setImageBuffer(array26).setImageViewWidth('600px').setImageViewHeight('400px')
    }
    if (arrayb4) {
      this.avifImageModelb4.setImageBuffer(arrayb4).setImageViewWidth('600px').setImageViewHeight('400px')
    }
    if (arrayb5) {
      this.avifImageModelb5.setImageBuffer(arrayb5).setImageViewWidth('600px').setImageViewHeight('400px')
    }
    this.ready = true
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          if (this.ready) {
            AvifViewTS({ model: this.avifImageModel22 })
            AvifViewTS({ model: this.avifImageModel23 })
            AvifViewTS({ model: this.avifImageModel24 })
            AvifViewTS({ model: this.avifImageModel25 })
            AvifViewTS({ model: this.avifImageModel26 })
            AvifViewTS({ model: this.avifImageModelb4 })
            AvifViewTS({ model: this.avifImageModelb5 })
          }
        }
        .width('100%')
      }.scrollBar(BarState.Off)
      .height('100%')
    }
  }
}

