package avif4cj


@FastNative
foreign func isAvifImage(result: CPointer<UInt8>, length: Int32): Int32

@FastNative
foreign func getInfo(result: CPointer<UInt8>, length: Int32): CPointer<Info>

@FastNative
foreign func encodedFree(encoded: CPointer<Info>): Unit

@FastNative
foreign func encoded2Free(encoded: CPointer<DecoderInfo>): Unit

@FastNative
foreign func encoded3Free(encoded: CPointer<Float64>): Unit

@FastNative
foreign func createDecoder(result: CPointer<UInt8>, length: Int32, threads: Int32): CPointer<DecoderInfo>

@FastNative
foreign func destroyDecoder(decoder: Int64): Unit

@FastNative
foreign func nextFrameIndex(decoder: Int64): Int32

@FastNative
foreign func nextFrame(decoder: Int64, pixels: CPointer<UInt8>, picwidth: Int32, picheight: Int32, stride: Int32,
    formatvalue: Int32): Int32

@FastNative
foreign func nthFrame(decoder: Int64, index: Int32, pixels: CPointer<UInt8>, picwidth: Int32, picheight: Int32,
    stride: Int32, formatvalue: Int32): Int32

@FastNative
foreign func decode(result: CPointer<UInt8>, length: Int32, pixels: CPointer<UInt8>, picwidth: Int32, picheight: Int32,
    stride: Int32, formatvalue: Int32, threads: Int32): Bool

// SEC-H3/H：解码尺寸上限——AVIF 头（ispe）声明的宽高与开发者透传值均为外部输入。
// 维度上限 16384：覆盖 200MP 相机照片（16320×12240）、8K、主流全景图；总像素上限 67M（≈256MB RGBA）是真正的内存闸门。
const MAX_DIMENSION: Int64 = 16384
const MAX_PIXELS: Int64 = 8192 * 8192

public class AvifDecoder {
    var decoder: Int64 = 0

    private var width: Int64 = 0
    private var height: Int64 = 0
    private var depth: Int64 = 0
    private var alphaPresent: Bool = false
    private var frameCount: Int64 = 0
    private var repetitionCount: Int64 = 0
    private var frameDurations: ?Array<Float64> = None

    private var handle: ?CPointerHandle<UInt8> = None

    private func createDecoderffi(encoded: Array<UInt8>, threads: Int32): DecoderInfo {
        unsafe {
            handle = acquireArrayRawData(encoded)
            if(let Some(i) <- handle){
                var result: CPointer<DecoderInfo> = createDecoder(i.pointer, Int32(encoded.size), threads)
                if (result.isNull()) {
                    releaseArrayRawData<UInt8>(i)
                    handle = None    // 防止二次释放（SEC-M4 顺带修复）
                    return DecoderInfo(0, CPointer<Info>())
                }
                let res: DecoderInfo = result.read()
                encoded2Free(result)
                return res
            }else{
                return DecoderInfo(0, CPointer<Info>())
            }
        }
    }

    private func destroyDecoderffi(address: Int64): Unit {
        unsafe {
            if(let Some(i) <- handle){
                releaseArrayRawData<UInt8>(i)
                handle = None    // 防止二次释放
            }
            destroyDecoder(address)
        }
    }

    init(encoded: Array<UInt8>, threads: Int32) {
        let decoderInfo: DecoderInfo = createDecoderffi(encoded, threads)
        decoder = decoderInfo.address
        let cpointInfo: CPointer<Info> = decoderInfo.info
        unsafe {
            // 供异常路径释放的 native 资源（SEC-M4 修复：构造中断时的泄漏）
            var durationsPoint: CPointer<Float64> = CPointer<Float64>()
            try {
                if (decoder != 0) {
                    let info: Info = cpointInfo.read()
                    width = Int64(info.width)
                    height = Int64(info.height)
                    depth = Int64(info.depth)
                    alphaPresent = info.alphaPresent
                    // SEC-H3 修复：宽高来自外部文件头（ispe），使用前必须校验上限；
                    // 超限 = 异常/恶意输入：释放全部 native 资源后按解码失败返回（上层走下一层缓存）
                    if (Int64(info.width) > MAX_DIMENSION || Int64(info.height) > MAX_DIMENSION) {
                        Hilog.error(0, "aviflog", "image dimensions rejected: ${info.width}x${info.height}")
                        encoded3Free(info.frameDurations)
                        encodedFree(cpointInfo)
                        destroyDecoderffi(decoder)
                        decoder = 0
                        return
                    }
                    frameCount = Int64(info.frameCount)
                    repetitionCount = Int64(info.repetitionCount)
                    durationsPoint = info.frameDurations
                    frameDurations = Array<Float64>(frameCount, repeat: 0.0)
                    if (let Some(j) <- frameDurations) {
                        for (i in 0..frameCount) {
                            let duration: Float64 = durationsPoint.read(Int64(i)) //依次read() 或read(0) read(1) read(2) read(3) ...
                            j[i] = duration
                        }
                    }
                    encoded3Free(durationsPoint)
                }
                encodedFree(cpointInfo)
            } catch (e: Exception) {
                Hilog.error(0, "aviflog", "AvifDecoder init failed, release resources: ${e}")
                // SEC-M4 修复：构造中途异常（OOM/转换失败等）必须释放 native decoder + pin + Info/帧时长，防止泄漏
                destroyDecoderffi(decoder)
                decoder = 0
                encoded3Free(durationsPoint)
                encodedFree(cpointInfo)
            }
        }
    }

    public static func create(encoded: Array<UInt8>): ?AvifDecoder {
        return create(encoded, 1)
    }

    public static func create(encoded: Array<UInt8>, threads: Int32): ?AvifDecoder {
        let decoder: AvifDecoder = AvifDecoder(encoded, threads)
        if (decoder.decoder == 0) {
            return None
        }
        return decoder
    }

    /** Get the width of the image. */
    public func getWidth(): Int64 {
        return width
    }

    /** Get the height of the image. */
    public func getHeight(): Int64 {
        return height
    }

    /** Get the depth (bit depth) of the image. */
    public func getDepth(): Int64 {
        return depth
    }

    /** Returns true if the image contains a transparency/alpha channel, false otherwise. */
    public func getAlphaPresent(): Bool {
        return alphaPresent
    }

    /** Get the number of frames in the image. */
    public func getFrameCount(): Int64 {
        return frameCount
    }

    /**
     * Get the number of repetitions for an animated image (see repetitionCount in avif.h for
     * details).
     */
    public func getRepetitionCount(): Int64 {
        return repetitionCount
    }

    /** Get the duration for each frame in the image. */
    public func getFrameDurations(): ?Array<Float64> {
        return frameDurations
    }

    public static func isAvifImageffi(encoded: Array<UInt8>): Int32 {
        unsafe {
            let handle: CPointerHandle<UInt8> = acquireArrayRawData(encoded)
            let res: Int32 = isAvifImage(handle.pointer, Int32(encoded.size))
            releaseArrayRawData<UInt8>(handle)
            return res
        }
    }

    public func getInfoffi(encoded: Array<UInt8>): Cjinfo {
        unsafe {
                let cjinfo:Cjinfo = Cjinfo(0,0,0,false,0,0,Array<Float64>())
                if(encoded.size <= 0){
                    return cjinfo
                }
                let handle: CPointerHandle<UInt8> = acquireArrayRawData(encoded)
                var result: CPointer<Info> = getInfo(handle.pointer, Int32(encoded.size))
                // 判空
                if (result.isNull()) {
                    releaseArrayRawData<UInt8>(handle)
                    return cjinfo
                }
                var durationsPoint: ?CPointer<Float64> = None
                try{
                    var res: Info = result.read()
                    cjinfo.width = res.width
                    cjinfo.height = res.height
                    cjinfo.depth = res.depth
                    cjinfo.alphaPresent = res.alphaPresent
                    cjinfo.frameCount = res.frameCount
                    cjinfo.repetitionCount = res.repetitionCount
                    durationsPoint = res.frameDurations
                    var array:Array<Float64> = Array<Float64>(Int64(res.frameCount),repeat: 0.0)
                    if(let Some(point) <- durationsPoint){
                        for(i in 0..Int64(res.frameCount)){
                            let duration:Float64 = point.read(Int64(i))  //对象直接read() 数组read(0) read(1) read(2) read(3) ...
                            array[i] = duration
                        }
                    }
                    cjinfo.frameDurations = array
                    return cjinfo
                }finally{
                    releaseArrayRawData<UInt8>(handle)
                    if(let Some(i) <- durationsPoint){
                        if(!i.isNull()){
                            encoded3Free(i)
                        }
                    }
                    if(!result.isNull()){
                        encodedFree(result)
                    }
                }
        }
    }

    public func nextFrameIndexffi(): Int32 {
        unsafe {
            return nextFrameIndex(decoder);
        }
    }

    public func nextFrameffi(color: Array<UInt8>, imageWidth: Int32, imageHeight: Int32): Int32 {
        // SEC-M1 修复：公开 API 校验调用方参数——
        // 1) 拒绝非正宽高；2) 拒绝超上限宽高（与 SEC-H3 闸门共用 MAX_DIMENSION，防算术溢出）；
        // 3) color 缓冲必须 >= 宽×高×4（Int64 计算），防止 native 侧对仓颉数组底层内存越界写（堆损坏）
        if (imageWidth <= 0 || imageHeight <= 0 ||
            Int64(imageWidth) > MAX_DIMENSION || Int64(imageHeight) > MAX_DIMENSION) {
            Hilog.error(0, "aviflog", "invalid image dimensions: ${imageWidth}x${imageHeight}")
            return -1
        }
        if (Int64(color.size) < Int64(imageWidth) * Int64(imageHeight) * 4) {
            Hilog.error(0, "aviflog", "color buffer too small: ${color.size} < ${Int64(imageWidth) * Int64(imageHeight) * 4}")
            return -1
        }
        unsafe {
            let handle: CPointerHandle<UInt8> = acquireArrayRawData(color)
            let format: Int32 = 2
            var perPixelByte:Int32 = 4
            let res = nextFrame(decoder, handle.pointer, imageWidth, imageHeight, imageWidth * perPixelByte, format)
            releaseArrayRawData<UInt8>(handle)
            return res
        }
    }

    public func nthFrameffi(index: Int32, color: Array<UInt8>, imageWidth: Int32, imageHeight: Int32): Int32 {
        // SEC-M1 修复：同 nextFrameffi——参数与缓冲校验，防止 native 越界写
        if (imageWidth <= 0 || imageHeight <= 0 ||
            Int64(imageWidth) > MAX_DIMENSION || Int64(imageHeight) > MAX_DIMENSION) {
            Hilog.error(0, "aviflog", "invalid image dimensions: ${imageWidth}x${imageHeight}")
            return -1
        }
        if (Int64(color.size) < Int64(imageWidth) * Int64(imageHeight) * 4) {
            Hilog.error(0, "aviflog", "color buffer too small: ${color.size} < ${Int64(imageWidth) * Int64(imageHeight) * 4}")
            return -1
        }
        unsafe {
            let handle: CPointerHandle<UInt8> = acquireArrayRawData(color)
            let format: Int32 = 2
            var perPixelByte:Int32 = 4
            let res =  nthFrame(decoder, index, handle.pointer, imageWidth, imageHeight, imageWidth * perPixelByte, format)
            releaseArrayRawData<UInt8>(handle)
            return res
        }
    }

    public func release(): Unit {
        if (decoder != 0) {
            destroyDecoderffi(decoder)
        }
        decoder = 0
    }

}
