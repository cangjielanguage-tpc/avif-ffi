package ohos_app_cangjie_avif4hybrid

import ohos.ark_interop_macro.Interop

public class AvifDecoderWrap {
    public init() {
    }

    private var decoder: Option<AvifDecoder> = None
    var memoryKey = ""
    var diskKey = ""
    var uri = ""
    var encoded: ?Array<Byte> = None
    var isNotAvif:Bool = false

    public func create(uri: String): Option<AvifDecoderWrap> {
        return createWithThread(uri, 1)
    }

    public func createCompatibleOtherPic(uri: String): Option<AvifDecoderWrap> {
        return createWithThreadCompatibleOtherPic(uri, 1)
    }

    public func createWithThread(uri: String, threads: Int32): Option<AvifDecoderWrap> {
        this.uri = uri
        //在这里将uri转化为arryauint8,并生成key
        if (uri.startsWith("http")) {
            //把数据下载下来
            //下面是网络去下载
            let mDiskKey: String = getmd5key(this
                .uri
                .toArray())
            let fileExist = FileUtils
                .getInstance()
                .exist(fileLruCache.path + mDiskKey)
            if (fileExist) {
                let source: ?Array<UInt8> = FileUtils.getInstance().readFileSync(fileLruCache.path + mDiskKey)
                if (let Some(i) <- source) {
                    return createLoginc(i, threads)
                }
            }
            let imageBuffer = getImageFromNet(uri)
            if (let Some(i) <- imageBuffer) {
                return createLoginc(i, threads)
            } else {
                Hilog.error(0, "getImageFromNet", "获取网络文件内容失败")
                return Option<AvifDecoderWrap>.None
            }
        } else if (uri.startsWith("rawfile://")) {
            let fileName = uri.removePrefix("rawfile://")
            let imageBuffer = getImageFromRawFile(fileName)
            if (let Some(i) <- imageBuffer) {
                return createLoginc(i, threads)
            } else {
                Hilog.error(0, "getImageFromRawFile", "获取raw文件内容失败")
                return Option<AvifDecoderWrap>.None
            }
        } else if (uri.startsWith("media://")) {
            let mediaName = uri.removePrefix("media://")
            let imageBuffer = getImageFromMedia(mediaName)
            if (let Some(i) <- imageBuffer) {
                return createLoginc(i, threads)
            } else {
                Hilog.error(0, "getImageFromMedia", "获取media文件内容失败")
                return Option<AvifDecoderWrap>.None
            }
        } else if (uri.startsWith("file://")) {
            let localFilePath = uri.removePrefix("file://")
            let imageBuffer: ?Array<UInt8> = FileUtils
                .getInstance()
                .readFileSync(localFilePath)
            if (let Some(i) <- imageBuffer) {
                return createLoginc(i, threads)
            } else {
                Hilog.error(0, "readFileSync", "读取本地文件失败")
                return Option<AvifDecoderWrap>.None
            }
        } else {
            let localFilePath = uri
            let imageBuffer: ?Array<UInt8> = FileUtils
                .getInstance()
                .readFileSync(localFilePath)
            if (let Some(i) <- imageBuffer) {
                return createLoginc(i, threads)
            } else {
                Hilog.error(0, "readFileSync", "读取内容失败")
                return Option<AvifDecoderWrap>.None
            }
        }
    }

    public func createWithThreadCompatibleOtherPic(uri: String, threads: Int32): Option<AvifDecoderWrap> {
        this.uri = uri
        //在这里将uri转化为arryauint8,并生成key
        if (uri.startsWith("http")) {
            //把数据下载下来
            //下面是网络去下载
            let mDiskKey: String = getmd5key(this
                .uri
                .toArray())
            let fileExist = FileUtils
                .getInstance()
                .exist(fileLruCache.path + mDiskKey)
            if (fileExist) {
                let source: ?Array<UInt8> = FileUtils.getInstance().readFileSync(fileLruCache.path + mDiskKey)
                if (let Some(i) <- source) {
                    if(i.size == 1){
                        return createLogincCompatibleOtherPic2()
                    }else{
                        return createLogincCompatibleOtherPic(i, threads)
                    }
                }
            }
            let TupleData = getImageFromNet2(uri)
             if(let Some(isAvif) <- TupleData[1]){
                if(!isAvif){
                    //表示不是avif图
                    return createLogincCompatibleOtherPic2()
                }
             }
            if (let Some(i) <- TupleData[0]) {
                return createLogincCompatibleOtherPic(i, threads)
            } else {
                Hilog.error(0, "getImageFromNet", "获取网络文件内容失败")
                return Option<AvifDecoderWrap>.None
            }
        } else if (uri.startsWith("rawfile://")) {
            let fileName = uri.removePrefix("rawfile://")
            let imageBuffer = getImageFromRawFile(fileName)
            if (let Some(i) <- imageBuffer) {
                return createLogincCompatibleOtherPic(i, threads)
            } else {
                Hilog.error(0, "getImageFromRawFile", "获取raw文件内容失败")
                return Option<AvifDecoderWrap>.None
            }
        } else if (uri.startsWith("media://")) {
            let mediaName = uri.removePrefix("media://")
            let imageBuffer = getImageFromMedia(mediaName)
            if (let Some(i) <- imageBuffer) {
                return createLogincCompatibleOtherPic(i, threads)
            } else {
                Hilog.error(0, "getImageFromMedia", "获取media文件内容失败")
                return Option<AvifDecoderWrap>.None
            }
        } else if (uri.startsWith("file://")) {
            let localFilePath = uri.removePrefix("file://")
            let imageBuffer: ?Array<UInt8> = FileUtils
                .getInstance()
                .readFileSync(localFilePath)
            if (let Some(i) <- imageBuffer) {
                return createLogincCompatibleOtherPic(i, threads)
            } else {
                Hilog.error(0, "readFileSync", "读取本地文件失败")
                return Option<AvifDecoderWrap>.None
            }
        } else {
            let localFilePath = uri
            let imageBuffer: ?Array<UInt8> = FileUtils
                .getInstance()
                .readFileSync(localFilePath)
            if (let Some(i) <- imageBuffer) {
                return createLogincCompatibleOtherPic(i, threads)
            } else {
                Hilog.error(0, "readFileSync", "读取内容失败")
                return Option<AvifDecoderWrap>.None
            }
        }
    }

    func createLoginc(buffer: Array<UInt8>, threads: Int32): Option<AvifDecoderWrap> {
        encoded = buffer
        decoder = AvifDecoder(buffer, threads)
        if (let Some(k) <- decoder) {
            if (k.decoder == 0) {
                return Option<AvifDecoderWrap>.None
            }
            return this
        } else {
            return Option<AvifDecoderWrap>.None
        }
    }

    func createLogincCompatibleOtherPic(buffer: Array<UInt8>, threads: Int32): Option<AvifDecoderWrap> {
        encoded = buffer
        decoder = AvifDecoder(buffer, threads)
        if (let Some(k) <- decoder) {
            if (k.decoder == 0) {
                return Option<AvifDecoderWrap>.None
            }
            return this
        } else {
            return Option<AvifDecoderWrap>.None
        }
    }

    func createLogincCompatibleOtherPic2(): Option<AvifDecoderWrap> {
            //当不是avif图片时候进入这里,这里我把数据缓存
            let avifDecoderWrap:AvifDecoderWrap = AvifDecoderWrap()
            avifDecoderWrap.isNotAvif = true
            //这里给他缓存
            spawn {
                  memoryKey = getmd5key(this.uri.toArray(), 0, 0) + "notcomponent"
                  memoryLruCache.put(memoryKey, CacheBean(Option<PixelMap>.None,[0]))

                 let mDiskKey: String = getmd5key(this.uri.toArray())
                 let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
                 if (!fileExist && this.uri.startsWith("http")) {
                     fileLruCache.put(mDiskKey,1,[0])
                 }
            }
            return avifDecoderWrap
    }

    public func getWidth(): Int64 {
        if (let Some(i) <- decoder) {
            return i.getWidth()
        }
        return 0
    }

    public func getHeight(): Int64 {
        if (let Some(i) <- decoder) {
            return i.getHeight()
        }
        return 0
    }

    public func getDepth(): Int64 {
        if (let Some(i) <- decoder) {
            return i.getDepth()
        }
        return 0
    }

    public func getAlphaPresent(): Bool {
        if (let Some(i) <- decoder) {
            return i.getAlphaPresent()
        }
        return false
    }

    public func getFrameCount(): Int64 {
        if (let Some(i) <- decoder) {
            return i.getFrameCount()
        }
        return 0
    }

    public func getRepetitionCount(): Int64 {
        if (let Some(i) <- decoder) {
            return i.getRepetitionCount()
        }
        return 0
    }

    public func getFrameDurations(): Option<JSArrayEx<Float64>> {
        if (let Some(i) <- decoder) {
            if (let Some(j) <- i.getFrameDurations()) {
                return JSArrayEx(j)
            } else {
                return None
            }
        }
        return None
    }

    public func isAvifImageffi(): Int32 {
        if (let Some(i) <- decoder) {
            if (let Some(j) <- encoded) {
                return i.isAvifImageffi(j)
            }
        }
        return 0
    }

    public func nextFrameIndexffi(): Int32 {
        if (let Some(i) <- decoder) {
            return i.nextFrameIndexffi()
        }
        return 0
    }

    // 废弃
    public func nextFrameffi(imageWidth: Int32, imageHeight: Int32): ReturnValue {
        let value: ReturnValue = ReturnValue()
        if (imageWidth < 0 || imageHeight < 0) {
            value.isSuccess = false
            return value
        }
        //先看多图还是单图
        let count: Int64 = getFrameCount()
        if (count <= 0) {
            value.isSuccess = false
            return value
        }
        //单图
        //先生成key
        //多图有本地缓存，没有内存缓存
        diskKey = getmd5key(this
            .uri
            .toArray())
        if (count == 1) {
            //单图不仅有本地缓存 还有内存缓存
            memoryKey = getmd5key(this
                .uri
                .toArray(), Int64(imageWidth), Int64(imageHeight)) + "notcomponent"
        }

        //如果宽高为0 则为图片的原始宽高
        var realPicWidth = imageWidth
        var realPicHeight = imageHeight
        if (imageWidth == 0) {
            realPicWidth = Int32(getWidth())
        }
        if (imageHeight == 0) {
            realPicHeight = Int32(getHeight())
        }

        //内存也没有
        let color: Array<Byte> = Array<Byte>(Int64(realPicWidth * realPicHeight * 4), repeat: 0)
        if (let Some(i) <- decoder) {
            value.code = i.nextFrameffi(color, realPicWidth, realPicHeight)
            let cacheWidth = realPicWidth
            let cacheHeight = realPicHeight
            if (value.code == 0) {
                spawn {
                    //单图才走内存缓存
                    if (count == 1) {
                        let cacheBean: CacheBean = CacheBean(Option<PixelMap>.None, color)
                        cacheBean.setMemoryWidth(Int64(cacheWidth))
                        cacheBean.setMemoryHeight(Int64(cacheHeight))
                        // 注意：alphaPremultiplied 已改为 AVIF_FALSE（非预乘模式）
                        // 需要正确传递 alpha 状态，以避免透明图片显示全黑或灰色
                        cacheBean.setAlphaPresent(getAlphaPresent())
                        memoryLruCache.put(memoryKey, cacheBean)
                    }
                    if (let Some(j) <- encoded) {
                        let fileExist = FileUtils
                            .getInstance()
                            .exist(fileLruCache.path + diskKey)
                        if (!fileExist && this.uri.startsWith("http")) {
                            fileLruCache.put(diskKey, j.size, j)
                        }
                    }
                }
                value.isSuccess = true
                value.color = color
            } else {
                value.isSuccess = false
            }
            return value
        } else {
            value.isSuccess = false
            return value
        }
    }

    // 废弃了
    public func nthFrameffi(index: Int32, imageWidth: Int32, imageHeight: Int32): ReturnValue {
        let value: ReturnValue = ReturnValue()
        if (imageWidth < 0 || imageHeight < 0) {
            value.isSuccess = false
            return value
        }
        //先看多图还是单图
        let count: Int64 = getFrameCount()
        if (count <= 0) {
            value.isSuccess = false
            return value
        }
        //单图
        //先生成key
        diskKey = getmd5key(this
            .uri
            .toArray())
        if (count == 1) {
            //单图
            memoryKey = getmd5key(this
                .uri
                .toArray(), Int64(imageWidth), Int64(imageHeight)) + "notcomponent"
        }

        //如果宽高为0 则为图片的原始宽高
        var realPicWidth = imageWidth
        var realPicHeight = imageHeight
        if (imageWidth == 0) {
            realPicWidth = Int32(getWidth())
        }
        if (imageHeight == 0) {
            realPicHeight = Int32(getHeight())
        }

        //内存没有
        let color: Array<Byte> = Array<Byte>(Int64(realPicWidth * realPicHeight * 4), repeat: 0)
        if (let Some(i) <- decoder) {
            if (count == 1) {
                //单图index默认0
                value.code = i.nthFrameffi(0, color, realPicWidth, realPicHeight)
            } else {
                //多图
                value.code = i.nthFrameffi(index, color, realPicWidth, realPicHeight)
            }
            let cacheWidth = realPicWidth
            let cacheHeight = realPicHeight
            if (value.code == 0) {
                spawn {
                    if (count == 1) {
                        let cacheBean: CacheBean = CacheBean(Option<PixelMap>.None, color)
                        cacheBean.setMemoryWidth(Int64(cacheWidth))
                        cacheBean.setMemoryHeight(Int64(cacheHeight))
                        // 注意：alphaPremultiplied 已改为 AVIF_FALSE（非预乘模式）
                        // 需要正确传递 alpha 状态，以避免透明图片显示全黑或灰色
                        cacheBean.setAlphaPresent(getAlphaPresent())
                        memoryLruCache.put(memoryKey, cacheBean)
                    }
                    if (let Some(j) <- encoded) {
                        let fileExist = FileUtils
                            .getInstance()
                            .exist(fileLruCache.path + diskKey)
                        if (!fileExist && this.uri.startsWith("http")) {
                            fileLruCache.put(diskKey, j.size, j)
                        }
                    }
                }
                value.isSuccess = true
                value.color = color
            } else {
                value.isSuccess = false
            }
            return value
        } else {
            value.isSuccess = false
            return value
        }
    }

    public func release(): Unit {
        if (let Some(i) <- decoder) {
            return i.release()
        }
    }

    public func nthFrameffi(index: Int32, pixels: CPointer<UInt8>, imageWidth: Int32, imageHeight: Int32): Int32 {
        if (imageWidth < 0 || imageHeight < 0) {
            return -1
        }
        if (getFrameCount() <= 0) {
            return -1
        }
        if (let Some(i) <- decoder) {
            let ret = i.nthFrameffi(index, pixels, imageWidth, imageHeight)
            if (ret == 0) {
                let mDiskKey: String = getmd5key(this.uri.toArray())
                spawn {
                    if (let Some(j) <- encoded) {
                        let fileExist = FileUtils
                            .getInstance()
                            .exist(fileLruCache.path + mDiskKey)
                        if (!fileExist && this.uri.startsWith("http")) {
                            fileLruCache.put(mDiskKey, j.size, j)
                        }
                    }
                }
            }
            return ret
        }
        return -1
    }
}
