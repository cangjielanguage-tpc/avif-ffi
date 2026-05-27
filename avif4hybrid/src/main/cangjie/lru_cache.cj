package ohos_app_cangjie_avif4hybrid

public class CacheItem<V> {

    var key:String
    var value:V

    public init(key:String,value:V){
        this.key = key
        this.value = value
    }

    public func getKey():String{
        return key
    }

    public func getValue():V{
        return value
    }

    public func setKey(key:String){
        this.key = key
    }

    public func setValue(value:V){
        this.value = value
    }

}


class LruCache<V> {

     //构造 length contains keys put get remove clear isEmpty
     var list: ArrayList<CacheItem<V>> = ArrayList<CacheItem<V>>()

     func size(): Int64 {
        return list.size
     }

     func isEmpty(): Bool {
        return list.isEmpty()
    }


    public func keys():Array<String> {
        Array<String>(size()) {
            i => list[i].key
        }
    }

   public open func put(key: String, value: V): Option<V> {
        var old: Option<V> = None
        var index: ?Int64 = None
        for(i in 0 .. list.size) {
            let l: CacheItem<V> = list[i]
            if(l.key == key) {
                old = Some(l.value)
                index = i
                break
            }
        }
        if (let Some(inx) <- index) {
            list.remove(at: inx)
        }
        list.add(CacheItem(key,value))
        return old
    }

    public open func clear() {
        list.clear()
    }


    public open func remove(key:String): Option<V> {
        var i = 0
        while(i < list.size) {
            if(list[i].key == key) {
                return Some(list.remove(at:i).value)
            }
            i++
        }
        return None
    }

     func containsKey(key:String): Bool {
        for(i in 0 .. list.size) {
            let o: CacheItem<V> = list[i]
            if(o.key == key) {
                return true
            }
        }
        return false
    }

     func get(key:String):Option<V> {
        for(i in 0 .. list.size) {
            let o: CacheItem<V> = list[i]
            if(o.key == key) {
                return Some(o.value)
            }
        }
        return None
    }

}