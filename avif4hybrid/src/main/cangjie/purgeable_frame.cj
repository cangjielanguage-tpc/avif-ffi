/*
 * PurgeableFrame：解码帧的 Purgeable Memory 封装（极简版）
 *
 * 定位：只作为"可丢弃的解码帧存储"。
 *   - 创建时写入解码 RGBA
 *   - 系统内存压力时内容可被丢弃
 *   - 内容被丢弃后【不做重建】：beginRead 返回 false，上层当缓存未命中，
 *     自行走磁盘缓存/重新解码
 */
package ohos_app_cangjie_avif4hybrid

// libavifpurge.so 导出接口
foreign func AvifPurgeCreate(contentLen: Int32): CPointer<UInt8>
foreign func AvifPurgeWriteContent(handle: CPointer<UInt8>, content: CPointer<UInt8>, contentLen: Int32): Bool
foreign func AvifPurgeBeginRead(handle: CPointer<UInt8>): Bool
foreign func AvifPurgeGetContent(handle: CPointer<UInt8>): CPointer<UInt8>
foreign func AvifPurgeEndRead(handle: CPointer<UInt8>): Unit
foreign func AvifPurgeContentSize(handle: CPointer<UInt8>): Int32
foreign func AvifPurgeCopyToByteArray(handle: CPointer<UInt8>, out: CPointer<UInt8>, outLen: Int32): Int32
foreign func AvifPurgeDestroy(handle: CPointer<UInt8>): Unit

public class PurgeableFrame {
    // PurgeHandle*（libavifpurge.so 内部结构），不透明句柄
    var handle: CPointer<UInt8>
    public var isValid: Bool = false

    /* content: 解码好的 RGBA（w*h*4），创建时拷贝进 Purgeable 内容 */
    public init(content: Array<Byte>) {
        handle = CPointer<UInt8>()
        unsafe {
            let hContent = acquireArrayRawData(content)
            handle = AvifPurgeCreate(Int32(content.size))
            if (!handle.isNull()) {
                let _ = AvifPurgeWriteContent(handle, hContent.pointer, Int32(content.size))
                isValid = true
            }
            releaseArrayRawData<UInt8>(hContent)
        }
    }

    /** 开始读。返回 false = 内容已被系统回收 → 上层当缓存未命中 */
    public func beginRead(): Bool {
        unsafe { return AvifPurgeBeginRead(handle) }
    }

    /** 取内容指针（仅在 beginRead/endRead 区间内有效） */
    public func getContent(): CPointer<UInt8> {
        unsafe { return AvifPurgeGetContent(handle) }
    }

    public func endRead(): Unit {
        unsafe { AvifPurgeEndRead(handle) }
    }

    public func contentSize(): Int32 {
        unsafe { return AvifPurgeContentSize(handle) }
    }

    /** 读取整帧。内容已被系统回收时返回 None（上层当未命中处理） */
    public func tryCopyToByteArray(): ?Array<UInt8> {
        let size = Int64(contentSize())
        if (size <= 0) {
            return None
        }
        let out = Array<UInt8>(size, repeat: 0)
        var ok = false
        unsafe {
            let hOut = acquireArrayRawData(out)
            ok = AvifPurgeCopyToByteArray(handle, hOut.pointer, Int32(size)) > 0
            releaseArrayRawData<UInt8>(hOut)
        }
        return if (ok) { Some(out) } else { None }
    }

    /** 销毁（缓存逐出时必须调用） */
    public func destroy(): Unit {
        if (isValid) {
            unsafe { AvifPurgeDestroy(handle) }
            handle = CPointer<UInt8>()
            isValid = false
        }
    }
}
