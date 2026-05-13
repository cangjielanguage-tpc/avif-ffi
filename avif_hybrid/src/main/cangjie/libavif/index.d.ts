import { Context } from "@kit.AbilityKit"

export declare class CJReturnValue {
    code: number
    color: ArrayBuffer | undefined
    issuccess: boolean
    memoryWidth: number
    memoryHeight: number
    isAlphaPresent: boolean
}

export declare class CJAvifImageModel {
    setUri(uri: string): void
    setImagePicWidth(imagePicWidth: number): void
    setImagePicHeight(imagePicHeight: number): void
    setImageViewWidth(imageViewWidth: string): void
    setImageViewHeight(imageViewHeight: string): void
    setImageFit(imageFit: string): void
    setDraggable(draggable: boolean): void
    setTopleftBorderRadius(topleftBorderRadius: string): void
    setToprightBorderRadius(toprightBorderRadius: string): void
    setBottomleftBorderRadius(bottomleftBorderRadius: string): void
    setBottomrightBorderRadius(bottomrightBorderRadius: string): void
    setCompleteCallback(completeCallBack: (funcArg0: number) => void): void
}

export declare class CJAvifDecoder {
    createAsync(uri: string): boolean
    createWithThreadAsync(uri: string, threads: number): boolean
    getWidth(): number
    getHeight(): number
    getDepth(): number
    getAlphaPresent(): boolean
    getFrameCount(): number
    getRepetitionCount(): number
    getFrameDurations(): Array<number> | undefined
    isAvifImageffi(array:ArrayBuffer): number
    nextFrameIndexffi(): number
    nextFrameffiAsync(imageWidth: number, imageHeight: number): CJReturnValue
    nthFrameffiAsync(index: number, imageWidth: number, imageHeight: number): CJReturnValue
    release(): void
}

export declare class CJCacheCheck {
    getMemoryCache(uri:string,imagePicWidth:number,imagePicHeight:number):CJReturnValue
}


export declare interface CustomLib {
    CJAvifDecoder: {new (): CJAvifDecoder}
    CJCacheCheck: {new (): CJCacheCheck}
    CJReturnValue: {new (): CJReturnValue}
    CJAvifImageModel:{new ():CJAvifImageModel}
    setGlobalContext(context: Context): void
    setMemoryLruCache(countSize:number,memorySize:number):void
    setFileLruCache(countSize:number,memorySize:number):void
    getLoadCJPage(model: CJAvifImageModel): void
    getFileMaxCountSizeTS():number
    getFileMaxMemorySizeTS():number
    getMemoryMaxCountSizeTS():number
    getMemoryMaxMemorySizeTS():number

}


