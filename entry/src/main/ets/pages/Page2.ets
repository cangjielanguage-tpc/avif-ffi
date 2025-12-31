import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct page2Test {
  @State avifImageModel2: AvifImageModel = new AvifImageModel()
  @State avifImageModel3: AvifImageModel = new AvifImageModel()
  @State avifImageModel5: AvifImageModel = new AvifImageModel()
  @State avifImageModel6: AvifImageModel = new AvifImageModel()
  @State avifImageModel8: AvifImageModel = new AvifImageModel()

  @State ready: boolean = false

  async aboutToAppear(): Promise<void> {
    const res2 = $r("app.media.a2");
    const res3 = $r("app.media.a3");
    const res5 = $r("app.media.a5");
    const res6 = $r("app.media.a6");
    const res8 = $r("app.media.a8");

    let array2 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res2.id)
    let array3 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res3.id)
    let array5 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res5.id)
    let array6 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res6.id)
    let array8 = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res8.id)

    if (array2) {
      this.avifImageModel2.setImageBuffer(array2)
      this.avifImageModel2.setImageViewWidth('600px')
      this.avifImageModel2.setImageViewHeight('400px')
    }
    if (array3) {
      this.avifImageModel3.setImageBuffer(array3)
      this.avifImageModel3.setImageViewWidth('600px')
      this.avifImageModel3.setImageViewHeight('400px')
    }
    if (array5) {
      this.avifImageModel5.setImageBuffer(array5)
      this.avifImageModel5.setImageViewWidth('600px')
      this.avifImageModel5.setImageViewHeight('400px')
    }
    if (array6) {
      this.avifImageModel6.setImageBuffer(array6)
      this.avifImageModel6.setImageViewWidth('600px')
      this.avifImageModel6.setImageViewHeight('400px')
    }
    if (array8) {
      this.avifImageModel8.setImageBuffer(array8)
      this.avifImageModel8.setImageViewWidth('600px')
      this.avifImageModel8.setImageViewHeight('400px')
    }
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

