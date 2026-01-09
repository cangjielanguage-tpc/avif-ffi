/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package ohos_app_cangjie_entry

import ohos.arkui.state_management.*
import ohos.arkui.state_macro_manage.*
import ohos.arkui.component.*
import kit.ImageKit.*
import ohos.base.*
import ohos.resource_manager.ResourceManager
import avif4cj.*

@Entry
@Component
class EntryView7 {

    var imageValue2:?Array<UInt8> = None
    var imageValue3:?Array<UInt8> = None
    var imageValue5:?Array<UInt8> = None
    var imageValue6:?Array<UInt8> = None
    var imageValue8:?Array<UInt8> = None
    var imageValue9:?Array<UInt8> = None
    var imageValue10:?Array<UInt8> = None
    var imageValue11:?Array<UInt8> = None
    var imageValue12:?Array<UInt8> = None
    var imageValue13:?Array<UInt8> = None
    var imageValue14:?Array<UInt8> = None
    var imageValue15:?Array<UInt8> = None
    var imageValue16:?Array<UInt8> = None
    var imageValue17:?Array<UInt8> = None
    var imageValue18:?Array<UInt8> = None
    var imageValue19:?Array<UInt8> = None
    var imageValue20:?Array<UInt8> = None
    var imageValue21:?Array<UInt8> = None
    var imageValue22:?Array<UInt8> = None
    var imageValue23:?Array<UInt8> = None
    var imageValue24:?Array<UInt8> = None
    var imageValue25:?Array<UInt8> = None
    var imageValue26:?Array<UInt8> = None
    var imageValue27:?Array<UInt8> = None
    var imageValue28:?Array<UInt8> = None
    var imageValue29:?Array<UInt8> = None
    var imageValue30:?Array<UInt8> = None
    var imageValue31:?Array<UInt8> = None
    var imageValue32:?Array<UInt8> = None
    var imageValue33:?Array<UInt8> = None
    var imageValue34:?Array<UInt8> = None
    var imageValue35:?Array<UInt8> = None
    var imageValue36:?Array<UInt8> = None
    var imageValue37:?Array<UInt8> = None
    var imageValue38:?Array<UInt8> = None
    var imageValue40:?Array<UInt8> = None
    var imageValue41:?Array<UInt8> = None
    var imageValue42:?Array<UInt8> = None
    var imageValue44:?Array<UInt8> = None
    var imageValue46:?Array<UInt8> = None
    var imageValue47:?Array<UInt8> = None
    var imageValue48:?Array<UInt8> = None
    var imageValue49:?Array<UInt8> = None
    var imageValue50:?Array<UInt8> = None
    var imageValue51:?Array<UInt8> = None
    var imageValue52:?Array<UInt8> = None


    protected override func aboutToAppear() {
        imageValue2 = getImageFromRawFile("a2.avif")
        imageValue3 = getImageFromRawFile("a3.avif")
        imageValue5 = getImageFromRawFile("a5.avif")
        imageValue6 = getImageFromRawFile("a6.avif")
        imageValue8 = getImageFromRawFile("a8.avif")
        imageValue9 = getImageFromRawFile("a9.avif")
        imageValue10 = getImageFromRawFile("a10.avif")
        imageValue11 = getImageFromRawFile("a11.avif")
        imageValue12 = getImageFromRawFile("a12.avif")
        imageValue13 = getImageFromRawFile("a13.avif")
        imageValue14 = getImageFromRawFile("a14.avif")
        imageValue15 = getImageFromRawFile("a15.avif")
        imageValue16 = getImageFromRawFile("a16.avif")
        imageValue17 = getImageFromRawFile("a17.avif")
        imageValue18 = getImageFromRawFile("a18.avif")
        imageValue19 = getImageFromRawFile("a19.avif")
        imageValue20 = getImageFromRawFile("a20.avif")
        imageValue21 = getImageFromRawFile("a21.avif")
        imageValue22 = getImageFromRawFile("a22.avif")
        imageValue23 = getImageFromRawFile("a23.avif")
        imageValue24 = getImageFromRawFile("a24.avif")
        imageValue25 = getImageFromRawFile("a25.avif")
        imageValue26 = getImageFromRawFile("a26.avif")
        imageValue27 = getImageFromRawFile("a27.avif")
        imageValue28 = getImageFromRawFile("a28.avif")
        imageValue29 = getImageFromRawFile("a29.avif")
        imageValue30 = getImageFromRawFile("a30.avif")
        imageValue31 = getImageFromRawFile("a31.avif")
        imageValue32 = getImageFromRawFile("a32.avif")
        imageValue33 = getImageFromRawFile("a33.avif")
        imageValue34 = getImageFromRawFile("a34.avif")
        imageValue35 = getImageFromRawFile("a35.avif")
        imageValue36 = getImageFromRawFile("a36.avif")
        imageValue37 = getImageFromRawFile("a37.avif")
        imageValue38 = getImageFromRawFile("a38.avif")
        imageValue40 = getImageFromRawFile("a40.avif")
        imageValue41 = getImageFromRawFile("a41.avif")
        imageValue42 = getImageFromRawFile("a42.avif")
        imageValue44 = getImageFromRawFile("a44.avif")
        imageValue46 = getImageFromRawFile("a46.avif")
        imageValue47 = getImageFromRawFile("a47.avif")
        imageValue48 = getImageFromRawFile("a48.avif")
        imageValue49 = getImageFromRawFile("a49.avif")
        imageValue50 = getImageFromRawFile("a50.avif")
        imageValue51 = getImageFromRawFile("a51.avif")
        imageValue52 = getImageFromRawFile("a52.avif")
    }

    let scroller = Scroller()

    func build() {
        Scroll(this.scroller){
            Column(){
                AvifImage(imageBuffer:imageValue2,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue3,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue5,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue6,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue8,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue9,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue10,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue11,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue12,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue13,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue14,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue15,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue16,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue17,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue18,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue19,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue20,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue21,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue22,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue23,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue24,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue25,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue26,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue27,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue28,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue29,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue30,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue31,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue32,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue33,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue34,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue35,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue36,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue37,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue38,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue40,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue41,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue42,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue44,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue46,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue47,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue48,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue49,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue50,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue51,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
                AvifImage(imageBuffer:imageValue52,imageViewWidth:600.px,imageViewHeight:400.px,imagePicWidth:300,imagePicHeight:200,imageFit:ImageFit.Fill)
            }
        }
    }

    private func getImageFromRawFile(rawFileName: String): ?Array<UInt8> {
        try {
            let resourceManager = globalAbilityContext.getOrThrow().resourceManager
            let arr: Array<UInt8> = resourceManager.getRawFileContent(rawFileName)
            return arr
        } catch (e: Exception) {
            return None
        }
    }
}
