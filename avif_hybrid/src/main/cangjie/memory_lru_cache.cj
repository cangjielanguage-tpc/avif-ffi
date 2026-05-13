package avif4cj

class MemoryLruCache {
    var maxMemory: Int64 = 0
    var currentMemory: Int64 = 0
    var maxSize: Int64 = 0 //内存对象个数
    var lruCache: LruCache<CacheBean> = LruCache<CacheBean>()
    let defaultMaxSize: Int64 = 65536;
    let defaultSize: Int64 = 512;
    let defaultMaxMemorySize: Int64 = 10 * 1024 * 1024 * 1024;
    let defaultMemorySize: Int64 = 1024 * 1024 * 1024;
    private let mtx = ReentrantMutex()

    init(size: Int64, memory: Int64) {
        if (size <= 0 || size > this.defaultMaxSize) {
            this.maxSize = this.defaultSize
        } else {
            this.maxSize = size
        }
        if (memory <= 0 || memory > this.defaultMaxMemorySize) {
            this.maxMemory = this.defaultMemorySize
        } else {
            this.maxMemory = memory
        }
        this.currentMemory = 0
    }

    func setSize(size: Int64, memory: Int64) {
        if (size <= 0 || size > this.defaultMaxSize) {
            this.maxSize = this.defaultSize
        } else {
            this.maxSize = size
        }
        if (memory <= 0 || memory > this.defaultMaxMemorySize) {
            this.maxMemory = this.defaultMemorySize
        } else {
            this.maxMemory = memory
        }
    }


    func getMemoryMaxCountSize():Int64{
        return this.maxSize
    }

    func getMemoryMaxMemorySize():Int64{
        return this.maxMemory
    }


    // 添加缓存键值对
    func put(key: String, value: CacheBean): Unit {
        synchronized(mtx) {
            let size = getMemoryDataSize(value)
            if (size <= 0 || size >= this.maxMemory) {
                return
            }
            // 如果size满了的话，需要按照LRU的方式删除第一个
            if (this.lruCache.size() == this.maxSize && !this.lruCache.containsKey(key)) {
                remove(this.lruCache.keys()[0])
            } else if (this.lruCache.containsKey(key)) {
                remove(key)
            }
            this.lruCache.put(key, value)
            this.currentMemory += size
            trimToSize()
        }
    }

    func get(key: String): ?CacheBean {
         synchronized(mtx) {
            return this.lruCache.get(key)
         }
    }

    // 移除键为key的缓存
    func remove(key: String): ?CacheBean {
        synchronized(mtx) {
            let remove: ?CacheBean = this.lruCache.remove(key)
            if (let Some(i) <- remove) {
                removeMemorySize(i)
            }
            return remove
        }
    }

    func removeAll(): Unit {
        //这里要整体release
        synchronized(mtx) {
            for (item in this.lruCache.list) {
                let cacheBean: ?CacheBean = item.getValue()
                if (let Some(i) <- cacheBean) {
                    let singlePixelMap = i.getPixelMap()
                    if (let Some(j) <- singlePixelMap) {
                        j.release()
                    }
                }
            }
            this.lruCache.clear()
            this.currentMemory = 0
        }
    }

    func size(): Int64 {
         synchronized(mtx) {
            return this.lruCache.size()
         }
    }

    // 移除较少使用的缓存数据
    func trimToSize(): Unit {
        synchronized(mtx) {
            while (true) {
                if (this.currentMemory <= this.maxMemory || this.lruCache.isEmpty()) {
                    break
                }
                let delkey = this.lruCache.keys()[0]
                let data: ?CacheBean = this.lruCache.get(delkey)
                if (let Some(i) <- data) {
                    this.removeMemorySize(i)
                }
                this.lruCache.remove(delkey)
            }
        }
    }

    private func removeMemorySize(cacheBean: CacheBean): Unit {
        synchronized(mtx) {
            var totalSize: Int64 = 0
            let singlePixelMap: ?PixelMap = cacheBean.getPixelMap()
            if (let Some(i) <- singlePixelMap) {
                //表示是单图
                totalSize = Int64(i.getPixelBytesNumber())
                i.release()
            } else {
                //接口单图
                let arrData = cacheBean.getPicData()
                if(let Some(i) <- arrData){
                    totalSize = i.size
                }
            }
            this.currentMemory -= totalSize
        }
    }

    private func getMemoryDataSize(cacheBean: CacheBean): Int64 {
        var totalSize: Int64 = 0
        let singlePixelMap: ?PixelMap = cacheBean.getPixelMap()
        if (let Some(i) <- singlePixelMap) {
            //表示是单图
            totalSize = Int64(i.getPixelBytesNumber())
        } else {
            //表示是接口单图
            let arrData = cacheBean.getPicData()
            if(let Some(i) <- arrData){
                totalSize = i.size
            }
        }
        return totalSize
    }
}
