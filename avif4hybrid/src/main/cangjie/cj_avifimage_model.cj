/**
 * Created on 2025/12/29
 */
package ohos_app_cangjie_avif4hybrid

import ohos.ark_interop_macro.Interop
import ohos.component.Column
import ohos.ark_interop.JSCurrentJSContext
import ohos.ark_interop.SharedObject
import ohos.image.Component
import ohos.state_macro_manage.*
import ohos.component.*
import ohos.state_manage.*
internal import ohos.ark_interop.*
internal import ohos.ark_interop_helper.*

@Interop[ArkTS]
public class CJAvifImageModel {
    var imageBuffer: ?Array<Byte> = None
    var imagePicWidth: Int64 = 0
    var imagePicHeight: Int64 = 0
    var imageViewWidth: String = "0.vp"
    var imageViewHeight: String = "0.vp"
    var imageFit: String = ""
    var isDraggable: Bool = false
    var topleftBorderRadius: String = "0.vp"
    var toprightBorderRadius: String = "0.vp"
    var bottomleftBorderRadius: String = "0.vp"
    var bottomrightBorderRadius: String = "0.vp"
    var completeCallBack: ?(Int32) -> Unit = None

    public init() {
    }

    public func setImageBuffer(imageBuffer: Array<Byte>): Unit {
        this.imageBuffer = imageBuffer
    }
    public func setImagePicWidth(imagePicWidth: Int64): Unit {
        this.imagePicWidth = imagePicWidth
    }
    public func setImagePicHeight(imagePicHeight: Int64): Unit {
        this.imagePicHeight = imagePicHeight
    }
    public func setImageViewWidth(imageViewWidth: String): Unit {
        this.imageViewWidth = imageViewWidth
    }
    public func setImageViewHeight(imageViewHeight: String): Unit {
        this.imageViewHeight = imageViewHeight
    }

    public func setImageFit(imageFit: String): Unit {
        this.imageFit = imageFit
    }

    public func setDraggable(draggable: Bool): Unit {
        this.isDraggable = draggable
    }

    public func setTopleftBorderRadius(topleftBorderRadius: String): Unit {
        this.topleftBorderRadius = topleftBorderRadius
    }

    public func setToprightBorderRadius(toprightBorderRadius: String): Unit {
        this.toprightBorderRadius = toprightBorderRadius
    }

    public func setBottomleftBorderRadius(bottomleftBorderRadius: String): Unit {
        this.bottomleftBorderRadius = bottomleftBorderRadius
    }

    public func setBottomrightBorderRadius(bottomrightBorderRadius: String): Unit {
        this.bottomrightBorderRadius = bottomrightBorderRadius
    }

    public func setCompleteCallback(completeCallBack: (Int32) -> Unit): Unit {
        this.completeCallBack = completeCallBack
    }
}

@Component
class CJAvifView {
    var cjmodel: ?CJAvifImageModel

    func checkImageFit(imageFit: String): ImageFit {
        let fit = imageFit.toAsciiLower()
        if (!fit.isEmpty()) {
            if (fit == "fill") {
                return ImageFit.Fill
            } else if (fit == "contain") {
                return ImageFit.Contain
            } else if (fit == "cover") {
                return ImageFit.Cover
            } else {
                return ImageFit.Contain
            }
        }
        return ImageFit.Contain
    }

    let a:Float64= 100.0
    let b:Float64= 100.0
    //LengthType.percent(100.0),
    func build() {
        Column() {
            if (let Some(v) <- this.cjmodel) {
                AvifImage(imageBuffer: v.imageBuffer,
                    imageViewWidth:string2Length(v.imageViewWidth),
                    imageViewHeight: string2Length(v.imageViewHeight),
                    imagePicWidth: v.imagePicWidth,
                    imagePicHeight: v.imagePicHeight,
                    imageFit: checkImageFit(v.imageFit),
                    isDraggable: v.isDraggable,
                    topleftBorderRadius: string2Length(v.topleftBorderRadius),
                    toprightBorderRadius: string2Length(v.toprightBorderRadius),
                    bottomleftBorderRadius: string2Length(v.bottomleftBorderRadius),
                    bottomrightBorderRadius: string2Length(v.bottomrightBorderRadius),
                    completeCallBack: v.completeCallBack)
            }
        }
    }
}
