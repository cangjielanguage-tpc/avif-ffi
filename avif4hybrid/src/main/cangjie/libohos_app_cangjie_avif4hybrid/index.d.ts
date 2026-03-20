import { Context } from "@kit.AbilityKit"

export declare class CJReturnValue {
    code: number
    color: ArrayBuffer | undefined
    issuccess: boolean
    memoryWidth: number
    memoryHeight: number
    constructor ()
}


export declare class CJAvifDecoder {
    create(uri: string): CJAvifDecoder | undefined
    createWithThread(uri: string, threads: number): CJAvifDecoder | undefined
    getWidth(): number
    getHeight(): number
    getDepth(): number
    getAlphaPresent(): boolean
    getFrameCount(): number
    getRepetitionCount(): number
    getFrameDurations(): Array<number> | undefined
    isAvifImageffi(): number
    nextFrameIndexffi(): number
    nextFrameffi(imageWidth: number, imageHeight: number): CJReturnValue
    nthFrameffi(index: number, imageWidth: number, imageHeight: number): CJReturnValue
    release(): void
    constructor ()
}

export declare class CJCacheCheck {
    getMemoryCache(uri:string,imagePicWidth:number,imagePicHeight:number):CJReturnValue
    constructor ()
}


export declare function setGlobalContext(context: Context): void

export declare function setMemoryLruCache(countSize:number,memorySize:number): void

export declare function setFileLruCache(countSize:number,memorySize:number): void
