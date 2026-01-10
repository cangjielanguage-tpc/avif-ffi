/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package ohos_app_cangjie_entry

import ohos.arkui.component.*
import ohos.arkui.state_management.*
import ohos.arkui.state_macro_manage.*
import avif4cj.*
import ohos.resource_manager.ResourceManager
import kit.ImageKit.PixelMap
import kit.ImageKit.InitializationOptions
import kit.ImageKit.createPixelMap
import kit.ImageKit.PixelMapFormat
import kit.ImageKit.Size
import ohos.hilog.Hilog
import ohos.base.launch

@Entry
@Component
class EntryView11 {
    let size: Size = Size(1,1)
    let opts: InitializationOptions = InitializationOptions(size)
    let color: Array<UInt8> = Array<UInt8>(4, repeat: 0)
    @State
    var pixelMap: PixelMap = createPixelMap(color, opts)

    func build() {
        Row {
            Column {
                Image(pixelMap)
                    .width(600.px)
                    .height(400.px)
                    .objectFit(ImageFit.Contain)

                Button("showpic")
                    .fontSize(20)
                    .onClick ({
                        evt =>
                            let arr = getImageFromRawFile("a52.avif")
                            if (let Some(i) <- arr) {
                                let avif: ?AvifDecoder = AvifDecoder.create(i)
                                if (let Some(j) <- avif) {
                                    //创建pixelmap
                                    spawn {
                                        let mWidth = j.getWidth()
                                        let mHeight = j.getHeight()
                                        let colors: Array<UInt8> = Array<UInt8>(mWidth * mHeight * 4, repeat: 0)
                                        j.nextFrameffi(colors, Int32(mWidth), Int32(mHeight))
                                        let opts: InitializationOptions = InitializationOptions(Size(Int32(mHeight),Int32(mWidth)),editable: true,
                                            pixelFormat: PixelMapFormat.Rgba8888)
                                        let tempPixelMap = createPixelMap(colors, opts)
                                        launch {
                                            pixelMap = tempPixelMap
                                        }
                                        j.release()
                                    }
                                }
                            }
                        })
            }.width(100.percent)
        }.height(100.percent)
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

    protected override func aboutToDisappear() {
        try{
            this.pixelMap.release()
        }catch (e:Exception){
           Hilog.error(0,"aviflog",e.toString())
        }
    }
}
