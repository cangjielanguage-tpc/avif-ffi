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
import ohos.base.Length
import std.collection.ArrayList
import ohos.system_date_time.SystemDateTime

@Entry
@Component
class EntryView2 {

    @State
    var mmwidth:Length = 20.percent
    @State
    var mmheight:Length = 20.percent

    let size: Size = Size(width: 1, height: 1)
    let opts: InitializationOptions = InitializationOptions(size: size)
    let color: Array<UInt8> = Array<UInt8>(1 * 1 * 4, repeat: 0)
    @State
    var pixelMap: PixelMap = createPixelMap(color, opts)

    let pixelMapList: ArrayList<PixelMap> = ArrayList<PixelMap>()

    var isLoop:Bool = true

    func build() {
        Row {
            Column {

                Image(pixelMap)
                    .width(mmwidth)
                    .height(mmheight)

                //a2可 a3可 a5可 a6可 a8可 a9可 a10可 a11可 a12可 a13可 a14可 a15可 a16可 a17可 a18可 a19可 a20可 a21可 a22黑 a23灰 a24黑
                //a25黑 a26可 a27可 a28可 a29可 a30可 a31可 a32可 a33白 a34可 a35可 a36白 a37白 a38白 a40白 a41白 a42可 a44可 a46可 a47可
                //a48可 a49可 a50可 a51可 a52可
                //23是个动画
                Button("testsingle")
                    .fontSize(20)
                    .onClick {
                        evt =>
                            let arr = getImageFromRawFile("a52.avif")
                                if (let Some(i) <- arr) {
                                    let startTime = SystemDateTime.getRealTime(isNano: true);
                                    let avif: ?AvifDecoder = AvifDecoder.create(i)
                                    if(let Some(j) <- avif){
                                        let mWidth = j.getWidth()
                                        let mHeight = j.getHeight()
                                        mmwidth = Int64(mWidth).px
                                        mmheight = Int64(mHeight).px
                                        let colors: Array<UInt8> = Array<UInt8>(Int64(mWidth * mHeight * 4), repeat: 0)
                                        j.nextFrameffi(colors, Int32(mWidth), Int32(mHeight),
                                            PixelMapFormat.RGBA_8888)
                                        let endTime = SystemDateTime.getRealTime(isNano: true)
                                        let size: Size = Size(width: Int32(mWidth), height: Int32(mHeight))
                                        let opts: InitializationOptions = InitializationOptions(PixelMapFormat.RGBA_8888,
                                            editable: true, pixelFormat: PixelMapFormat.RGBA_8888,
                                            size: Size(width: Int32(mWidth), height: Int32(mHeight)))
                                        pixelMap = createPixelMap(colors, opts)
                                        Hilog.error(0, "calcTime", "startTime=${startTime} endTime=${endTime} sjc=${endTime-startTime}")
                                        j.release()
                                    }
                                }

                    }

               //a2可 a3可 a5可 a6可 a8可 a9可 a10可 a11可 a12可 a13可 a14可 a15可 a16可 a17可 a18可 a19可 a20可 a21可 a22黑 a23灰 a24黑
                //a25黑 a26可 a27可 a28可 a29可 a30可 a31可 a32可 a33白 a34可 a35可 a36白 a37白 a38白 a40白 a41白 a42可 a44可 a46可 a47可
                //a48可 a49可 a50可 a51可 a52可
                //23是个动画
                Button("testmult")
                    .fontSize(20)
                    .onClick {
                        evt =>
                            let arr = getImageFromRawFile("a25.avif")
                                if (let Some(i) <- arr) {
                                    let avif: ?AvifDecoder = AvifDecoder.create(i)
                                    if(let Some(p) <- avif){
                                        let mWidth = p.getWidth()
                                        let mHeight = p.getHeight()
                                        Hilog.error(0, "colorvalueWH", "mWidth=${mWidth} mHeight=${mHeight}")
                                        mmwidth = Int64(mWidth).px
                                        mmheight = Int64(mHeight).px
                                        let frameCount:Int64 = p.getFrameCount()
                                        if(p.getFrameDurations().isNone()){
                                            Hilog.error(0, "aviflog", "数据有误")
                                            return
                                        }
                                        if(p.getFrameDurations().getOrThrow().size != frameCount){
                                            Hilog.error(0, "aviflog", "数据有误")
                                            return
                                        }
                                        let durationList: Array<Float64> = p.getFrameDurations().getOrThrow()
                                        spawn {
                                            while (isLoop) {
                                                if (pixelMapList.size != frameCount) {
                                                     for (k in 0..frameCount) {
                                                        let colors: Array<UInt8> = Array<UInt8>(Int64(mWidth * mHeight * 4),repeat: 0)
                                                        p.nthFrameffi(Int32(k), colors, Int32(mWidth), Int32(mHeight),PixelMapFormat.RGBA_8888)
                                                        let size2: Size = Size(width: Int32(mWidth), height: Int32(mHeight))
                                                        let opts: InitializationOptions = InitializationOptions(PixelMapFormat.RGBA_8888, editable: true,pixelFormat: PixelMapFormat.RGBA_8888,size: size2)
                                                        let tempPixelMap = createPixelMap(colors, opts)
                                                        launch{
                                                             pixelMap = tempPixelMap
                                                        }
                                                        sleep(durationList[Int64(k)] * Duration.second)
                                                        pixelMapList.add(pixelMap)
                                                    }
                                                }else{
                                                    p.release()
                                                    for (k in 0..pixelMapList.size) {
                                                        let tempPixelMap = pixelMapList.get(k).getOrThrow()
                                                        launch{
                                                            pixelMap = tempPixelMap
                                                        }
                                                        sleep(durationList[Int64(k)] * Duration.second)
                                                   }
                                                }
                                            }
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

    protected override func aboutToDisappear() {
        isLoop = false
        try{
            for(i in 0..pixelMapList.size){
                pixelMapList.get(i).getOrThrow().release()
            }
            this.pixelMap.release()
        }catch (e:Exception){
           Hilog.error(0,"aviflog",e.toString())
        }
    }

}
