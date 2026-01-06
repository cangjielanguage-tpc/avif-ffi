import { NodeController, FrameNode } from '@kit.ArkUI';
import { requireCJLib } from 'libark_interop_loader.so'
import { CustomLib, CJAvifImageModel,CJCjinfo,CJAvifDecoder,CJReturnValue } from 'libohos_app_cangjie_avif4hybrid.so';

export const global_customLib: CustomLib = requireCJLib("libohos_app_cangjie_avif4hybrid.so") as CustomLib


class CJNodeController extends NodeController {
  rootNode?: FrameNode = undefined
  model?: CJAvifImageModel

  constructor(model?: CJAvifImageModel) {
    super()
    this.model = model
  }

  makeNode(ctx: UIContext): FrameNode | null {
    if (this.rootNode === undefined) {
      this.rootNode = new FrameNode(ctx)
      global_customLib.getLoadCJPage(this.model)
    }
    return this.rootNode
  }
}


@Component
export struct AvifViewTS {
  private avifImageNode: CJNodeController | null = null
  @State model?: AvifImageModel = undefined

  async aboutToAppear(): Promise<void> {
    this.avifImageNode = new CJNodeController(await this.getModel())
  }

  build() {
    NodeContainer(this.avifImageNode)
  }

  async getModel(): Promise<CJAvifImageModel> {
    let cjAvifImageModel: CJAvifImageModel = new global_customLib.CJAvifImageModel()
    if (this.model !== undefined) {
      if (this.model.imageBuffer !== undefined) {
        cjAvifImageModel.setImageBuffer(this.model.imageBuffer)
      }
      if (this.model.imagePicWidth > 0) {
        cjAvifImageModel.setImagePicWidth(this.model.imagePicWidth)
      }
      if (this.model.imagePicHeight > 0) {
        cjAvifImageModel.setImagePicHeight(this.model.imagePicHeight)
      }
      if (this.model.imageViewWidth != '' ) {
        cjAvifImageModel.setImageViewWidth(this.model.imageViewWidth)
      }
      if (this.model.imageViewHeight != '' ) {
        cjAvifImageModel.setImageViewHeight(this.model.imageViewHeight)
      }
      if (this.model.imageFit != '') {
        cjAvifImageModel.setImageFit(this.model.imageFit)
      }
      cjAvifImageModel.setDraggable(this.model.isDraggable)
      if (this.model.topleftBorderRadius != '' ) {
        cjAvifImageModel.setTopleftBorderRadius(this.model.topleftBorderRadius)
      }
      if (this.model.toprightBorderRadius != '' ) {
        cjAvifImageModel.setToprightBorderRadius(this.model.toprightBorderRadius)
      }
      if (this.model.bottomleftBorderRadius != '' ) {
        cjAvifImageModel.setBottomleftBorderRadius(this.model.bottomleftBorderRadius)
      }
      if (this.model.bottomrightBorderRadius != '' ) {
        cjAvifImageModel.setBottomrightBorderRadius(this.model.bottomrightBorderRadius)
      }
      if (this.model.onCompleteCallback !== undefined) {
        cjAvifImageModel.setCompleteCallback(this.model.onCompleteCallback)
      }
    }
    return cjAvifImageModel
  }
}



export class AvifImageModel {

  imageBuffer?: Uint8Array = undefined
  imagePicWidth: number = 0
  imagePicHeight: number = 0
  imageViewWidth: string = '100%'
  imageViewHeight: string = '100%'
  imageFit: string = 'contain'
  isDraggable: boolean = false
  topleftBorderRadius: string = '0vp'
  toprightBorderRadius: string = '0vp'
  bottomleftBorderRadius: string = '0vp'
  bottomrightBorderRadius: string = '0vp'
  onCompleteCallback?: (loadingStatus: number) => void = undefined

  public setImageBuffer(imageBuffer: Uint8Array): AvifImageModel {
    this.imageBuffer = imageBuffer
    return this
  }

  public setImagePicWidth(imagePicWidth: number): AvifImageModel {
    this.imagePicWidth = imagePicWidth
    return this
  }

  public setImagePicHeight(imagePicHeight: number): AvifImageModel {
    this.imagePicHeight = imagePicHeight
    return this
  }

  public setImageViewWidth(imageViewWidth: string): AvifImageModel {
    this.imageViewWidth = imageViewWidth
    return this

  }
  public setImageViewHeight(imageViewHeight: string): AvifImageModel {
    this.imageViewHeight = imageViewHeight
    return this
  }

  public setImageFit(imageFit: string): AvifImageModel {
    this.imageFit = imageFit
    return this
  }

  public  setDraggable(draggable: boolean): AvifImageModel {
    this.isDraggable = draggable
    return this
  }

  public  setTopleftBorderRadius(topleftBorderRadius: string): AvifImageModel {
    this.topleftBorderRadius = topleftBorderRadius
    return this
  }

  public  setToprightBorderRadius(toprightBorderRadius: string): AvifImageModel {
    this.toprightBorderRadius = toprightBorderRadius
    return this
  }

  public  setBottomleftBorderRadius(bottomleftBorderRadius: string): AvifImageModel {
    this.bottomleftBorderRadius = bottomleftBorderRadius
    return this
  }

  public  setBottomrightBorderRadius(bottomrightBorderRadius: string): AvifImageModel {
    this.bottomrightBorderRadius = bottomrightBorderRadius
    return this
  }

  public setOnComplete(callback: (loadingStatus: number) => void): AvifImageModel {
    this.onCompleteCallback = callback
    return this
  }
}

export class AvifDecoderTS{

  cjAvifDecoder: CJAvifDecoder = new global_customLib.CJAvifDecoder()

  public create(encoded:Uint8Array):CJAvifDecoder|undefined{
      return this.cjAvifDecoder.create(encoded)
    }

  public createWithThread(encoded:Uint8Array, threads: number):CJAvifDecoder|undefined{
      return this.cjAvifDecoder.createWithThread(encoded,threads)
  }

  public getWidth():number{
    return this.cjAvifDecoder.getWidth()
  }

  public getHeight():number{
    return this.cjAvifDecoder.getHeight()
  }

  public getDepth():number{
    return this.cjAvifDecoder.getDepth()
  }

  public getAlphaPresent():boolean{
    return this.cjAvifDecoder.getAlphaPresent()
  }

  public getFrameCount():number{
    return this.cjAvifDecoder.getFrameCount()
  }

  public getRepetitionCount():number{
    return this.cjAvifDecoder.getRepetitionCount()
  }

  public getFrameDurations(): Array<number> | undefined{
    return this.cjAvifDecoder.getFrameDurations()
  }

  public isAvifImageffi(encoded: Uint8Array): number{
    return this.cjAvifDecoder.isAvifImageffi(encoded)
  }

  public getInfoffi(encoded: Uint8Array): CJCjinfo | undefined{
    return this.cjAvifDecoder.getInfoffi(encoded)
  }

  public nextFrameIndexffi(): number{
    return this.cjAvifDecoder.nextFrameIndexffi()
  }

  public nextFrameffi(imageWidth: number, imageHeight: number): CJReturnValue{
    return this.cjAvifDecoder.nextFrameffi(imageWidth,imageHeight)
  }

  public nthFrameffi(index: number, imageWidth: number, imageHeight: number): CJReturnValue{
    return this.cjAvifDecoder.nthFrameffi(index,imageWidth,imageHeight)
  }

  public decodeffi(encoded: Uint8Array, imageWidth: number, imageHeight: number): CJReturnValue{
    return this.cjAvifDecoder.decodeffi(encoded,imageWidth,imageHeight)
  }

  public release(): void{
    this.cjAvifDecoder.release()
  }

}