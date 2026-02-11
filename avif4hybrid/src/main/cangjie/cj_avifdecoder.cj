/**
 * Created on 2026/1/4
 */
package ohos_app_cangjie_avif4hybrid

import ohos.ark_interop_macro.Interop
import ohos.concurrency.launch
import ohos.image.Size
import ohos.image.InitializationOptions
import ohos.image.createPixelMap
import ohos.image.PixelMapFormat

@Interop[ArkTS]
public class CJAvifDecoder {
    public init() {
    }

    private var decoder: Option<AvifDecoder> = None
    var mKey = ""
    var mUri = ""

    public func create(uri: String): Option<CJAvifDecoder> {
        return createWithThread(uri, 1)
    }

    public func createWithThread(uri: String, threads: Int32): Option<CJAvifDecoder> {
        this.mUri = uri
        //在这里将uri转化为arryauint8,并生成key
         if (uri.startsWith("http")) {
            //把数据下载下来
            ImgHttp.request(uri, {
                e, imageBuffer => launch{
                    if(let Some(i) <- imageBuffer){
                        return createLoginc(i,threads)
                    }else{
                        if(let Some(j) <- e){
                            Hilog.error(0, "ImgHttp.request", e.toString())
                        }else{
                            Hilog.error(0, "ImgHttp.request", "下载内容失败")
                        }
                        return Option<CJAvifDecoder>.None
                    }
                }
            })
        }else if(uri.startsWith("rawfile://")){
             let fileName = uri.removePrefix("rawfile://")
             let imageBuffer = getImageFromRawFile(fileName)
             if(let Some(i) <- imageBuffer){
                  return createLoginc(i,threads)
             }else{
                  Hilog.error(0, "getImageFromRawFile", "获取raw文件内容失败")
                  return Option<CJAvifDecoder>.None
             }
        }else if(uri.startsWith("media://")){
             let mediaName = uri.removePrefix("media://")
             let imageBuffer = getImageFromMedia(mediaName)
             if(let Some(i) <- imageBuffer){
                  return createLoginc(i,threads)
             }else{
                  Hilog.error(0, "getImageFromMedia", "获取media文件内容失败")
                  return Option<CJAvifDecoder>.None
             }
        }else if(uri.startsWith("file://")){
              let localFilePath = uri.removePrefix("file://")
              let imageBuffer: ?Array<UInt8> = FileUtils.getInstance().readFileSync(localFilePath)
              if(let Some(i) <- imageBuffer){
                  return createLoginc(i,threads)
              }else{
                  Hilog.error(0, "readFileSync", "读取本地文件失败")
                  return Option<CJAvifDecoder>.None
              }
        }else{
              let localFilePath = uri
              let imageBuffer: ?Array<UInt8> = FileUtils.getInstance().readFileSync(localFilePath)
              if(let Some(i) <- imageBuffer){
                  return createLoginc(i,threads)
              }else{
                  Hilog.error(0, "readFileSync", "读取内容失败")
                  return Option<CJAvifDecoder>.None
              }
        }
    }

    private func createLoginc(buffer:Array<UInt8>,threads:Int32):Option<CJAvifDecoder>{
        decoder = AvifDecoder(buffer, threads)
        if(let Some(k) <- decoder){
            if (k.decoder == 0) {
                return Option<CJAvifDecoder>.None
            }
            return this
        }else{
            return Option<CJAvifDecoder>.None
        }
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
            if(let Some(j) <- i.getFrameDurations()){
                return JSArrayEx(j)
            }else{
                return None
            }
        }
        return None
    }

    public func isAvifImageffi(encoded: Array<Byte>): Int32 {
        if (let Some(i) <- decoder) {
            return i.isAvifImageffi(encoded)
        }
        return 0
    }

    public func nextFrameIndexffi(): Int32 {
        if (let Some(i) <- decoder) {
            return i.nextFrameIndexffi()
        }
        return 0
    }

    public func nextFrameffi(imageWidth: Int32, imageHeight: Int32): CJReturnValue {
        let value:CJReturnValue = CJReturnValue()
         if(imageWidth <= 0 || imageHeight <= 0){
            value.issuccess = false
            return value
        }
        //先看多图还是单图
        let count:Int64 = getFrameCount()
        if(count <= 0){
            value.issuccess = false
            return value
        }
        //单图
        //先生成key
        if(count == 1){
            //单图
            mKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
        }else{
            //多图的单张
            let index:Int32 = nextFrameIndexffi()
            mKey = getmd5keyWithIndex(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight),index)
        }
         //根据key判断内存中有没有
        let memPixelMap: ?CacheBean = memoryLruCache.get(mKey)
        if(let Some(cache) <- memPixelMap){
            let pixelMap = cache.getPixelMap()
            if(let Some(i) <- pixelMap){
                let readBuffer: Array<Byte> = Array<Byte>(Int64(imageWidth*imageHeight*4), repeat: 0)
                i.readPixelsToBuffer(readBuffer)
                value.color = readBuffer
                value.issuccess = true
                return value
            }
        }
        //内存没取到考虑本地
        let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mKey)
        if(fileExist){
            //找到本地缓存了
                let source:?Array<UInt8> = fileLruCache.get(mKey)
                if(let Some(i) <- source){
                    let colors = i[4..i.size]
                    spawn{
                        let finalWidth: Int32 = Int32(UInt16(i[0]) << 8 | UInt16(i[1]))
                        let finalHeight: Int32 = Int32(UInt16(i[2]) << 8 | UInt16(i[3]))
                        let size2: Size = Size(width: Int32(finalWidth), height: Int32(finalHeight))
                        let opts: InitializationOptions = InitializationOptions(editable: true,pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                        let tempPixelMap = createPixelMap(colors, opts)
                        let cacheBean:CacheBean = CacheBean(Option<MultiPixelMap>.None,tempPixelMap)
                        memoryLruCache.put(mKey, cacheBean)
                    }
                    value.color = colors
                    value.issuccess = true
                    return value
                }
        }
        //本地也没有
        let color:Array<Byte> = Array<Byte>(Int64(imageWidth*imageHeight*4),repeat:0)
        if (let Some(i) <- decoder) {
            value.code =  i.nextFrameffi(color, imageWidth, imageHeight)
            if(value.code == 0){
                spawn{
                    let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
                    let opts: InitializationOptions = InitializationOptions(editable: true,pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                    let tempPixelMap = createPixelMap(color, opts)
                    let cacheBean:CacheBean = CacheBean(Option<MultiPixelMap>.None,tempPixelMap)
                    memoryLruCache.put(mKey, cacheBean)
                    fileLruCache.put(mKey,color.size+4,color,Int64(imageWidth),Int64(imageHeight))
                }
                value.issuccess = true
                value.color = color
            }else{
                value.issuccess = false
            }
            return value
        }else{
            value.issuccess = false
            return value
        }
    }

    public func nthFrameffi(index: Int32,imageWidth: Int32, imageHeight: Int32): CJReturnValue {
        let value:CJReturnValue = CJReturnValue()
         if(imageWidth <= 0 || imageHeight <= 0){
            value.issuccess = false
            return value
        }
        //先看多图还是单图
        let count:Int64 = getFrameCount()
        if(count <= 0){
            value.issuccess = false
            return value
        }
        //单图
        //先生成key
        if(count == 1){
            //单图
            mKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
        }else{
            //多图的单张
            mKey = getmd5keyWithIndex(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight),index)
        }
         //根据key判断内存中有没有
        let memPixelMap: ?CacheBean = memoryLruCache.get(mKey)
        if(let Some(cache) <- memPixelMap){
            let pixelMap = cache.getPixelMap()
            if(let Some(i) <- pixelMap){
                let readBuffer: Array<Byte> = Array<Byte>(Int64(imageWidth*imageHeight*4), repeat: 0)
                i.readPixelsToBuffer(readBuffer)
                value.color = readBuffer
                value.issuccess = true
                return value
            }
        }
        //内存没取到考虑本地
        let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mKey)
        if(fileExist){
            //找到本地缓存了
                let source:?Array<UInt8> = fileLruCache.get(mKey)
                if(let Some(i) <- source){
                    let colors = i[4..i.size]
                    spawn{
                        let finalWidth: Int32 = Int32(UInt16(i[0]) << 8 | UInt16(i[1]))
                        let finalHeight: Int32 = Int32(UInt16(i[2]) << 8 | UInt16(i[3]))
                        let size2: Size = Size(width: Int32(finalWidth), height: Int32(finalHeight))
                        let opts: InitializationOptions = InitializationOptions(editable: true,pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                        let tempPixelMap = createPixelMap(colors, opts)
                        let cacheBean:CacheBean = CacheBean(Option<MultiPixelMap>.None,tempPixelMap)
                        memoryLruCache.put(mKey, cacheBean)
                    }
                    value.color = colors
                    value.issuccess = true
                    return value
                }
        }
        //本地也没有
        let color:Array<Byte> = Array<Byte>(Int64(imageWidth*imageHeight*4),repeat:0)
        if (let Some(i) <- decoder) {
            if(count == 1){
                //单图index默认0
                value.code =  i.nthFrameffi(0,color, imageWidth, imageHeight)
            }else{
                //多图
                value.code =  i.nthFrameffi(index,color, imageWidth, imageHeight)
            }
            if(value.code == 0){
                spawn{
                    let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
                    let opts: InitializationOptions = InitializationOptions(editable: true,pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                    let tempPixelMap = createPixelMap(color, opts)
                    let cacheBean:CacheBean = CacheBean(Option<MultiPixelMap>.None,tempPixelMap)
                    memoryLruCache.put(mKey, cacheBean)
                    fileLruCache.put(mKey,color.size+4,color,Int64(imageWidth),Int64(imageHeight))
                }
                value.issuccess = true
                value.color = color
            }else{
                value.issuccess = false
            }
            return value
        }else{
            value.issuccess = false
            return value
        }
    }


    //这种会底层C会重新创建decoder,因此多图情况只能解码第一帧,单图不影响
    public func decodeffi(encoded: Array<Byte>, imageWidth: Int32, imageHeight: Int32): CJReturnValue {
        let value:CJReturnValue = CJReturnValue()
         if(imageWidth <= 0 || imageHeight <= 0){
            value.issuccess = false
            return value
        }
        //先看多图还是单图
        let count:Int64 = getFrameCount()
        if(count <= 0){
            value.issuccess = false
            return value
        }
        //单图
        //先生成key
        if(count == 1){
            //单图
            mKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
        }else{
            //多图的单张
            mKey = getmd5keyWithIndex(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight),0)
        }
         //根据key判断内存中有没有
        let memPixelMap: ?CacheBean = memoryLruCache.get(mKey)
        if(let Some(cache) <- memPixelMap){
            let pixelMap = cache.getPixelMap()
            if(let Some(i) <- pixelMap){
                let readBuffer: Array<Byte> = Array<Byte>(Int64(imageWidth*imageHeight*4), repeat: 0)
                i.readPixelsToBuffer(readBuffer)
                value.color = readBuffer
                value.issuccess = true
                return value
            }
        }
        //内存没取到考虑本地
        let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mKey)
        if(fileExist){
            //找到本地缓存了
                let source:?Array<UInt8> = fileLruCache.get(mKey)
                if(let Some(i) <- source){
                    let colors = i[4..i.size]
                    spawn{
                        let finalWidth: Int32 = Int32(UInt16(i[0]) << 8 | UInt16(i[1]))
                        let finalHeight: Int32 = Int32(UInt16(i[2]) << 8 | UInt16(i[3]))
                        let size2: Size = Size(width: Int32(finalWidth), height: Int32(finalHeight))
                        let opts: InitializationOptions = InitializationOptions(editable: true,pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                        let tempPixelMap = createPixelMap(colors, opts)
                        let cacheBean:CacheBean = CacheBean(Option<MultiPixelMap>.None,tempPixelMap)
                        memoryLruCache.put(mKey, cacheBean)
                    }
                    value.color = colors
                    value.issuccess = true
                    return value
                }
        }
        //本地也没有
        let color:Array<Byte> = Array<Byte>(Int64(imageWidth*imageHeight*4),repeat:0)
        if (let Some(i) <- decoder) {
            value.issuccess = i.decodeffi(encoded, color, imageWidth, imageHeight)
            if(value.issuccess){
                spawn{
                    let size2: Size = Size(width: Int32(imageWidth), height: Int32(imageHeight))
                    let opts: InitializationOptions = InitializationOptions(editable: true,pixelFormat: PixelMapFormat.RGBA_8888, size: size2)
                    let tempPixelMap = createPixelMap(color, opts)
                    let cacheBean:CacheBean = CacheBean(Option<MultiPixelMap>.None,tempPixelMap)
                    memoryLruCache.put(mKey, cacheBean)
                    fileLruCache.put(mKey,color.size+4,color,Int64(imageWidth),Int64(imageHeight))
                }
                value.color = color
            }else{
                value.issuccess = false
            }
            return value
        }else{
            value.issuccess = false
            return value
        }
    }

    public func release(): Unit {
        if (let Some(i) <- decoder) {
            return i.release()
        }
    }
}
