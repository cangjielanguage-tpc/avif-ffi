import { NodeController, FrameNode } from '@kit.ArkUI';
import { CJAvifImageModel,CJAvifDecoder,CJReturnValue,setGlobalContext,getLoadCJPage,setMemoryLruCache,setFileLruCache} from 'libohos_app_cangjie_avif4hybrid.so';

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
      getLoadCJPage(this.model)
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
    let cjAvifImageModel: CJAvifImageModel = new CJAvifImageModel()
    if (this.model !== undefined) {
      if (this.model.uri != '') {
        cjAvifImageModel.setUri(this.model.uri)
        setGlobalContext(getContext(this))
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

  uri:string = "" //网络图片 本地图片
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


  public setUri(uri: string): AvifImageModel {
    this.uri = uri
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

  cjAvifDecoder: CJAvifDecoder = new CJAvifDecoder()
  decodeRes:CJAvifDecoder|undefined = undefined

  constructor() {
    setGlobalContext(getContext(this))
  }

  public create(uri:string):CJAvifDecoder|undefined{
      this.decodeRes = this.cjAvifDecoder.create(uri)
      return this.decodeRes
  }

  public createWithThread(uri:string, threads: number):CJAvifDecoder|undefined{
      this.decodeRes = this.cjAvifDecoder.createWithThread(uri,threads)
      return this.decodeRes
  }

  public getWidth():number{
    if(this.decodeRes){
        return this.cjAvifDecoder.getWidth()
    }else{
        return 0
    }
  }

  public getHeight():number{
    if(this.decodeRes){
      return this.cjAvifDecoder.getHeight()
    }else{
      return 0
    }
  }

  public getDepth():number{
    if(this.decodeRes){
      return this.cjAvifDecoder.getDepth()
    }else{
      return 0
    }
  }

  public getAlphaPresent():boolean{
    if(this.decodeRes){
      return this.cjAvifDecoder.getAlphaPresent()
    }else{
      return false
    }
  }

  public getFrameCount():number{
    if(this.decodeRes){
      return this.cjAvifDecoder.getFrameCount()
    }else{
      return 0
    }
  }

  public getRepetitionCount():number{
    if(this.decodeRes) {
       return this.cjAvifDecoder.getRepetitionCount()
    }else{
       return 0
    }
  }

  public getFrameDurations(): Array<number> | undefined{
    if(this.decodeRes) {
        return this.cjAvifDecoder.getFrameDurations()
    }else{
        return undefined
    }
  }

  public isAvifImageffi(): number{
    if(this.decodeRes) {
        return this.cjAvifDecoder.isAvifImageffi()
    }else{
        return 0
    }
  }

  public nextFrameIndexffi(): number{
    if(this.decodeRes) {
       return this.cjAvifDecoder.nextFrameIndexffi()
    }else{
       return -1
    }
  }

  public nextFrameffi(imageWidth: number, imageHeight: number): CJReturnValue{
    if(this.decodeRes) {
      return this.cjAvifDecoder.nextFrameffi(imageWidth,imageHeight)
    }else{
      return new CJReturnValue()
    }
  }

  public nthFrameffi(index: number, imageWidth: number, imageHeight: number): CJReturnValue{
    if(this.decodeRes) {
       return this.cjAvifDecoder.nthFrameffi(index,imageWidth,imageHeight)
    }else{
       return new CJReturnValue()
    }
  }


  public release(): void{
    this.cjAvifDecoder.release()
  }

}

export class GlobalUtils {
   static setMemoryLruCacheTS(countSize:number,memorySize:number):void{
    setMemoryLruCache(countSize,memorySize)
  }

  static setFileLruCacheTS(countSize:number,memorySize:number):void{
    setFileLruCache(countSize,memorySize)
  }
}