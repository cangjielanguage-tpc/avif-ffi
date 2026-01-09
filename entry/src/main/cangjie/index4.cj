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
class EntryView4 {

    var imageValue22:?Array<UInt8> = None
    var imageValue23:?Array<UInt8> = None
    var imageValue24:?Array<UInt8> = None
    var imageValue25:?Array<UInt8> = None
    var imageValue26:?Array<UInt8> = None
    var imageValue56:?Array<UInt8> = None
    var imageValue57:?Array<UInt8> = None

    protected override func aboutToAppear() {
        imageValue22 = getImageFromRawFile("a22.avif")
        imageValue23 = getImageFromRawFile("a23.avif")
        imageValue24 = getImageFromRawFile("a24.avif")
        imageValue25 = getImageFromRawFile("a25.avif")
        imageValue26 = getImageFromRawFile("a26.avif")
        imageValue56 = getImageFromRawFile("b4.avif")
        imageValue57 = getImageFromRawFile("b5.avif")
    }

    let scroller = Scroller()

    func build() {
        Scroll(this.scroller){
            Column(){
                AvifImage(imageBuffer:imageValue22,imageViewWidth:600.px,imageViewHeight:400.px)
                AvifImage(imageBuffer:imageValue23,imageViewWidth:600.px,imageViewHeight:400.px)
                AvifImage(imageBuffer:imageValue24,imageViewWidth:600.px,imageViewHeight:400.px)
                AvifImage(imageBuffer:imageValue25,imageViewWidth:600.px,imageViewHeight:400.px)
                AvifImage(imageBuffer:imageValue26,imageViewWidth:600.px,imageViewHeight:400.px)
                AvifImage(imageBuffer:imageValue56,imageViewWidth:600.px,imageViewHeight:400.px)
                AvifImage(imageBuffer:imageValue57,imageViewWidth:600.px,imageViewHeight:400.px)
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
