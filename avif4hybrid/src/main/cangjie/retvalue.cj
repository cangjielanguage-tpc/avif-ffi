package ohos_app_cangjie_avif4hybrid

public class ReturnValue {
    public var code: Int32 = 0
    public var codeMessage: String = ""
    public var color: Option<Array<Byte>> = None
    public var isSuccess: Bool = false
    //内存缓存的时候要取到图片的宽高给SIZE转pixelMap
    public var memoryWidth:Int64 = 0
    public var memoryHeight:Int64 = 0
    public var isAlphaPresent:Bool = false


    public init() {
    }

    public init(code: Int32, codeMessage: String, isSuccess: Bool) {
        this.code = code
        this.codeMessage = codeMessage
        this.isSuccess = isSuccess
    }

    public init(code: Int32, codeMessage: String, isSuccess: Bool,
        color: Option<Array<Byte>>,
        memoryWidth: Int64,
        memoryHeight: Int64,
        isAlphaPresent: Bool) {
        this.code = code
        this.codeMessage = codeMessage
        this.isSuccess = isSuccess
        this.color = color
        this.memoryWidth = memoryWidth
        this.memoryHeight = memoryHeight
        this.isAlphaPresent = isAlphaPresent
    }
}
