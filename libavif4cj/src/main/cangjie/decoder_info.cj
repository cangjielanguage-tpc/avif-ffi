/**
 * Created on 2025/8/14
 */
package libavif4cj

@C
public struct DecoderInfo {
    public var address: Int64 = 0
    public var info: CPointer<Info> = CPointer<Info>()

    init(address: Int64, info: CPointer<Info>) {
        this.address = address
        this.info = info
    }
}
