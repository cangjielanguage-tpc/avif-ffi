package avif4cj

internal import ohos.component.Image
internal import ohos.component.ImageFit
internal import ohos.hilog.Hilog
import ohos.concurrency.launch
import std.sync.AtomicBool
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
    // SEC-M2：pixelMapList 的 add/遍历释放 分属工作线程与 UI 线程，需互斥
    let listMtx = ReentrantMutex()
    //判断是否是单帧 对后面释放pixelmap有用
    var isSinglePic: Bool = true
    //判断是否结束循环显示
    let isLoop = AtomicBool(true)

    var memoryKey = ""
    var mDiskKey = ""
    var fut:?Future<Unit> = None

    protected override func aboutToAppear() {
        memoryKey = getmd5key(this.uri.toArray(), imagePicWidth, imagePicHeight)
        let memPixelMap: ?CacheBean = memoryLruCache.get(memoryKey)

        //多图没有内存缓存，只有单图有，原因多图做内存缓存 管理池很快就满了
        if (let Some(map) <- memPixelMap) {
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
            let fileName = this.uri.removePrefix("rawfile://")
            let imageBuffer = getImageFromRawFile(fileName)
            dealWithBuffer(imageBuffer)
        } else if(this.uri.toAsciiLower().startsWith("media://")){
            let mediaName = this.uri.removePrefix("media://")
            let imageBuffer = getImageFromMedia(mediaName)
            dealWithBuffer(imageBuffer)
        } else if(this.uri.toAsciiLower().startsWith("file://")){
            let localFilePath = this.uri.removePrefix("file://")
            let imageBuffer: ?Array<UInt8> = FileUtils.getInstance().readFileSync(localFilePath)
            dealWithBuffer(imageBuffer)
        }else{
            let localFilePath = this.uri
            let imageBuffer: ?Array<UInt8> = FileUtils.getInstance().readFileSync(localFilePath)
            dealWithBuffer(imageBuffer)
        }
    }

    protected override func aboutToDisappear() {
        isLoop.store(false)
        if(let Some(i) <- fut){
            i.cancel()
        }
        //单帧：展示用 PixelMap 由组件自己持有并负责释放（SEC-M3 修复：缓存不再持有展示对象）
        if(isSinglePic){
            this.pixelMap.release()
        }
        //多帧：SEC-M2 修复——与工作线程的 add 互斥；快照后锁外释放
        else{
            var released: ArrayList<PixelMap> = ArrayList<PixelMap>()
            synchronized(listMtx) {
                for(i in 0..pixelMapList.size){
                    let pixelmap:?PixelMap = pixelMapList.get(i)
                    if(let Some(j) <- pixelmap){
                        released.add(j)
                    }
                }
                pixelMapList.clear()
            }
            for(j in released) {
                j.release()
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
                // SEC-H3 修复：尺寸上限校验（ispe 与开发者透传值共用；Int64 乘法防溢出）
                if (imageWidth > MAX_DIMENSION || imageHeight > MAX_DIMENSION ||
                    imageWidth * imageHeight > MAX_PIXELS) {
                    Hilog.error(0, "aviflog", "image dimensions rejected: ${imageWidth}x${imageHeight}")
                    // SEC-H fix: 拒绝路径必须释放 native 解码器（含 pin 住的编码缓冲）。
                    // 此时尚未进入任何 spawn，j 的所有权仍在当前线程，直接释放即可；
                    // 否则每次“加载—拒绝”泄漏一份解码器 + 编码缓冲（外部输入驱动的 native 泄漏）。
                    j.release()
                    return
                }
                if (frameCount <= 0) {
                    Hilog.error(0, "aviflog","frameCount can not be <= 0")
                    // SEC-H fix: 原先只记日志后落到函数尾部，解码器同样泄漏；补释放后返回
                    j.release()
                    return
                } else {
                    if (frameCount == 1) {
                        //单帧图
                        spawn {
                            // SEC-H fix: 256MiB 级 colors 分配移入 try——分配失败（OOM）时 finally
                            // 仍会执行，解码器与 pin 住的编码缓冲不泄漏（#70 原缺陷的未闭合点）
                            var colors: Array<UInt8> = Array<UInt8>()
                            try {
                                colors = Array<UInt8>(Int64(imageWidth * imageHeight * 4), repeat: 0)
                                // SEC-L3 fix: 校验解码返回码——失败时跳过 PixelMap 创建与缓存写入，
                                // 避免全黑帧污染内存/磁盘缓存
                                let code: Int32 = j.nextFrameffi(colors, Int32(imageWidth), Int32(imageHeight))
                                if (code != 0) {
                                    Hilog.error(0, "aviflog", "nextFrameffi failed, code: ${code}")
                                    return
                                }
                                // create pixelmap from decoded colors
                                let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
                                let opts: InitializationOptions = InitializationOptions(editable: true, pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                                let tempPixelMap = createPixelMap(colors, opts)
                                launch {
                                    pixelMap = tempPixelMap
                                }
                                // cache to disk (http only) and memory
                                let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
                                if (!fileExist && this.uri.toAsciiLower().startsWith("http")) {
                                    fileLruCache.put(mDiskKey, i.size, i)
                                }
                                // SEC-M3 fix: cache stores decoded BYTES, not the displayed PixelMap object.
                                // The component owns its own PixelMap; evicting cached bytes can never
                                // affect a PixelMap currently being rendered (no use-after-release).
                                let cacheBean: CacheBean = CacheBean(colors)
                                cacheBean.setMemoryWidth(imageWidth)
                                cacheBean.setMemoryHeight(imageHeight)
                                cacheBean.setAlphaPresent(j.getAlphaPresent())
                                memoryLruCache.put(memoryKey, cacheBean)
                            } catch (e: Exception) {
                                // SEC-M4 fix: release native decoder even when mid-steps throw (OOM / createPixelMap validation failure)
                                Hilog.error(0, "aviflog", "single frame decode failed: ${e}")
                            } catch (e: Error) {
                                // SEC-H fix: OOM 属 Error 而非 Exception（scope.cj:33 在库先例），补一档保证日志与优雅收尾
                                Hilog.error(0, "aviflog", "single frame decode failed (error): ${e}")
                            } finally {
                                j.release()
                            }
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
                            // SEC-H fix: 多帧校验失败路径释放（fut 尚未创建，所有权未转移，安全）
                            j.release()
                            return
                        }
                        if (j.getFrameDurations().getOrThrow().size != frameCount) {
                            Hilog.error(0, "aviflog","FrameDurations should be equal to frameCount")
                            // SEC-H fix: 同上，fut 尚未创建，安全释放
                            j.release()
                            return
                        }
                        let repeatCount:Int64 = j.getRepetitionCount()
                        let durationList: Array<Float64> = j.getFrameDurations().getOrThrow()
                        fut =  spawn {
                            while (isLoop.load()) {
                                if (pixelMapList.size != frameCount) {
                                    // SEC-H fix: 首轮解码循环整体受 try/catch 保护——循环内 256MiB 级分配 /
                                    // createPixelMap 抛异常时 j 不再泄漏（释放后结束工作线程）；
                                    // 取消路径（循环内 return）不经 catch，无双释放。
                                    try {
                                        for (k in 0..frameCount) {
                                            if (Thread.currentThread.hasPendingCancellation) {
                                                j.release()
                                                return
                                            }
                                            let colors: Array<UInt8> = Array<UInt8>(Int64(imageWidth * imageHeight * 4),repeat: 0)
                                            let code: Int32 = j.nthFrameffi(Int32(k), colors, Int32(imageWidth), Int32(imageHeight))
                                            // SEC-L3 fix: 校验解码返回码——失败帧不产生黑图；解码器仍被后续帧使用，
                                            // 失败即释放并结束工作线程（否则 pixelMapList 永不达 frameCount，完成释放点失效）
                                            if (code != 0) {
                                                Hilog.error(0, "aviflog", "nthFrameffi failed at frame ${k}, code: ${code}")
                                                j.release()
                                                return
                                            }
                                            let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
                                            let opts: InitializationOptions = InitializationOptions(editable: true,pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                                            let tempPixelMap = createPixelMap(colors, opts)
                                            launch {
                                                pixelMap = tempPixelMap
                                            }
                                            sleep(durationList[Int64(k)] * Duration.second)
                                            synchronized(listMtx) {
                                                pixelMapList.add(tempPixelMap)
                                            }
                                            if(pixelMapList.size == frameCount){
                                                 j.release()
                                                 //多图不需要内存缓存
                                            }
                                        }
                                    } catch (e: Exception) {
                                        Hilog.error(0, "aviflog", "multi frame decode failed: ${e}")
                                        j.release()
                                        return
                                    } catch (e: Error) {
                                        Hilog.error(0, "aviflog", "multi frame decode failed (error): ${e}")
                                        j.release()
                                        return
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
