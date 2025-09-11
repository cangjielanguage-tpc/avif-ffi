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
import libavif4cj.*
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
@Entry
@Component
class EntryView {


    let size: Size = Size(width: 600, height: 400)
    let opts: InitializationOptions = InitializationOptions(size: size)
    let color: Array<UInt8> = Array<UInt8>(600*400*4, repeat: 0)
    @State
    var pixelMap: PixelMap = createPixelMap(color, opts)

    func build() {
        Row {
            Column {

                Image(pixelMap).width(600.px).height(400.px)

                Button("test1")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let avif:AvifDecoder = AvifDecoder()
                        let version = avif.versionStringffi()
                        let result = avif.resultToStringffi(2)
                        Hilog.error(0,"error","-----version2=${version.toString()}")
                        Hilog.error(0,"error","-----version2=${result.toString()}")
                    }

                Button("test2")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let avif:AvifDecoder = AvifDecoder()
                        let arr1 = getImageFromRawFile("cat.png")
                        unsafe {
                             if(let Some(i) <- arr1){
                                let isavif:Int32 = avif.isAvifImageffi(i)
                                Hilog.error(0,"isAvifImage 1 true 0 false cat.png","-----"+isavif.toString())
                             }
                        }
                        let arr2 = getImageFromRawFile("1.png")
                        unsafe {
                             if(let Some(i) <- arr2){
                                let isavif:Int32 = avif.isAvifImageffi(i)
                                Hilog.error(0,"isAvifImage 1 true 0 false cat.png","-----"+isavif.toString())
                             }
                        }
                        let arr3 = getImageFromRawFile("2.jpg")
                        unsafe {
                             if(let Some(i) <- arr3){
                                let isavif:Int32 = avif.isAvifImageffi(i)
                                Hilog.error(0,"isAvifImage 1 true 0 false cat.png","-----"+isavif.toString())
                             }
                        }
                        let arr4 = getImageFromRawFile("3.jpg")
                        unsafe {
                             if(let Some(i) <- arr4){
                                let isavif:Int32 = avif.isAvifImageffi(i)
                                Hilog.error(0,"isAvifImage 1 true 0 false cat.png","-----"+isavif.toString())
                             }
                        }
                        let arr5 = getImageFromRawFile("4.avif")
                        unsafe {
                             if(let Some(i) <- arr5){
                                let isavif:Int32 = avif.isAvifImageffi(i)
                                Hilog.error(0,"isAvifImage 1 true 0 false cat.png","-----"+isavif.toString())
                             }
                        }

                    }

                 Button("test3")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr5 = getImageFromRawFile("4.avif")
                        let avif:AvifDecoder = AvifDecoder()
                        unsafe {
                            if(let Some(i) <- arr5){
                                 let info:Info = avif.getInfoffi(i)
                                 Hilog.error(0,"avif info","-----info.width = ${info.width} info.height = ${info.height} info.depth = ${info.depth} info.alpha = ${info.alphaPresent}")
                            }
                        }
                    }


                Button("test4")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr5 = getImageFromRawFile("4.avif")
                        let avif:AvifDecoder = AvifDecoder()
                        unsafe {
                            if(let Some(i) <- arr5){
                                 let address:Int64 = avif.createDecoderffi(i,1)
                                 Hilog.error(0,"avif createdecoder","----- address=${address}")
                                 let index = avif.nextFrameIndexffi(address)
                                 Hilog.error(0,"avif createdecoder","----- nextIndex=${index}")
                                 avif.destroyDecoderffi(address)
                                 Hilog.error(0,"avif destroydecoder","----- address=${address}")
                            }
                        }
                    }

                Button("test5")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr = getImageFromRawFile("5.avif")
                        let avif:AvifDecoder = AvifDecoder()
                        unsafe {
                            if(let Some(i) <- arr){
                                 let address:Int64 = avif.createDecoderffi(i,1)
                                 Hilog.error(0,"avif createdecoder","----- address=${address}")
                                 let index = avif.nextFrameIndexffi(address)
                                 Hilog.error(0,"avif createdecoder","----- nextIndex=${index}")
                                 avif.destroyDecoderffi(address)
                                 Hilog.error(0,"avif destroydecoder","----- address=${address}")
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
                        let arr = getImageFromRawFile("a32.avif")
                        let avif:AvifDecoder = AvifDecoder()
                        unsafe {
                            if(let Some(i) <- arr){
                                let address:Int64 = avif.createDecoderffi(i,1)
                                 //创建pixelmap
                                let mWidth = 600
                                let mHeight = 400
                                let colors: Array<UInt8> = Array<UInt8>(mWidth*mHeight*4, repeat: 0)
                                Hilog.error(0,"colorvaluebefore",colors.toString())
                                let pixelMap1 = createPixelMap(colors,InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: Size(width: Int32(mWidth), height: Int32(mHeight))))
                                Hilog.error(0,"avif nextFrameffi","----- 111111")
                                avif.nextFrameffi(address, colors, pixelMap.getImageInfo())
                                //pixelMap1.writeBufferToPixels(colors)
                                 Hilog.error(0,"colorvalueafter",colors.toString())

//https://www.sojson.com/web/panel.html
//                                var path:Path = Path("/data/storage/el2/base/haps/entry/test.txt")
//                                var file: File = File(path,ReadWrite)
//                                for(i in 0..colors.size){
//                                    file.write(colors[i].toString().toArray())
//                                }
//                                file.close()


            //   public init(srcPixelFormat: PixelMapFormat, alphaType!: AlphaType = AlphaType.PREMUL, editable!: Bool = false,
            //        pixelFormat!: PixelMapFormat = PixelMapFormat.BGRA_8888, scaleMode!: ScaleMode = ScaleMode.FIT_TARGET_SIZE,
            //        size!: Size)
                                 let size: Size = Size(width: 600, height: 400)
                                 let opts: InitializationOptions = InitializationOptions(PixelMapFormat.RGBA_8888,editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: Size(width: Int32(mWidth), height: Int32(mHeight)))
                                 pixelMap = createPixelMap(colors, opts)

                            }
                        }
                    }

                 Button("test7")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr = getImageFromRawFile("4.avif")
                        let avif:AvifDecoder = AvifDecoder()
                        unsafe {
                            if(let Some(i) <- arr){
                                let address:Int64 = avif.createDecoderffi(i,1)
                                 //创建pixelmap
                                let mWidth = 600
                                let mHeight = 400
                                let colors: Array<UInt8> = Array<UInt8>(mWidth*mHeight*4, repeat: 0)
                                let pixelMap = createPixelMap(colors,InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: Size(width: Int32(mWidth), height: Int32(mHeight))))
                                Hilog.error(0,"avif nextFrameffi","----- 111111")
                                avif.nthFrameffi(address,0, colors, pixelMap.getImageInfo())
                            }
                        }
                    }

                Button("test8")
                    .fontSize(20)
                    .onClick {
                        evt =>
                        let arr = getImageFromRawFile("4.avif")
                        let avif:AvifDecoder = AvifDecoder()
                        unsafe {
                            if(let Some(i) <- arr){
                                 //创建pixelmap
                                let mWidth = 600
                                let mHeight = 400
                                let colors: Array<UInt8> = Array<UInt8>(mWidth*mHeight*4, repeat: 0)
                                let pixelMap = createPixelMap(colors,InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: Size(width: Int32(mWidth), height: Int32(mHeight))))
                                Hilog.error(0,"avif nextFrameffi","----- 111111")
                                avif.decodeffi(i, colors, pixelMap.getImageInfo())
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
            Hilog.error(0,"getImageFromRawFile","arrsize=${arr.size}")
            return arr
        } catch (e: Exception) {
            return None
        }
    }
}
