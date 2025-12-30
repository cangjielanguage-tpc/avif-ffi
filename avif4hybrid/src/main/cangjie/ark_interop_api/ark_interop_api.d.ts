export declare class CJAvifImageModel {
    setImageBuffer(imageBuffer: ArrayBuffer): void
    setImagePicWidth(imagePicWidth: number): void
    setImagePicHeight(imagePicHeight: number): void
    setImageViewWidth(imageViewWidth: string): void
    setimageViewHeight(imageViewHeight: string): void
    setImageFit(imageFit: string): void
    setDraggable(draggable: boolean): void
    setTopleftBorderRadius(topleftBorderRadius: string): void
    setToprightBorderRadius(toprightBorderRadius: string): void
    setBottomleftBorderRadius(bottomleftBorderRadius: string): void
    setBottomrightBorderRadius(bottomrightBorderRadius: string): void
    setCompleteCallback(completeCallBack: (funcArg0: number) => void): void
}

export declare interface CustomLib {
    CJAvifImageModel: {new (): CJAvifImageModel}
}