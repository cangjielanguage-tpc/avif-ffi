/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package ohos_app_cangjie_avif4hybrid

internal import ohos.component.Image
internal import ohos.component.ImageFit
internal import ohos.hilog.Hilog
import ohos.image.Size
import ohos.image.createPixelMap
import ohos.image.InitializationOptions
import ohos.image.PixelMap
import ohos.image.PixelMapFormat
import std.collection.ArrayList
import ohos.concurrency.launch
import ohos.component.CJImageComplete
import ohos.device_info.DeviceInfo
import ohos.component.If
import ohos.component.CustomView
import ohos.component.ViewBuilder
import ohos.base.Length
import ohos.base.LengthProp
internal import ohos.ark_interop.JSContext
internal import ohos.ark_interop.JSModule
internal import ohos.ark_interop.JSInteropType
import ohos.state_manage.ObservedProperty
import ohos.state_manage.LocalStorage
import ohos.state_manage.SubscriberManager
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.Link
import ohos.state_macro_manage.State
import ohos.state_macro_manage.Builder
import std.time.DateTime
import ohos.ability.getStageContext
import ohos.file_fs.FileFs

@Component
public class AvifImage {

    //图片源数据 必传
    @Link
    var uri: String

    //图片宽度
    @State
    var imagePicWidth: Int64 = 0

    //图片高度
    @State
    var imagePicHeight: Int64 = 0

    //图片控件宽度
    @State
    var imageViewWidth: Length = 100.percent

    //图片控件高度
    @State
    var imageViewHeight: Length = 100.percent

    //图片对齐方式
    @State
    var imageFit: ImageFit = ImageFit.Contain

    //是否可drag
    @State
    var isDraggable: Bool = false

    //左上
    @State
    var topleftBorderRadius: Length = 0.vp

    //右上
    @State
    var toprightBorderRadius: Length = 0.vp

    //左下
    @State
    var bottomleftBorderRadius: Length = 0.vp

    //右下
    @State
    var bottomrightBorderRadius: Length = 0.vp

    @State
    var completeCallBack: Option<(Int32) -> Unit> = Option<(Int32) -> Unit>.None

    //一开始的原始初值
    let size: Size = Size(width: 1, height: 1)
    let opts: InitializationOptions = InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888,
        size: size)
    let color: Array<UInt8> = Array<UInt8>(1 * 1 * 4, repeat: 0)
    @State
    var pixelMap: PixelMap = createPixelMap(color, opts)

    //放在外面 利于回收
    let pixelMapList: ArrayList<PixelMap> = ArrayList<PixelMap>()
    //判断是否是单帧 对后面释放pixelmap有用
    var isSinglePic: Bool = true
    //判断是否结束循环显示
    var isLoop: Bool = true

    var key = ""
    var sjc1 = 0
    var fut:?Future<Unit> = None

    protected override func aboutToAppear() {
        sjc1 = DateTime.now().toUnixTimeStamp().toNanoseconds()
        key = getmd5key(this.uri.toArray(), imagePicWidth, imagePicHeight)
        let memPixelMap: ?CacheBean = memoryLruCache.get(key)
        let fileExist = FileUtils.getInstance().exist(fileLruCache.path + key)
        let multifileExist = FileUtils.getInstance().exist(fileLruCache.path + "multi" + key)

        if (let Some(map) <- memPixelMap) {
            //如果有值
            if(let Some(i) <- map.pixelMap){
                pixelMap = i
                let sjc2 = DateTime.now().toUnixTimeStamp().toNanoseconds()
                Hilog.error(0, "memory", "走的是单图内存缓存 耗时${sjc2 - sjc1}")
                return
            }else{
                //这里是多图的内存缓存逻辑了
                var multiList :?MultiPixelMap = map.getMultiPixelMap()
                if(let Some(j) <- multiList){
                    //表示多图缓存有值
                    let pixelMapList = j.getPixelMapList()
                    let durationList = j.getFrameDurations()
                    Hilog.error(0, "memory", "走的是多图内存缓存")
                    spawn {
                        while (isLoop) {
                            for (k in 0..pixelMapList.size) {
                                let tempPixelMap = pixelMapList.get(k).getOrThrow()
                                launch {
                                    pixelMap = tempPixelMap
                                }
                                sleep(durationList[Int64(k)] * Duration.second)
                            }
                        }
                    }
                    return
                }
            }
          }

        if (fileExist||multifileExist) {
            if(fileExist){
                //单图文件的本地缓存
                spawn {
                    let source:?Array<UInt8> = fileLruCache.get(key)
                    if(let Some(i) <- source){
                        let finalWidth: Int32 = Int32(UInt16(i[0]) << 8 | UInt16(i[1]))
                        let finalHeight: Int32 = Int32(UInt16(i[2]) << 8 | UInt16(i[3]))
                        let colors = i[4..i.size]
                        let size2: Size = Size(width: Int32(finalWidth), height: Int32(finalHeight))
                        let opts: InitializationOptions = InitializationOptions(editable: true,pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                        let tempPixelMap = createPixelMap(colors, opts)
                        let cacheBean:CacheBean = CacheBean(Option<MultiPixelMap>.None,tempPixelMap)
                        memoryLruCache.put(key, cacheBean)
                        launch {
                            let sjc2 = DateTime.now().toUnixTimeStamp().toNanoseconds()
                            Hilog.error(0, "local", "走的是单图本地缓存 耗时${sjc2 - sjc1}")
                            pixelMap = tempPixelMap
                        }
                    }else{
                        Hilog.error(0, "diskcache", "获取的单图本地缓存内容为空")
                    }
                }
            }else{
                //多图文件的本地缓存
                spawn {
                      let source:?Array<UInt8> = fileLruCache.get("multi"+key)
                      if(let Some(i) <- source){
                          dealWithBuffer(i)
                          Hilog.error(0, "local", "走的是多图本地缓存")
                      }else{
                        Hilog.error(0, "diskcache", "获取的多图本地缓存内容为空")
                      }
                 }
            }
            return
        } else {
            if (this.uri.startsWith("http")) {
                //把数据下载下来
                ImgHttp.request(this.uri, {
                    e, imageBuffer => dealWithBuffer(imageBuffer)
                })
            } else if(this.uri.startsWith("rawfile://")){
                let fileName = this.uri.removePrefix("rawfile://")
                let imageBuffer = getImageFromRawFile(fileName)
                dealWithBuffer(imageBuffer)
            } else if(this.uri.startsWith("media://")){
                let mediaName = this.uri.removePrefix("media://")
                let imageBuffer = getImageFromMedia(mediaName)
                dealWithBuffer(imageBuffer)
            } else if(this.uri.startsWith("file://")){
                let localFilePath = this.uri.removePrefix("file://")
                let imageBuffer: ?Array<UInt8> = FileUtils.getInstance().readFileSync(localFilePath)
                dealWithBuffer(imageBuffer)
            }else{
                let localFilePath = this.uri
                let imageBuffer: ?Array<UInt8> = FileUtils.getInstance().readFileSync(localFilePath)
                dealWithBuffer(imageBuffer)
            }
        }
    }

    protected override func aboutToDisappear() {
        isLoop = false
        if(let Some(i) <- fut){
            i.cancel()
        }
    }

    private func doCompleteCallBack(cJImageComplete: CJImageComplete): Unit {
        if (let Some(i) <- completeCallBack) {
            i(cJImageComplete.loadingStatus)
        }
    }

    private func dealWithBuffer(imageBuffer: ?Array<UInt8>): Unit {
        if (let Some(i) <- imageBuffer) {
            let avif: ?AvifDecoder = AvifDecoder.create(i)
            if (let Some(j) <- avif) {
                //分为单帧和多帧
                let frameCount: Int64 = j.getFrameCount()
                var imageTempWidth = j.getWidth()
                var imageTempHeight = j.getHeight()
                if (imagePicWidth != 0) {
                    imageTempWidth = imagePicWidth
                }
                if (imagePicHeight != 0) {
                    imageTempHeight = imagePicHeight
                }
                let imageWidth = imageTempWidth
                let imageHeight = imageTempHeight
                if (frameCount <= 0) {
                    throw Exception("frameCount can not be <= 0")
                } else {
                    if (frameCount == 1) {
                        //单帧图
                        spawn {
                            let colors: Array<UInt8> = Array<UInt8>(Int64(imageWidth * imageHeight * 4), repeat: 0)
                            j.nextFrameffi(colors, Int32(imageWidth), Int32(imageHeight))
                            //根据生成胡color重新生成pixelmap
                            let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
                            let opts: InitializationOptions = InitializationOptions(editable: true,pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                            let tempPixelMap = createPixelMap(colors, opts)
                            launch {
                                let sjc2 = DateTime.now().toUnixTimeStamp().toNanoseconds()
                                Hilog.error(0, "net", "走的是单图网络 耗时${sjc2 - sjc1}")
                                pixelMap = tempPixelMap
                            }
                            //保存一份到本地存储
                            fileLruCache.put(key,colors.size+4,colors,imageWidth,imageHeight)
                            //这里生成了就要保存到内存中
                            let cacheBean:CacheBean = CacheBean(Option<MultiPixelMap>.None,tempPixelMap)
                            memoryLruCache.put(key, cacheBean)
                            j.release()
                        }
                        return
                    } else {
                        //多帧图
                        isSinglePic = false
                        if (j.getFrameDurations().isNone()) {
                            throw Exception("FrameDurations can not be None")
                        }
                        if (j.getFrameDurations().getOrThrow().size != frameCount) {
                            throw Exception("FrameDurations should be equal to frameCount")
                        }
                        let repeatCount:Int64 = j.getRepetitionCount()
                        let durationList: Array<Float64> = j.getFrameDurations().getOrThrow()
                        fut =  spawn {
                            while (isLoop) {
                                if (pixelMapList.size != frameCount) {
                                    for (k in 0..frameCount) {
                                        if (Thread.currentThread.hasPendingCancellation) {
                                            return
                                        }
                                        let colors: Array<UInt8> = Array<UInt8>(Int64(imageWidth * imageHeight * 4),repeat: 0)
                                        j.nthFrameffi(Int32(k), colors, Int32(imageWidth), Int32(imageHeight))
                                        let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
                                        let opts: InitializationOptions = InitializationOptions(editable: true,pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                                        let tempPixelMap = createPixelMap(colors, opts)
                                        launch {
                                            pixelMap = tempPixelMap
                                        }
                                        sleep(durationList[Int64(k)] * Duration.second)
                                        pixelMapList.add(tempPixelMap)
                                        if(pixelMapList.size == frameCount){
                                             j.release()
                                             let multiPixelMap:MultiPixelMap = MultiPixelMap(pixelMapList,durationList,Int32(repeatCount))
                                             let cacheBean:CacheBean = CacheBean(multiPixelMap,Option<PixelMap>.None)
                                             memoryLruCache.put(key, cacheBean)
                                             //仅限网络情况坐下缓存,避免下载
                                             if(this.uri.startsWith("http")){
                                                //网络图片这种情况把文件缓存下来
                                                spawn{
                                                    fileLruCache.put("multi" + key,i.size,i)
                                                }
                                             }
                                        }
                                    }
                                } else {
                                    //这里做内存缓存处理
                                    for (k in 0..pixelMapList.size) {
                                        if (Thread.currentThread.hasPendingCancellation) {
                                            return
                                        }
                                        let tempPixelMap = pixelMapList.get(k).getOrThrow()
                                        launch {
                                            pixelMap = tempPixelMap
                                        }
                                        sleep(durationList[Int64(k)] * Duration.second)
                                    }
                                }
                            }
                        }
                        return
                    }
                }
            } else {
                Hilog.error(0, "aviflog",
                    "AvifDecoder can not be none,maybe the imageBuffer data is not avif format data")
            }
        } else {
            throw Exception("imageBuffer can not be none")
        }
    }

    @Builder
    func Image19() {
        Image(this.pixelMap)
            .width(imageViewWidth)
            .height(imageViewHeight)
            .objectFit(imageFit)
            .borderRadius(topLeft: topleftBorderRadius, topRight: toprightBorderRadius,
                bottomLeft: bottomleftBorderRadius, bottomRight: bottomrightBorderRadius)
            .draggable(isDraggable)
            .onComplete(doCompleteCallBack)
    }

    @Builder
    func Image12() {
        Image(this.pixelMap)
            .width(imageViewWidth)
            .height(imageViewHeight)
            .interopObjectFit(imageFit)
            .borderRadius(topLeft: topleftBorderRadius, topRight: toprightBorderRadius,
                bottomLeft: bottomleftBorderRadius, bottomRight: bottomrightBorderRadius)
            .interopDraggable(isDraggable)
            .onComplete(doCompleteCallBack)
    }

    func build() {
        if (DeviceInfo.sdkApiVersion >= 19) {
            Image19()
        } else {
            Image12()
        }
    }
}
