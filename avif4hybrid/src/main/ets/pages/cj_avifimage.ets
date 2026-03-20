import { CJCacheCheck,CJAvifDecoder,CJReturnValue,setGlobalContext,setMemoryLruCache,setFileLruCache} from 'libohos_app_cangjie_avif4hybrid.so';


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

export class CjCacheCheckTS{

  cjCacheCheck: CJCacheCheck = new CJCacheCheck()

  constructor() {
    setGlobalContext(getContext(this))
  }

  public getMemoryCache(uri:string,imagePicWidth:number,imagePicHeight:number):CJReturnValue{
     return this.cjCacheCheck.getMemoryCache(uri,imagePicWidth,imagePicHeight)
  }

  public getDiskCache(uri:string,imagePicWidth:number,imagePicHeight:number):CJAvifDecoder | undefined{
    return this.cjCacheCheck.getDiskCache(uri,imagePicWidth,imagePicHeight)
  }

}

export class GlobalUtils {
   static setMemoryLruCacheTS(countSize:number,memorySize:number):void{
    setMemoryLruCache(countSize,memorySize)
  }

  static setFileLruCacheTS(countSize:number,memorySize:number):void{
    setFileLruCache(countSize,memorySize)
  }

  static setAvifContext(context:Context):void{
     setGlobalContext(context)
  }
}