/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package ohos_app_cangjie_avif4hybrid
import ohos.ark_interop_macro.Interop

@Interop[ArkTS]
public class CJCacheCheck {

    public init() {
    }


    //只提供单图情况 多图不要内存缓存了
    public func getMemoryCache(uri:String,imagePicWidth:Int64,imagePicHeight:Int64):CJReturnValue{
        let value:CJReturnValue = CJReturnValue()
        let key = getmd5key(uri.toArray(), imagePicWidth, imagePicHeight)+"notcomponent"
        //根据key得到缓存内容
        let memCache:?CacheBean = memoryLruCache.get(key)
        if(let Some(i) <- memCache){
            //表示取到缓存了
            let arrData:?Array<UInt8> = i.getPicData()
            if(let Some(j) <- arrData){
                    value.color = j
                    value.memoryWidth = i.getMemoryWidth()
                    value.memoryHeight = i.getMemoryHeight()
                    value.issuccess = true
                    return value
            }else{
                value.issuccess = false
                return value
            }
        }else{
            value.issuccess = false
            return value
        }
    }

}
