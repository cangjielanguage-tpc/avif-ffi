/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package ohos_app_cangjie_entry

import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.component.*
import ohos.image.*
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

    protected override func aboutToAppear() {
        imageValue22 = getImageFromRawFile("a22.avif")
        imageValue23 = getImageFromRawFile("a23.avif")
        imageValue24 = getImageFromRawFile("a24.avif")
        imageValue25 = getImageFromRawFile("a25.avif")
        imageValue26 = getImageFromRawFile("a26.avif")
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
            }
        }
    }

    private func getImageFromRawFile(rawFileName: String): ?Array<UInt8> {
        try {
            let resourceManager = ResourceManager.getResourceManager(getStageContext(globalAbilityContext.getOrThrow()))
            let arr: Array<UInt8> = resourceManager.getRawFileContent(rawFileName)
            return arr
        } catch (e: Exception) {
            return None
        }
    }
}
