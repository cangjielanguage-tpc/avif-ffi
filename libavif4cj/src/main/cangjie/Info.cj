/**
 * Created on 2025/8/14
 */
package libavif4cj

@C
public struct Info {

    public var width:UInt32 = 0
    public var height:UInt32 = 0
    public var depth:UInt32 = 0
    public var alphaPresent:Bool = false

    init(width: UInt32, height: UInt32, depth: UInt32,alphaPresent:Bool) {
        this.width = width
        this.height = height
        this.depth = depth
        this.alphaPresent = alphaPresent
    }

}