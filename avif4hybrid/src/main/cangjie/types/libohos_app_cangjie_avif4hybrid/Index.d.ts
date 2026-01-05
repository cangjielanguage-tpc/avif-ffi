export declare class CJAvifDecoder {
    create(encoded: ArrayBuffer): CJAvifDecoder | undefined
    createWithThread(encoded: ArrayBuffer, threads: number): CJAvifDecoder | undefined
    getWidth(): number
    getHeight(): number
    getDepth(): number
    getAlphaPresent(): boolean
    getFrameCount(): number
    getRepetitionCount(): number
    getFrameDurations(): Array<number> | undefined
    isAvifImageffi(encoded: ArrayBuffer): number
    getInfoffi(encoded: ArrayBuffer): CJCjinfo | undefined
    nextFrameIndexffi(): number
    nextFrameffi(imageWidth: number, imageHeight: number): CJReturnValue
    nthFrameffi(index: number, imageWidth: number, imageHeight: number): CJReturnValue
    decodeffi(encoded: ArrayBuffer, imageWidth: number, imageHeight: number): CJReturnValue
    release(): void
    constructor ()
}

export declare class CJReturnValue {
    code: number
    color: ArrayBuffer | undefined
    issuccess: boolean
    constructor ()
}

export declare class CJCjinfo {
    width: number
    height: number
    depth: number
    alphaPresent: boolean
    frameCount: number
    repetitionCount: number
    frameDurations: Array<number>
    setWidth(width: number): void
    setHeight(height: number): void
    setDepth(depth: number): void
    setAlphaPresent(alphaPresent: boolean): void
    setFrameCount(frameCount: number): void
    setRepetitionCount(repetitionCount: number): void
    setFrameDurations(frameDurations: Array<number>): void
    constructor ()
}

export declare class CJAvifImageModel {
    setImageBuffer(imageBuffer: ArrayBuffer): void
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




export declare function testCJ(s: string): string

import { Context } from "@kit.AbilityKit"

export declare interface CustomLib {
    CJAvifImageModel: {new (): CJAvifImageModel}
    CJAvifDecoder: {new (): CJAvifDecoder}
    CJCjinfo: {new (): CJCjinfo}
    CJReturnValue: {new (): CJReturnValue}
    getLoadCJPage(model: CJAvifImageModel): void
}

