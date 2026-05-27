package ohos_app_cangjie_avif4hybrid

public class CacheFileInfo <: Comparable<CacheFileInfo>{

    var fileName:String
    var cTime:Int64
    var fileSize:Int64

    init(fileName:String,cTime:Int64,fileSize:Int64){
        this.fileName = fileName
        this.cTime = cTime
        this.fileSize = fileSize
    }

     public func compare(r: CacheFileInfo):Ordering {
        let tValue: Int64 = this.cTime
        let rValue: Int64 = r.cTime
        if (tValue > rValue) {
            return Ordering.GT
        } else if (tValue == rValue) {
            return Ordering.EQ
        } else {
            return Ordering.LT
        }
    }

    func setFileName(fileName:String){
        this.fileName = fileName
    }

    func setCTime(cTime:Int64){
        this.cTime = cTime
    }

    func setFileSize(fileSize:Int64){
        this.fileSize = fileSize
    }

    func getFileName():String{
        return this.fileName
    }

    func getCTime():Int64{
        return this.cTime
    }

    func getFileSize():Int64{
        return this.fileSize
    }

}
