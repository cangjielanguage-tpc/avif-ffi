import { requireCJLib } from 'libark_interop_loader.so'

import { CustomLib,CJCacheCheck,CJAvifDecoder,CJReturnValue} from 'libohos_app_cangjie_avif4hybrid.so';


export const global_customLib: CustomLib = requireCJLib("libohos_app_cangjie_avif4hybrid.so") as CustomLib

export class AvifDecoderTS{

  cjAvifDecoder: CJAvifDecoder = new global_customLib.CJAvifDecoder()
  decodeRes:boolean = true

  constructor() {
    global_customLib.setGlobalContext(getContext(this))
  }

  public async create(uri:string):Promise<boolean>{
    this.decodeRes = await this.cjAvifDecoder.createAsync(uri)
    return this.decodeRes
  }

  public async createWithThread(uri:string, threads: number):Promise<boolean>{
    this.decodeRes = await this.cjAvifDecoder.createWithThreadAsync(uri,threads)
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

  public async nextFrameffi(imageWidth: number, imageHeight: number): Promise<CJReturnValue>{
    if(this.decodeRes) {
      return await this.cjAvifDecoder.nextFrameffiAsync(imageWidth,imageHeight)
    }else{
      return await new global_customLib.CJReturnValue()
    }
  }

  public async nthFrameffi(index: number, imageWidth: number, imageHeight: number): Promise<CJReturnValue>{
    if(this.decodeRes) {
       return await this.cjAvifDecoder.nthFrameffiAsync(index,imageWidth,imageHeight)
    }else{
       return await new global_customLib.CJReturnValue()
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