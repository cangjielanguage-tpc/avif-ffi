import { NodeController, FrameNode, LengthMetrics, LengthUnit } from '@kit.ArkUI';
import { requireCJLib } from 'libark_interop_loader.so'
import { CustomLib,CJAvifImageModel,CJAvifDecoder,CJReturnValue,CJCacheCheck} from 'libark_interop_api_avif.so';
import { hilog } from '@kit.PerformanceAnalysisKit';

export let global_customLib: CustomLib | undefined = undefined

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
      if (global_customLib !== undefined) {
        global_customLib.getLoadCJPage(this.model)
      }
    }
    return this.rootNode
  }
}


@Component
export struct AvifViewTS {
  private avifImageNode: CJNodeController | null = null
  @State model?: AvifImageModel = undefined
  @Prop useCangjieComponent?: boolean = true
  @BuilderParam customContains: () => void = this.defaultTextBuilder

  @Builder
  defaultTextBuilder() {
    if (!this.useCangjieComponent) {
      Column() {
        Image($r('app.media.default'))
      }
    }
  }

  async aboutToAppear(): Promise<void> {
    if (this.useCangjieComponent === true) {
      if (global_customLib === undefined) {
        global_customLib = requireCJLib("libavif4cj.so") as CustomLib
      }
      this.avifImageNode = new CJNodeController(await this.getModel())
    } else {
      global_customLib = undefined
    }
  }

  build() {
    if (this.useCangjieComponent) {
      NodeContainer(this.avifImageNode)
    } else {
      this.customContains()
    }
  }

  async getModel(): Promise<CJAvifImageModel|undefined> {
    if (global_customLib === undefined) {
       return undefined
    }
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


function lengthToMetrics(len: Length): LengthMetrics {
  // 1. Resource 类型无法解析，返回 0vp
  if (typeof len !== 'number' && typeof len !== 'string') {
    return LengthMetrics.vp(0);
  }

  // 2. 数字 → 默认 vp
  if (typeof len === 'number') {
    return LengthMetrics.vp(len);
  }
  // 3. 字符串解析（如 "100px", "50%", "20fp"）
  const trimed = len.trim();
  const numStr = trimed.replace(/[a-zA-Z%]/g, '');
  const value = parseFloat(numStr);
  if (isNaN(value)) {
    return LengthMetrics.vp(0);
  }
  if (trimed.endsWith('px')) {
    return LengthMetrics.px(value);
  } else if (trimed.endsWith('fp')) {
    return LengthMetrics.fp(value);
  } else if (trimed.endsWith('lpx')) {
    return LengthMetrics.lpx(value);
  } else if (trimed.endsWith('%')) {
    return LengthMetrics.percent(value);
  } else {
    // 无单位 → 默认 vp
    return LengthMetrics.vp(value);
  }
}

function lengthToString(len: Length): string {
  const lm = lengthToMetrics(len);
  switch (lm.unit) {
    case LengthUnit.VP: return `${lm.value}vp`;
    case LengthUnit.PX: return `${lm.value}px`;
    case LengthUnit.FP: return `${lm.value}fp`;
    case LengthUnit.LPX: return `${lm.value}lpx`;
    case LengthUnit.PERCENT: return `${lm.value}%`;
    default: return `${lm.value}vp`;
  }
}

/**
 * 将 ImageFit 枚举值转为小写字符串
 * @param fit ImageFit 枚举值
 * @returns 小写字符串，如 "contain" / "cover" / "top_start"
 */
function imageFitToLowerString(fit: ImageFit): string {
  switch (fit) {
    case ImageFit.Contain: return "contain";
    case ImageFit.Cover: return "cover";
    case ImageFit.Auto: return "auto";
    case ImageFit.Fill: return "fill";
    case ImageFit.ScaleDown: return "scaledown";
    case ImageFit.None: return "none";
    case ImageFit.TOP_START: return "top_start";
    case ImageFit.TOP: return "top";
    case ImageFit.TOP_END: return "top_end";
    case ImageFit.START: return "start";
    case ImageFit.CENTER: return "center";
    case ImageFit.END: return "end";
    case ImageFit.BOTTOM_START: return "bottom_start";
    case ImageFit.BOTTOM: return "bottom";
    case ImageFit.BOTTOM_END: return "bottom_end";
    case ImageFit.MATRIX: return "matrix";
    default: return "contain";
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

  public setImageViewWidth(imageViewWidth: Length): AvifImageModel {
    this.imageViewWidth = lengthToString(imageViewWidth)
    return this

  }
  public setImageViewHeight(imageViewHeight: Length): AvifImageModel {
    this.imageViewHeight = lengthToString(imageViewHeight)
    return this
  }

  public setImageFit(imageFit: ImageFit): AvifImageModel {
    this.imageFit = imageFitToLowerString(imageFit)
    return this
  }

  public  setDraggable(draggable: boolean): AvifImageModel {
    this.isDraggable = draggable
    return this
  }

  public  setTopleftBorderRadius(topleftBorderRadius: Length): AvifImageModel {
    this.topleftBorderRadius = lengthToString(topleftBorderRadius)
    return this
  }

  public  setToprightBorderRadius(toprightBorderRadius: Length): AvifImageModel {
    this.toprightBorderRadius = lengthToString(toprightBorderRadius)
    return this
  }

  public  setBottomleftBorderRadius(bottomleftBorderRadius: Length): AvifImageModel {
    this.bottomleftBorderRadius = lengthToString(bottomleftBorderRadius)
    return this
  }

  public  setBottomrightBorderRadius(bottomrightBorderRadius: Length): AvifImageModel {
    this.bottomrightBorderRadius = lengthToString(bottomrightBorderRadius)
    return this
  }

  public setOnComplete(callback: (loadingStatus: number) => void): AvifImageModel {
    this.onCompleteCallback = callback
    return this
  }
}

export class AvifDecoderTS{

  cjAvifDecoder: CJAvifDecoder | undefined = undefined
  decodeRes:boolean = true

  private constructor() {
    if (global_customLib === undefined) {
      global_customLib = requireCJLib("libavif4cj.so") as CustomLib
    }
    this.cjAvifDecoder = new global_customLib.CJAvifDecoder()
    global_customLib.setGlobalContext(getContext(this))
  }


  public static async create(uri: string, threads: number=1): Promise<AvifDecoderTS|undefined> {
    let newDecoder = new AvifDecoderTS();
    if (newDecoder.cjAvifDecoder === undefined) {
      newDecoder.release()
      return undefined
    }
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
      return this.cjAvifDecoder?.getWidth() ?? 0
    }else{
      return 0
    }
  }

  public getHeight():number{
    if(this.decodeRes){
      return this.cjAvifDecoder?.getHeight() ?? 0
    }else{
      return 0
    }
  }

  public getDepth():number{
    if(this.decodeRes){
      return this.cjAvifDecoder?.getDepth() ?? 0
    }else{
      return 0
    }
  }

  public getAlphaPresent():boolean{
    if(this.decodeRes){
      return this.cjAvifDecoder?.getAlphaPresent() ?? false
    }else{
      return false
    }
  }

  public getFrameCount():number{
    if(this.decodeRes){
      return this.cjAvifDecoder?.getFrameCount() ?? 0
    }else{
      return 0
    }
  }

  public getRepetitionCount():number{
    if(this.decodeRes) {
      return this.cjAvifDecoder?.getRepetitionCount() ?? 0
    }else{
       return 0
    }
  }

  public getFrameDurations(): Array<number> | undefined{
    if(this.decodeRes) {
      return this.cjAvifDecoder?.getFrameDurations()??undefined
    }else{
      return undefined
    }
  }

  public static isAvifImageffi(buffer:ArrayBuffer): number {
    let newDecoder = new AvifDecoderTS();
    return newDecoder.cjAvifDecoder?.isAvifImageffi(buffer) ?? 0
  }

  public nextFrameIndexffi(): number{
    if(this.decodeRes) {
      return this.cjAvifDecoder?.nextFrameIndexffi()  ?? -1
    }else{
       return -1
    }
  }

  public async nextFrameffi(imageWidth: number, imageHeight: number): Promise<CJReturnValue>{
    if(this.decodeRes) {
      return  this.cjAvifDecoder?.nextFrameffiAsync(imageWidth,imageHeight) ?? new CJReturnValue()
    }else{
      return  new CJReturnValue()
    }
  }

  public async nthFrameffi(index: number, imageWidth: number, imageHeight: number): Promise<CJReturnValue>{
    if(this.decodeRes) {
      return  this.cjAvifDecoder?.nthFrameffiAsync(index,imageWidth,imageHeight) ?? new CJReturnValue()
    }else{
      return  new CJReturnValue()
    }
  }


  public release(): void{
    this.cjAvifDecoder?.release()
  }

}

export class CjCacheCheckTS{

  cjCacheCheck: CJCacheCheck | undefined = undefined

  constructor() {
    if (global_customLib === undefined) {
      global_customLib = requireCJLib("libavif4cj.so") as CustomLib
    }
    this.cjCacheCheck = new global_customLib.CJCacheCheck()
    global_customLib.setGlobalContext(getContext(this))
  }

  public getMemoryCache(uri:string,imagePicWidth:number,imagePicHeight:number):CJReturnValue{
    return this.cjCacheCheck?.getMemoryCache(uri,imagePicWidth,imagePicHeight) ?? new CJReturnValue()
  }

}

export class GlobalUtils {
   static setMemoryLruCacheTS(countSize:number,memorySize:number):void{
     global_customLib?.setMemoryLruCache(countSize,memorySize)
  }

  static setFileLruCacheTS(countSize:number,memorySize:number):void{
    global_customLib?.setFileLruCache(countSize,memorySize)
  }

  static getFileMaxCountSizeTS():number{
    return global_customLib?.getFileMaxCountSizeTS()??0
  }

  static getFileMaxMemorySizeTS():number{
    return global_customLib?.getFileMaxMemorySizeTS()??0
  }

  static getMemoryMaxCountSizeTS():number{
    return global_customLib?.getMemoryMaxCountSizeTS()??0
  }

  static getMemoryMaxMemorySizeTS():number{
    return global_customLib?.getMemoryMaxMemorySizeTS()??0
  }

  static setAvifContext(context:Context):void{
    global_customLib?.setGlobalContext(context)
  }
}