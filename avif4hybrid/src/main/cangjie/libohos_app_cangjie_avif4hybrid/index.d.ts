import { Context } from "@kit.AbilityKit"

export declare class CJReturnValue {
    code: number
    color: ArrayBuffer | undefined
    issuccess: boolean
    memoryWidth: number
    memoryHeight: number
    isAlphaPresent: boolean
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
    isAvifImageffi(): number
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
    setGlobalContext(context: Context): void
    setMemoryLruCache(countSize:number,memorySize:number):void
    setFileLruCache(countSize:number,memorySize:number):void
}


