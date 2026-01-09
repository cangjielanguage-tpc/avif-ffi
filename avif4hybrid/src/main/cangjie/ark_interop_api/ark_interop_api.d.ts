export declare class CJReturnValue {
    code: number
    color: ArrayBuffer | undefined
    issuccess: boolean
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
}

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
    nextFrameIndexffi(): number
    nextFrameffi(imageWidth: number, imageHeight: number): CJReturnValue
    nthFrameffi(index: number, imageWidth: number, imageHeight: number): CJReturnValue
    decodeffi(encoded: ArrayBuffer, imageWidth: number, imageHeight: number): CJReturnValue
    release(): void
}


export declare interface CustomLib {
    CJAvifDecoder: {new (): CJAvifDecoder}
    CJAvifImageModel: {new (): CJAvifImageModel}
    CJReturnValue: {new (): CJReturnValue}
}