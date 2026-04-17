package ohos_app_cangjie_avif4hybrid

public class ReturnValue {
    public var code: Int32 = 0
    public var color: Option<Array<Byte>> = None
    public var isSuccess: Bool = false
    //内存缓存的时候要取到图片的宽高给SIZE转pixelMap
    public var memoryWidth:Int64 = 0
    public var memoryHeight:Int64 = 0
    public var isAlphaPresent:Bool = false


    public init() {
    }
}
