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



    public func createCompatibleOtherPic(uri: String): Option<AvifDecoderWrap> {
        return createWithThreadCompatibleOtherPic(uri, 1)
    }


    public func createWithThreadCompatibleOtherPic(uri: String, threads: Int32): Option<AvifDecoderWrap> {
        this.uri = uri
        //在这里将uri转化为arryauint8,并生成key
        if (uri.toAsciiLower().startsWith("http")) {
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
                 if (!fileExist && this.uri.toAsciiLower().startsWith("http")) {
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
                        if (!fileExist && this.uri.toAsciiLower().startsWith("http")) {
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
