package ohos_app_cangjie_avif4hybrid

import ohos.hilog.Hilog

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
    // 统计：查询 / 有效命中 / put 计数（均在 mtx 内更新）
    var queryCount: Int64 = 0      // 查询 LRU 内存缓存次数
    var validHitCount: Int64 = 0   // 命中且内存缓存有效的次数（pixelMap 有效 / picData 有效）
    var putCount: Int64 = 0        // put 成功次数（每 30 的整数倍触发一次容量统计）
    let statInterval: Int64 = 30

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

    // 添加缓存键值对
    func put(key: String, value: CacheBean): Unit {
        synchronized(mtx) {
            let size = getMemoryDataSize(value)
            if (size <= 0 || size >= this.maxMemory) {
                return
            }
            // 如果size满了的话，需要按照LRU的方式删除第一个
            if (this.lruCache.size() >= this.maxSize && !this.lruCache.containsKey(key)) {
                remove(this.lruCache.keys()[0])
            } else if (this.lruCache.containsKey(key)) {
                remove(key)
            }
            this.lruCache.put(key, value)
            this.currentMemory += size
            trimToSize()
            putCount += 1
            if (putCount % statInterval == 0) {
                // 每 30 的整数倍 put：遍历列表统计有效内存缓存总大小
                logMemoryStat()
            }
        }
    }

    func get(key: String): ?CacheBean {
         synchronized(mtx) {
            queryCount += 1
            let result = this.lruCache.get(key)
            if (let Some(b) <- result) {
                // 命中且有效（pixelMap 未释放 / picData 有效）才计为有效命中
                if (getMemoryDataSize(b) > 0) {
                    validHitCount += 1
                }
            }
            // 统计输出：有效命中次数 / 查询次数
            Hilog.info(0, "memCacheStat", "query=${queryCount}, validHit=${validHitCount}, hitRate=${hitRatePercent()}%")
            return result
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

    // 每 30 次成功 put 触发：遍历 LRU 列表统计“有效”内存缓存总大小
    // （pixelMap 按 getPixelBytesNumber 计入；无 pixelMap 时按 picData.size；两者皆无效计 0）
    func logMemoryStat(): Unit {
        synchronized(mtx) {
            var totalSize: Int64 = 0
            var validCount: Int64 = 0
            var totalCount: Int64 = 0
            for (item in this.lruCache.list) {
                let cacheBean: ?CacheBean = item.getValue()
                if (let Some(i) <- cacheBean) {
                    totalCount += 1
                    let sz = getMemoryDataSize(i)
                    if (sz > 0) {
                        validCount += 1
                        totalSize += sz
                    }
                }
            }
            Hilog.info(0, "memCacheStat", "stat#${putCount}: validEntries=${validCount}/${totalCount}, validMemSize=${totalSize} bytes, trackedMem=${this.currentMemory} bytes, hit=${validHitCount}/${queryCount} (rate ${hitRatePercent()}%)")
        }
    }

    private func hitRatePercent(): Int64 {
        if (queryCount <= 0) {
            return 0
        }
        return validHitCount * 100 / queryCount
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
