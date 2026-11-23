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
            //Purgeable 帧：BeginRead 返回 false = 内容已被系统回收 → 当未命中（移出登记簿），上层走磁盘缓存/重新解码
            let pf = i.getPurgeFrame()
            if (let Some(p) <- pf) {
                let data = p.tryCopyToByteArray()
                if (let Some(d) <- data) {
                    return ReturnValue(0, "success", true, d,
                        i.getMemoryWidth(), i.getMemoryHeight(), i.getAlphaPresent())
                }
                // 内容已被系统回收：当未命中处理（移出登记簿 + 销毁），上层走磁盘缓存/重新解码
                memoryLruCache.remove(key)
                return ReturnValue(1004, "内存缓存已被系统回收", false)
            }
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
