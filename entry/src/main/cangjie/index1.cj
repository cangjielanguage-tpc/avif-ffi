/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package ohos_app_cangjie_entry

internal import ohos.base.LengthProp
internal import ohos.component.Column
internal import ohos.component.Row
internal import ohos.component.Text
internal import ohos.component.Button
internal import ohos.component.CustomView
internal import ohos.component.CJEntry
internal import ohos.component.loadNativeView
internal import ohos.component.FontWeight
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ObservedProperty
internal import ohos.state_manage.LocalStorage
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import avif4cj.*
import ohos.hilog.Hilog
import ohos.resource_manager.ResourceManager
import ohos.image.PixelMap
import ohos.image.InitializationOptions
import ohos.image.createPixelMap
import ohos.image.PixelMapFormat
import ohos.image.Size
import ohos.component.Image
import ohos.concurrency.launch
import ohos.base.Color
import std.fs.Path
import std.fs.exists
import std.fs.File
import std.fs.remove
import std.fs.OpenMode
import ohos.component.ImageFit
import ohos.system_date_time.SystemDateTime
@Entry
@Component
class EntryView1 {


    let size: Size = Size(width: 600, height: 400)
    let opts: InitializationOptions = InitializationOptions(size: size)
    let color: Array<UInt8> = Array<UInt8>(600*400*4, repeat: 0)
    @State
    var pixelMap: PixelMap = createPixelMap(color, opts)

    func build() {
        Row {
            Column {

                Image(pixelMap).width(600.px).height(400.px).objectFit(ImageFit.Fill)

                Button("test2")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr1 = getImageFromRawFile("cat.png")
                         if(let Some(i) <- arr1){
                            let avif:?AvifDecoder = AvifDecoder.create(i)
                            if(let Some(j) <- avif){
                                let isavif:Int32 = j.isAvifImageffi(i)
                                Hilog.error(0,"isAvifImage 1 true 0 false cat.png","-----"+isavif.toString())
                                j.release()
                            }
                         }

                        let arr2 = getImageFromRawFile("1.png")
                             if(let Some(i) <- arr2){
                                let avif:?AvifDecoder = AvifDecoder.create(i)
                                if(let Some(j) <- avif){
                                    let isavif:Int32 = j.isAvifImageffi(i)
                                    Hilog.error(0,"isAvifImage 1 true 0 false cat.png","-----"+isavif.toString())
                                    j.release()
                                }
                             }

                        let arr3 = getImageFromRawFile("2.jpg")
                             if(let Some(i) <- arr3){
                                let avif:?AvifDecoder = AvifDecoder.create(i)
                                if(let Some(j) <- avif){
                                    let isavif:Int32 = j.isAvifImageffi(i)
                                    Hilog.error(0,"isAvifImage 1 true 0 false cat.png","-----"+isavif.toString())
                                    j.release()
                                }
                             }

                        let arr4 = getImageFromRawFile("3.jpg")
                             if(let Some(i) <- arr4){
                               let avif:?AvifDecoder = AvifDecoder.create(i)
                                if(let Some(j) <- avif){
                                    let isavif:Int32 = j.isAvifImageffi(i)
                                    Hilog.error(0,"isAvifImage 1 true 0 false cat.png","-----"+isavif.toString())
                                    j.release()
                                }
                             }

                        let arr5 = getImageFromRawFile("4.avif")
                             if(let Some(i) <- arr5){
                                let avif:?AvifDecoder = AvifDecoder.create(i)
                                if(let Some(j) <- avif){
                                    let isavif:Int32 = j.isAvifImageffi(i)
                                    Hilog.error(0,"isAvifImage 1 true 0 false cat.png","-----"+isavif.toString())
                                    j.release()
                                }
                             }


                    }

                  //a2可 a3可 a5可 a6可 a8可 a9可 a10可 a11可 a12可 a13可 a14可 a15可 a16可 a17可 a18可 a19可 a20可 a21可 a22黑 a23灰 a24黑
                  //a25黑 a26可 a27可 a28可 a29可 a30可 a31可 a32可 a33白 a34可 a35可 a36白 a37白 a38白 a40白 a41白 a42可 a44可 a46可 a47可
                  //a48可 a49可 a50可 a51可 a52可
                  //23是个动画

                  //23，25，26的repetitionCount 4294967295
                 Button("test3")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr5 = getImageFromRawFile("a27.avif")
                            if(let Some(i) <- arr5){
                                 let avif:?AvifDecoder = AvifDecoder.create(i)
                                 if(let Some(j) <- avif){
                                    let info:Cjinfo = j.getInfoffi(i)
                                     Hilog.error(0,"avif info","-----info.width = ${info.width} info.height = ${info.height} info.depth = ${info.depth} info.alpha = ${info.alphaPresent}")
                                     Hilog.error(0,"avif info","-----info.frameCount = ${info.frameCount} info.repetitionCount = ${info.repetitionCount} ")
                                     for(i in 0..info.frameCount){
                                        Hilog.error(0,"avif info","-----info.duration = ${info.frameDurations[Int64(i)]}")
                                     }
                                     j.release()
                                 }
                            }
                    }

                 Button("test4")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr5 = getImageFromRawFile("a36.avif")
                            if(let Some(i) <- arr5){
                                 let avif:?AvifDecoder = AvifDecoder.create(i)
                                 if(let Some(j) <- avif){
                                    let width =  j.getWidth()
                                    let height = j.getHeight()
                                    let depth = j.getDepth()
                                    let alphapresent = j.getAlphaPresent()
                                    let framecount = j.getFrameCount()
                                    let repetitionCount = j.getRepetitionCount()
                                    let duretionlist = j.getFrameDurations()
                                    Hilog.error(0,"avif info","-----width = ${width} height = ${height} depth = ${depth} alpha = ${alphapresent}")
                                    Hilog.error(0,"avif info","-----framecount = ${framecount} repetitionCount = ${repetitionCount}")
                                    Hilog.error(0,"avif info","-----duretionlist = ${duretionlist}")
                                 }
                            }

                    }


                Button("test5")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr = getImageFromRawFile("5.avif")
                            if(let Some(i) <- arr){
                                 let avif:?AvifDecoder = AvifDecoder.create(i)
                                 if(let Some(j) <- avif){
                                    let index = j.nextFrameIndexffi()
                                    Hilog.error(0,"avif createdecoder","----- nextIndex=${index}")
                                    j.release()
                                 }
                            }

                    }
                  //a2可 a3可 a5可 a6可 a8可 a9可 a10可 a11可 a12可 a13可 a14可 a15可 a16可 a17可 a18可 a19可 a20可 a21可 a22黑 a23灰 a24黑
                  //a25黑 a26可 a27可 a28可 a29可 a30可 a31可 a32可 a33白 a34可 a35可 a36白 a37白 a38白 a40白 a41白 a42可 a44可 a46可 a47可
                  //a48可 a49可 a50可 a51可 a52可
                  //23是个动画
                  Button("test6")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr = getImageFromRawFile("a52.avif")
                            if(let Some(i) <- arr){
                                let avif:?AvifDecoder = AvifDecoder.create(i)
                                if(let Some(j) <- avif){
                                    //创建pixelmap
                                    let mWidth = j.getWidth()
                                    let mHeight = j.getHeight()
                                    let colors: Array<UInt8> = Array<UInt8>(mWidth*mHeight*4, repeat: 0)
                                    j.nextFrameffi(colors, Int32(mWidth),Int32(mHeight),PixelMapFormat.RGBA_8888)
                                    let size: Size = Size(width: Int32(mWidth), height: Int32(mHeight))
                                    let opts: InitializationOptions = InitializationOptions(PixelMapFormat.RGBA_8888,editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: Size(width: Int32(mWidth), height: Int32(mHeight)))
                                    pixelMap = createPixelMap(colors, opts)
                                    j.release()
                                }
                            }
                    }

                 //22 黑 蓝 绿 红 黄
                 //23 灰 浅蓝 浅绿 浅红 浅黄
                 //24 黑 蓝 绿 红 黄
                 //25 黑 蓝 绿 红 黄
                 //26 粉 绿 浅绿 绿粉 绿粉
                 Button("test7")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr = getImageFromRawFile("a24.avif")
                            if(let Some(i) <- arr){
                                let avif:?AvifDecoder = AvifDecoder.create(i)
                                if(let Some(j) <- avif){
                                     //创建pixelmap
                                    let mWidth = j.getWidth()
                                    let mHeight = j.getHeight()
                                    let colors: Array<UInt8> = Array<UInt8>(mWidth*mHeight*4, repeat: 0)
                                    j.nthFrameffi(4, colors, Int32(mWidth),Int32(mHeight),PixelMapFormat.RGBA_8888)
                                    let size: Size = Size(width: Int32(mWidth), height: Int32(mHeight))
                                    let opts: InitializationOptions = InitializationOptions(PixelMapFormat.RGBA_8888,editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: Size(width: Int32(mWidth), height: Int32(mHeight)))
                                    pixelMap = createPixelMap(colors, opts)
                                    j.release()
                                }
                            }

                    }

                Button("test8")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr = getImageFromRawFile("a51.avif")
                            if(let Some(i) <- arr){
                                let avif:?AvifDecoder = AvifDecoder.create(i)
                                if(let Some(j) <- avif){
                                      //创建pixelmap
                                    let mWidth = j.getWidth()
                                    let mHeight = j.getHeight()
                                    let colors: Array<UInt8> = Array<UInt8>(mWidth*mHeight*4, repeat: 0)
                                    let startTime = SystemDateTime.getRealTime(isNano: true)
                                    j.decodeffi(i, colors, Int32(mWidth),Int32(mHeight),PixelMapFormat.RGBA_8888)
                                    let endTime = SystemDateTime.getRealTime(isNano: true)
                                    let size: Size = Size(width: Int32(mWidth), height: Int32(mHeight))
                                    let opts: InitializationOptions = InitializationOptions(PixelMapFormat.RGBA_8888,editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: Size(width: Int32(mWidth), height: Int32(mHeight)))
                                    pixelMap = createPixelMap(colors, opts)
                                    Hilog.error(0, "calcTime", "startTime=${startTime} endTime=${endTime} sjc=${endTime-startTime}")
                                    j.release()
                                }
                            }
                    }


                 Button("test9")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr = getImageFromRawFile("a52.avif")
                            if(let Some(i) <- arr){
                                let avif:?AvifDecoder = AvifDecoder.create(i)
                                if(let Some(j) <- avif){
                                 //创建pixelmap
                                let mWidth = j.getWidth()
                                let mHeight = j.getHeight()
                                let colors: Array<UInt8> = Array<UInt8>()
                                let res = j.nextFrameffi(colors, Int32(mWidth),Int32(mHeight),PixelMapFormat.RGBA_8888)
                                if(res == 0){
                                    let size: Size = Size(width: Int32(mWidth), height: Int32(mHeight))
                                    let opts: InitializationOptions = InitializationOptions(PixelMapFormat.RGBA_8888,editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: Size(width: Int32(mWidth), height: Int32(mHeight)))
                                    pixelMap = createPixelMap(colors, opts)
                                 }
                                 j.release()
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
            //Hilog.error(0,"getImageFromRawFile","arrsize=${arr.size}")
            return arr
        } catch (e: Exception) {
            return None
        }
    }
}
