import { Context } from "@kit.AbilityKit"

export declare class CJReturnValue {
    code: number
    codeMessage: string
    color: ArrayBuffer | undefined
    issuccess: boolean
    memoryWidth: number
    memoryHeight: number
    isAlphaPresent: boolean
}


export declare class CJAvifDecoder {
    createAsync(uri: string): Promise<CJReturnValue>
    createWithThreadAsync(uri: string, threads: number): Promise<CJReturnValue>
    getWidth(): number
    getHeight(): number
    getDepth(): number
    getAlphaPresent(): boolean
    getFrameCount(): number
    getRepetitionCount(): number
    getFrameDurations(): Array<number> | undefined
    isAvifImageffi(): number
    nextFrameIndexffi(): number
    nextFrameffiAsync(imageWidth: number, imageHeight: number): Promise<CJReturnValue>
    nthFrameffiAsync(index: number, imageWidth: number, imageHeight: number): Promise<CJReturnValue>
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


