package ohos_app_cangjie_avif4hybrid
import ohos.ark_interop_macro.Interop

public class CacheCheck {

    public init() {
    }


    //只提供单图情况 多图不要内存缓存了
    public func getMemoryCache(uri:String,imagePicWidth:Int64,imagePicHeight:Int64):ReturnValue{
        let key = getmd5key(uri.toArray(), imagePicWidth, imagePicHeight)+"notcomponent"
        //根据key得到缓存内容
        let memCache:?CacheBean = memoryLruCache.get(key)
        if(let Some(i) <- memCache){
            //表示取到缓存了
            let arrData:?Array<UInt8> = i.getPicData()
            if(let Some(j) <- arrData){
                    return ReturnValue(0, "success", true, j,
                        i.getMemoryWidth(), i.getMemoryHeight(), i.getAlphaPresent())
            }else{
                return ReturnValue(1004, "缓存数据为空", false)
            }
        }else{
            return ReturnValue(1016, "无内存缓存", false)
        }
    }

}
