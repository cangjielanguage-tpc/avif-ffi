import { Context } from "@kit.AbilityKit"

export declare class CJReturnValue {
    code: number
    color: ArrayBuffer | undefined
    issuccess: boolean
    constructor ()
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
    decodeffi(imageWidth: number, imageHeight: number): CJReturnValue
    release(): void
    constructor ()
}


export declare function setGlobalContext(context: Context): void

export declare function getLoadCJPage(model: CJAvifImageModel): void

export declare function setMemoryLruCache(countSize:number,memorySize:number): void

export declare function setFileLruCache(countSize:number,memorySize:number): void
