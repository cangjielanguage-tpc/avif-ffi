package avif4cj

internal import ohos.component.Image
internal import ohos.component.ImageFit
internal import ohos.hilog.Hilog
import ohos.concurrency.launch
import ohos.component.CJImageComplete
internal import ohos.file_fs.FileFs
internal import ohos.ark_interop.JSContext
internal import ohos.ark_interop.JSModule
internal import ohos.ark_interop.JSInteropType
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.Link
import ohos.state_macro_manage.State
import ohos.state_macro_manage.Builder
internal import ohos.file_fs.Stat
internal import ohos.file_fs.OpenMode
internal import ohos.image.PixelMap
internal import ohos.image.PixelMapFormat
internal import ohos.image.createPixelMap
internal import ohos.image.InitializationOptions
internal import ohos.image.Size
internal import ohos.base.Length
internal import ohos.base.LengthType
internal import ohos.ark_interop.JSObject
internal import std.time.DateTime
internal import std.collection.ArrayList
internal import std.sync.ReentrantMutex
internal import std.convert.Parsable
internal import ohos.device_info.DeviceInfo
internal import ohos.base.LengthProp
internal import stdx.net.http.ClientBuilder
internal import stdx.net.tls.common.{CertificateVerifyMode}
internal import stdx.net.tls.TlsClientConfig
internal import stdx.crypto.digest.MD5
internal import stdx.encoding.hex.toHexString
internal import ohos.component.CustomView
internal import ohos.state_manage.ViewStackProcessor
internal import ohos.state_manage.ObservedProperty
internal import ohos.resource_manager.ResourceManager
internal import ohos.ark_interop.JSCallInfo
internal import ohos.ark_interop.JSValue
internal import ohos.component.Column
internal import ohos.ark_interop.SharedObject
internal import ohos.ark_interop.JSCurrentJSContext
internal import ohos.ark_interop.JSArrayEx
internal import ohos.ark_interop.JSExternal
internal import ohos.ark_interop.JSType
internal import ohos.component.ViewBuilder
internal import ohos.component.If
internal import ohos.component.ReuseParams
internal import ohos.component.__Recycle__
internal import ohos.component.FakeComponent
internal import ohos.component.LegalCallCheck
internal import ohos.state_manage.LocalStorage
internal import ohos.state_manage.SubscriberManager
internal import ohos.ark_interop_helper.StageContext
internal import ohos.ark_interop_helper.arkTsValuetoNapiValue
internal import ohos.ark_interop_helper.isStageMode
internal import ohos.ark_interop_helper.getContextStageMode


@Component
public class AvifImage {

    //图片源数据 必传
    @Link
    var uri: String

    //图片宽度 //这个值要设置setImagePicWidth才有用，不然就是0
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

    var memoryKey = ""
    var mDiskKey = ""
    var fut:?Future<Unit> = None

    protected override func aboutToAppear() {
        memoryKey = getmd5key(this.uri.toArray(), imagePicWidth, imagePicHeight)
        let memPixelMap: ?CacheBean = memoryLruCache.get(memoryKey)

        //多图没有内存缓存，只有单图有，原因多图做内存缓存 管理池很快就满了
        if (let Some(map) <- memPixelMap) {
            //如果有值,组件这边保存的是pixelMap,接口那边因为互操作保存的是Array<UInt8>
            if(let Some(i) <- map.getPixelMap()){
                pixelMap = i
                return
            }
            if(let Some(i) <- map.getPicData()){
                try{
                    //如果是接口那边有字节数据的内存缓存，用仓颉接口转换
                    let size2: Size = Size(width: Int32(map.memoryWidth), height: Int32(map.memoryHeight))
                    let opts: InitializationOptions = InitializationOptions(editable: true,pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                    let tempPixelMap = createPixelMap(i, opts)
                    pixelMap = tempPixelMap
                    return
                }catch (e:Exception){
                    Hilog.error(0,"avifErrInfo","e=${e.toString()}")
                }
            }
        }
        //内存缓存优先级最高,上面是所有类型图的内存缓存
        //下面是本地缓存，只有http的网络图有本地缓存
        if (this.uri.toAsciiLower().startsWith("http")) {
            mDiskKey =  getmd5key(this.uri.toArray())
            let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
            if(fileExist){
                //如果本地缓存存在
                spawn{
                    let source:?Array<UInt8> = fileLruCache.get(mDiskKey)
                    if(let Some(i) <- source){
                        //本地缓存文件有数据
                        //如果是url图片 判断本地缓存正不正常
                        let avif: ?AvifDecoder = AvifDecoder.create(i)
                        if(avif.isSome()){
                            //表示是正常的
                            dealWithBuffer2(avif.getOrThrow(),i)
                        }else{
                            //表示可能图片已坏 先删掉本地
                             fileLruCache.remove(mDiskKey)
                             FileUtils.getInstance().deleteFile(fileLruCache.path + mDiskKey)
                             //重新去获取
                             let imageBuffer = getImageFromNet(this.uri)
                             dealWithBuffer(imageBuffer)
                        }
                    }else{
                        //本地缓存文件没有数据
                        //表示可能图片已坏 先删掉本地
                        fileLruCache.remove(mDiskKey)
                        FileUtils.getInstance().deleteFile(fileLruCache.path + mDiskKey)
                        let imageBuffer = getImageFromNet(this.uri)
                        dealWithBuffer(imageBuffer)
                    }
                }
            }else{
                //不存在 把数据下载下来
                spawn {
                    let imageBuffer = getImageFromNet(this.uri)
                    dealWithBuffer(imageBuffer)
                }
            }
            return
        } else if(this.uri.toAsciiLower().startsWith("rawfile://")){
            let fileName = String(this.uri.toRuneArray().slice(10,this.uri.size-10))
            let imageBuffer = getImageFromRawFile(fileName)
            dealWithBuffer(imageBuffer)
        } else if(this.uri.toAsciiLower().startsWith("media://")){
            let mediaName = String(this.uri.toRuneArray().slice(8,this.uri.size-8))
            let imageBuffer = getImageFromMedia(mediaName)
            dealWithBuffer(imageBuffer)
        } else if(this.uri.toAsciiLower().startsWith("file://")){
            let localFilePath = String(this.uri.toRuneArray().slice(7,this.uri.size-7))
            let imageBuffer: ?Array<UInt8> = FileUtils.getInstance().readFileSync(localFilePath)
            dealWithBuffer(imageBuffer)
        }else{
            let localFilePath = this.uri
            let imageBuffer: ?Array<UInt8> = FileUtils.getInstance().readFileSync(localFilePath)
            dealWithBuffer(imageBuffer)
        }
    }

    protected override func aboutToDisappear() {
        isLoop = false
        if(let Some(i) <- fut){
            i.cancel()
        }
        //多图情况pixelmap得释放
        if(!isSinglePic){
            for(i in 0..pixelMapList.size){
                let pixelmap:?PixelMap = pixelMapList.get(i)
                if(let Some(j) <- pixelmap){
                    j.release()
                }
            }
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
                dealWithBuffer2(j,i)
            } else {
                Hilog.error(0, "aviflog",
                    "AvifDecoder can not be none,maybe the imageBuffer data is not avif format data")
            }
        } else {
            Hilog.error(0, "aviflog", "imageBuffer can not be none")
        }
    }

    private func dealWithBuffer2(j: AvifDecoder,i:Array<UInt8>): Unit {
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
                    Hilog.error(0, "aviflog","frameCount can not be <= 0")
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
                                pixelMap = tempPixelMap
                            }
                            //保存一份到本地存储 单图需要本地缓存
                            let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
                            if(!fileExist && this.uri.toAsciiLower().startsWith("http")){
                                 fileLruCache.put(mDiskKey,i.size,i)
                            }
                            //这里生成了就要保存到内存中 单图需要内存缓存
                            let cacheBean:CacheBean = CacheBean(tempPixelMap,Option<Array<UInt8>>.None)
                            memoryLruCache.put(memoryKey, cacheBean)
                            j.release()
                        }
                        return
                    } else {
                        //多帧图
                         isSinglePic = false
                         //仅限网络情况坐下缓存,避免下载
                         let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
                         if(!fileExist && this.uri.toAsciiLower().startsWith("http")){
                            //网络图片这种情况把文件缓存下来
                            spawn{
                                //多图需要本地缓存
                                fileLruCache.put(mDiskKey,i.size,i)
                            }
                         }
                        if (j.getFrameDurations().isNone()) {
                            Hilog.error(0, "aviflog","FrameDurations can not be None")
                            return
                        }
                        if (j.getFrameDurations().getOrThrow().size != frameCount) {
                            Hilog.error(0, "aviflog","FrameDurations should be equal to frameCount")
                            return
                        }
                        let repeatCount:Int64 = j.getRepetitionCount()
                        let durationList: Array<Float64> = j.getFrameDurations().getOrThrow()
                        fut =  spawn {
                            while (isLoop) {
                                if (pixelMapList.size != frameCount) {
                                    for (k in 0..frameCount) {
                                        if (Thread.currentThread.hasPendingCancellation) {
                                            j.release()
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
                                             //多图不需要内存缓存
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
