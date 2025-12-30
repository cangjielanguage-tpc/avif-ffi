import { AvifViewTS, AvifImageModel } from '@cangjie-tpc/avifhybrid';

@Entry
@Component
struct page1Test {
  @State avifImageModel: AvifImageModel = new AvifImageModel()
  @State ready: boolean = false

  async aboutToAppear(): Promise<void> {
    const res = $r("app.media.a6");
    let array = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(res.id)
    if (array) {
      this.avifImageModel.setImageBuffer(array)
    }
    this.ready = true
  }

  build() {
    Row() {
      Column() {
        if (this.ready) {
          AvifViewTS({ model: this.avifImageModel })
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

