package avif4cj

class FileLruCache {

  let BASE_FOLDER:String = "/data/storage/el2/base/haps/entry/cache"
  static var CACHE_FOLDER: String = 'avifcache' // context cacheDir 的缓存文件目录
  var maxMemorySize: Int64 = 0 //最大内存
  var currentMemorySize: Int64 = 0 //当前内存
  var maxFileSize: Int64 = 0 //最大文件数
  var path: String = '' //路径
  var lruCache: LruCache<Int64> = LruCache<Int64>() //这个Int64指的是文件的大小 key就是那个url+width+height的md5
  var isInited: Bool = false //是否初始化
  //var context: StageContext = GlobalContext.getContext().getOrThrow()
  let defaultMaxMemorySize: Int64 = 10 * 1024 * 1024 * 1024 //默认最大内存数
  let defaultMemorySize: Int64 = 1024 * 1024 * 1024 //不设置时候的默认内存
  private let mtx = ReentrantMutex()


    init(fileSize: Int64, memorySize: Int64) {
        if (fileSize <= 0 || fileSize > Int64.Max) {
            this.maxFileSize = Int64.Max
        }else{
            this.maxFileSize = fileSize
        }
        if (memorySize <= 0 || memorySize > this.defaultMaxMemorySize) {
            this.maxMemorySize = this.defaultMemorySize
        }else{
            this.maxMemorySize = memorySize
        }
        this.currentMemorySize = 0
        initFileCache()
    }

    func setSize(fileSize: Int64, memorySize: Int64) {
        if (fileSize <= 0 || fileSize > Int64.Max) {
            this.maxFileSize = Int64.Max
        }else{
            this.maxFileSize = fileSize
        }
        if (memorySize <= 0 || memorySize > this.defaultMaxMemorySize) {
            this.maxMemorySize = this.defaultMemorySize
        }else{
            this.maxMemorySize = memorySize
        }
    }

    /**
   * 遍历缓存文件目录，初始化缓存
   */
  public func initFileCache() {
    if (this.isInited) {
      return
    }
    //简单点 让用户只填一个文件夹名
    let startTime = DateTime.now().toUnixTimeStamp().toNanoseconds()
    this.path = BASE_FOLDER + FileUtils.SEPARATOR + CACHE_FOLDER + FileUtils.SEPARATOR
    //创建目录
    FileUtils.getInstance().createFolder(this.path)
    // 遍历缓存目录下的文件，按照时间顺序加入缓存
    let filenames: Array<String> = FileUtils.getInstance().listFile(this.path)
    let cachefiles: ArrayList<CacheFileInfo> = ArrayList<CacheFileInfo>()
    for(item in filenames){
       let stat:?Stat = FileUtils.getInstance().stat(this.path + item)
       if(let Some(i) <- stat){
           cachefiles.add(CacheFileInfo(item,i.ctime,i.size))
       }
    }
    sort<CacheFileInfo>(cachefiles,stable: true,descending:false)

    for(i in 0..cachefiles.size){
        let perCacheFile:CacheFileInfo = cachefiles.get(i).getOrThrow()
        let fileSize:Int64 = perCacheFile.fileSize
        // 处理数量超过size的场景，移除即将排除的文件
        if(this.lruCache.size() == this.maxFileSize && !this.lruCache.containsKey(perCacheFile.fileName)){
              //返回的是value
              let fileName = this.lruCache.keys()[0]
 	          let remove:?Int64 = this.lruCache.remove(fileName)
              if(let Some(j) <- remove){
                    FileUtils.getInstance().deleteFile(this.path+fileName)
                    removeMemorySize(j)
              }
        }
        this.lruCache.put(cachefiles[i].fileName, fileSize)
        addMemorySize(fileSize)
    }
    trimToSize()
    Hilog.info(0,"initFileCache","image init initFileCache: ${(DateTime.now().toUnixTimeStamp().toNanoseconds()-startTime)} ,num: ${filenames.size}  ,nums: ${this.lruCache.size()} ,size:${this.currentMemorySize}")
    this.isInited = true
  }

  public func isFileCacheInit():Bool {
    synchronized(mtx) {
        return this.isInited
    }
  }

  public func getCacheFolder(): String {
      synchronized(mtx) {
         return CACHE_FOLDER
      }
  }

    // 添加缓存键值对,同时写文件
  func put(key: String, value: Int64,content:Array<UInt8>): Unit {
    synchronized(mtx) {
        if (key.size == 0 || value < 0) {
          throw Exception('key or value is invalid ')
        }
        if (!this.isInited) {
          return
        }
        // 如果size满了的话，需要按照LRU的方式删除第一个
        if (this.lruCache.size() == this.maxFileSize && !this.lruCache.containsKey(key)) {
          remove(this.lruCache.keys()[0])
        } else if (this.lruCache.containsKey(key)) {
          remove(key)
        }
        let pre = this.lruCache.put(key,value)
        FileUtils.getInstance().writeDataSync(this.path + key, content)
        if (let Some(i) <- pre) {
          this.addMemorySize(i)
        }
        trimToSize()
    }
  }


  func get(key: String): ?Array<UInt8> {
      synchronized(mtx) {
          if (!this.isInited) {
            return None
          }
          if (let Some(i) <- this.lruCache.get(key)) {
            return FileUtils.getInstance().readFileSync(this.path + key)
          }
          return None
      }
  }

     // 移除键为key的缓存
  func remove(key: String): Unit {
    synchronized(mtx) {
        if (key.size == 0) {
          throw Exception('key is null,checking the parameter')
        }
        if (!this.isInited) {
          return
        }
        let remove: ?Int64 = this.lruCache.remove(key)
        if (let Some(i) <- remove) {
          FileUtils.getInstance().deleteFile(this.path + key)
          removeMemorySize(i)
        }
    }
  }

  func removeAll(): Unit {
    synchronized(mtx) {
        if (!this.isInited) {
          return
        }
        this.lruCache.clear()
        this.currentMemorySize = 0

        let filenames: Array<String> = FileUtils.getInstance().listFile(this.path)
        for (filename in filenames) {
            FileUtils.getInstance().deleteFile(this.path + filename)
        }
     }
  }

   func size(): Int64 {
    synchronized(mtx) {
        return this.lruCache.size()
    }
  }

     // 移除较少使用的缓存数据
  private func trimToSize(): Unit {
    synchronized(mtx) {
        while (true) {
          if (this.currentMemorySize <= this.maxMemorySize || this.lruCache.isEmpty()) {
            break
          }
          let delkey = this.lruCache.keys()[0]
          let remove: ?Int64 = this.lruCache.remove(delkey)
          if(let Some(i) <- remove){
             FileUtils.getInstance().deleteFile(this.path + delkey)
             removeMemorySize(i)
          }
        }
    }
  }

  private func removeMemorySize(value: Int64): Unit {
      synchronized(mtx) {
          this.currentMemorySize -= value
          Hilog.info(0,"currentMemorySize", "FileCache removeMemorySize:${value} currentMemory: ${this.currentMemorySize}")
      }
  }

  private func addMemorySize(value:Int64): Unit {
      synchronized(mtx) {
          this.currentMemorySize += value
          Hilog.info(0,"currentMemorySize", "FileCache removeMemorySize:${value} currentMemory: ${this.currentMemorySize}")
      }
  }


}
