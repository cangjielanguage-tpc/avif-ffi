/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package ohos_app_cangjie_entry

import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import libavif4cj.*
import ohos.resource_manager.ResourceManager
import ohos.image.PixelMap
import ohos.image.InitializationOptions
import ohos.image.createPixelMap
import ohos.image.PixelMapFormat
import ohos.image.Size
import ohos.concurrency.launch

@Entry
@Component
class EntryView9 {
    let size: Size = Size(width: 1, height: 1)
    let opts: InitializationOptions = InitializationOptions(size: size)
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
                    .onClick {
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
                                        j.nextFrameffi(colors, Int32(mWidth), Int32(mHeight),PixelMapFormat.RGBA_8888)
                                        let size: Size = Size(width: Int32(mWidth), height: Int32(mHeight))
                                        let opts: InitializationOptions = InitializationOptions(PixelMapFormat.RGBA_8888, editable: true,
                                            pixelFormat: PixelMapFormat.RGBA_8888,size: Size(width: Int32(mWidth), height: Int32(mHeight)))
                                        let tempPixelMap = createPixelMap(colors, opts)
                                        launch {
                                            pixelMap = tempPixelMap
                                        }
                                        j.release()
                                    }
                                }
                            }
                        }
            }.width(100.percent)
        }.height(100.percent)
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
