import { NodeController, FrameNode } from '@kit.ArkUI';
import { requireCJLib } from 'libark_interop_loader.so'
import { CustomLib,CJAvifImageModel,CJAvifDecoder,CJReturnValue,CJCacheCheck} from 'libark_interop_api_avif.so';
import { hilog } from '@kit.PerformanceAnalysisKit';

export const global_customLib: CustomLib = requireCJLib("libavif4cj.so") as CustomLib

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
      if (this.model.uri != '') {
        cjAvifImageModel.setUri(this.model.uri)
        global_customLib.setGlobalContext(getContext(this))
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

  cjAvifDecoder: CJAvifDecoder = new global_customLib.CJAvifDecoder()
  decodeRes:boolean = true

  private constructor() {
    global_customLib.setGlobalContext(getContext(this))
  }


  public static async create(uri: string, threads: number=1): Promise<AvifDecoderTS|undefined> {
    let newDecoder = new AvifDecoderTS();
    newDecoder.decodeRes = await newDecoder.cjAvifDecoder.createWithThreadAsync(uri, threads);
    if (newDecoder.decodeRes) {
      return newDecoder;
    } else {
      newDecoder.release()
      return undefined
    }
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

  public static isAvifImageffi(buffer:ArrayBuffer): number {
     let newDecoder = new AvifDecoderTS();
    　return newDecoder.cjAvifDecoder.isAvifImageffi(buffer)
  }

  public nextFrameIndexffi(): number{
    if(this.decodeRes) {
       return this.cjAvifDecoder.nextFrameIndexffi()
    }else{
       return -1
    }
  }

  public async nextFrameffi(imageWidth: number, imageHeight: number): Promise<CJReturnValue>{
    if(this.decodeRes) {
      return  this.cjAvifDecoder.nextFrameffiAsync(imageWidth,imageHeight)
    }else{
      return  new global_customLib.CJReturnValue()
    }
  }

  public async nthFrameffi(index: number, imageWidth: number, imageHeight: number): Promise<CJReturnValue>{
    if(this.decodeRes) {
      return  this.cjAvifDecoder.nthFrameffiAsync(index,imageWidth,imageHeight)
    }else{
      return  new global_customLib.CJReturnValue()
    }
  }


  public release(): void{
    this.cjAvifDecoder.release()
  }

}

export class CjCacheCheckTS{

  cjCacheCheck: CJCacheCheck = new global_customLib.CJCacheCheck()

  constructor() {
    global_customLib.setGlobalContext(getContext(this))
  }

  public getMemoryCache(uri:string,imagePicWidth:number,imagePicHeight:number):CJReturnValue{
    return this.cjCacheCheck.getMemoryCache(uri,imagePicWidth,imagePicHeight)
  }

}

export class GlobalUtils {
   static setMemoryLruCacheTS(countSize:number,memorySize:number):void{
     global_customLib.setMemoryLruCache(countSize,memorySize)
  }

  static setFileLruCacheTS(countSize:number,memorySize:number):void{
    global_customLib.setFileLruCache(countSize,memorySize)
  }

  static setAvifContext(context:Context):void{
    global_customLib.setGlobalContext(context)
  }
}