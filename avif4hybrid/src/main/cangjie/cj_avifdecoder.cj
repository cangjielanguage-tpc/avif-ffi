package ohos_app_cangjie_avif4hybrid

import ohos.ark_interop_macro.Interop


 @Interop[ArkTS]
  public class CJAvifDecoder {
      public init() {
      }


      private var decoder: Option<AvifDecoder> = None
      var mMemoryKey = ""
      var mDiskKey = ""
      var mUri = ""
      var encoded:?Array<Byte> = None
      public func create(uri: String): Option<CJAvifDecoder> {
          return createWithThread(uri, 1)
      }




      public func createWithThread(uri: String, threads: Int32): Option<CJAvifDecoder> {
          this.mUri = uri
          //在这里将uri转化为arryauint8,并生成key
           if (uri.startsWith("http")) {
              //把数据下载下来
              //下面是网络去下载
              let imageBuffer = getImageFromNet(uri)
              if(let Some(i) <- imageBuffer){
                return createLoginc(i,threads)
              }else{
                Hilog.error(0, "getImageFromNet", "获取网络文件内容失败")
                return Option<CJAvifDecoder>.None
              }
          }else if(uri.startsWith("rawfile://")){
               let fileName = uri.removePrefix("rawfile://")
               let imageBuffer = getImageFromRawFile(fileName)
               if(let Some(i) <- imageBuffer){
                    return createLoginc(i,threads)
               }else{
                    Hilog.error(0, "getImageFromRawFile", "获取raw文件内容失败")
                    return Option<CJAvifDecoder>.None
               }
          }else if(uri.startsWith("media://")){
               let mediaName = uri.removePrefix("media://")
               let imageBuffer = getImageFromMedia(mediaName)
               if(let Some(i) <- imageBuffer){
                    return createLoginc(i,threads)
               }else{
                    Hilog.error(0, "getImageFromMedia", "获取media文件内容失败")
                    return Option<CJAvifDecoder>.None
               }
          }else if(uri.startsWith("file://")){
                let localFilePath = uri.removePrefix("file://")
                let imageBuffer: ?Array<UInt8> = FileUtils.getInstance().readFileSync(localFilePath)
                if(let Some(i) <- imageBuffer){
                    return createLoginc(i,threads)
                }else{
                    Hilog.error(0, "readFileSync", "读取本地文件失败")
                    return Option<CJAvifDecoder>.None
                }
          }else{
                let localFilePath = uri
                let imageBuffer: ?Array<UInt8> = FileUtils.getInstance().readFileSync(localFilePath)
                if(let Some(i) <- imageBuffer){
                    return createLoginc(i,threads)
                }else{
                    Hilog.error(0, "readFileSync", "读取内容失败")
                    return Option<CJAvifDecoder>.None
                }
          }
      }

       func createLoginc(buffer:Array<UInt8>,threads:Int32):Option<CJAvifDecoder>{
          encoded = buffer
          decoder = AvifDecoder(buffer, threads)
          if(let Some(k) <- decoder){
              if (k.decoder == 0) {
                  return Option<CJAvifDecoder>.None
              }
              return this
          }else{
              return Option<CJAvifDecoder>.None
          }
      }

        func createLoginc(uri: String,buffer:Array<UInt8>,threads:Int32):Option<CJAvifDecoder>{
          this.mUri = uri
          encoded = buffer
          decoder = AvifDecoder(buffer, threads)
          if(let Some(k) <- decoder){
              if (k.decoder == 0) {
                  return Option<CJAvifDecoder>.None
              }
              return this
          }else{
              return Option<CJAvifDecoder>.None
          }
      }




      public func getWidth(): Int64 {
          if (let Some(i) <- decoder) {
              return i.getWidth()
          }
          return 0
      }




      public func getHeight(): Int64 {
          if (let Some(i) <- decoder) {
              return i.getHeight()
          }
          return 0
      }




      public func getDepth(): Int64 {
          if (let Some(i) <- decoder) {
              return i.getDepth()
          }
          return 0
      }




      public func getAlphaPresent(): Bool {
          if (let Some(i) <- decoder) {
              return i.getAlphaPresent()
          }
          return false
      }




      public func getFrameCount(): Int64 {
          if (let Some(i) <- decoder) {
              return i.getFrameCount()
          }
          return 0
      }




      public func getRepetitionCount(): Int64 {
          if (let Some(i) <- decoder) {
              return i.getRepetitionCount()
          }
          return 0
      }




      public func getFrameDurations(): Option<JSArrayEx<Float64>> {
          if (let Some(i) <- decoder) {
              if(let Some(j) <- i.getFrameDurations()){
                  return JSArrayEx(j)
              }else{
                  return None
              }
          }
          return None
      }




      public func isAvifImageffi(): Int32 {
          if (let Some(i) <- decoder) {
              if(let Some(j) <- encoded){
                   return i.isAvifImageffi(j)
              }
          }
          return 0
      }




      public func nextFrameIndexffi(): Int32 {
          if (let Some(i) <- decoder) {
              return i.nextFrameIndexffi()
          }
          return 0
      }




      public func nextFrameffi(imageWidth: Int32, imageHeight: Int32): CJReturnValue {
          let value:CJReturnValue = CJReturnValue()
           if(imageWidth < 0 || imageHeight < 0){
              value.issuccess = false
              return value
          }
          //先看多图还是单图
          let count:Int64 = getFrameCount()
          if(count <= 0){
              value.issuccess = false
              return value
          }
          //单图
          //先生成key
          //多图有本地缓存，没有内存缓存
          mDiskKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
          if(count == 1){
              //单图不仅有本地缓存 还有内存缓存
              mMemoryKey = mDiskKey + "notcomponent"
          }


           //根据key判断内存中有没有,单图才走内存缓存逻辑
          if(count == 1){
              let memPixelMap: ?CacheBean = memoryLruCache.get(mMemoryKey)
              if(let Some(cache) <- memPixelMap){
                  let arrData = cache.getPicData()
                  if(let Some(i) <- arrData){
                      value.color = i
                      value.issuccess = true
                      return value
                  }
              }
          }


           //如果宽高为0 则为图片的原始宽高
          var realPicWidth = imageWidth
          var realPicHeight = imageHeight
          if(imageWidth == 0){
              realPicWidth = Int32(getWidth())
          }
          if(imageHeight == 0){
              realPicHeight = Int32(getHeight())
          }


          //内存也没有
          let color:Array<Byte> = Array<Byte>(Int64(realPicWidth*realPicHeight*4),repeat:0)
          if (let Some(i) <- decoder) {
              value.code =  i.nextFrameffi(color, realPicWidth, realPicHeight)
              let cacheWidth = realPicWidth
              let cacheHeight = realPicHeight
              if(value.code == 0){
                  spawn{
                      //单图才走内存缓存
                      if(count == 1){
                          let cacheBean:CacheBean = CacheBean(Option<PixelMap>.None,color)
                          cacheBean.setMemoryWidth(Int64(cacheWidth))
                          cacheBean.setMemoryHeight(Int64(cacheHeight))
                          memoryLruCache.put(mMemoryKey, cacheBean)
                      }


                      if(let Some(j) <- encoded){
                          let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
                          if(!fileExist && mUri.startsWith("http")){
                              fileLruCache.put(mDiskKey,j.size,j)
                          }
                      }
                  }
                  value.issuccess = true
                  value.color = color
              }else{
                  value.issuccess = false
              }
              return value
          }else{
              value.issuccess = false
              return value
          }
      }




      public func nthFrameffi(index: Int32,imageWidth: Int32, imageHeight: Int32): CJReturnValue {
          let value:CJReturnValue = CJReturnValue()
           if(imageWidth < 0 || imageHeight < 0){
              value.issuccess = false
              return value
          }
          //先看多图还是单图
          let count:Int64 = getFrameCount()
          if(count <= 0){
              value.issuccess = false
              return value
          }
          //单图
          //先生成key
          mDiskKey = getmd5key(this.mUri.toArray(), Int64(imageWidth), Int64(imageHeight))
          if(count == 1){
              //单图
               mMemoryKey = mDiskKey + "notcomponent"
          }


          //根据key判断内存中有没有,单图才判断内存缓存
          if(count == 1){
              let memPixelMap: ?CacheBean = memoryLruCache.get(mMemoryKey)
              if(let Some(cache) <- memPixelMap){
                  let arrData = cache.getPicData()
                  if(let Some(i) <- arrData){
                      value.color = i
                      value.issuccess = true
                      return value
                  }
              }
          }


            //如果宽高为0 则为图片的原始宽高
          var realPicWidth = imageWidth
          var realPicHeight = imageHeight
          if(imageWidth == 0){
              realPicWidth = Int32(getWidth())
          }
          if(imageHeight == 0){
              realPicHeight = Int32(getHeight())
          }


          //内存没有
          let color:Array<Byte> = Array<Byte>(Int64(realPicWidth*realPicHeight*4),repeat:0)
          if (let Some(i) <- decoder) {
              if(count == 1){
                  //单图index默认0
                  value.code =  i.nthFrameffi(0,color, realPicWidth, realPicHeight)
              }else{
                  //多图
                  value.code =  i.nthFrameffi(index,color, realPicWidth, realPicHeight)
              }
              let cacheWidth = realPicWidth
              let cacheHeight = realPicHeight
              if(value.code == 0){
                  spawn{
                      if(count == 1){
                         let cacheBean:CacheBean = CacheBean(Option<PixelMap>.None,color)
                         cacheBean.setMemoryWidth(Int64(cacheWidth))
                         cacheBean.setMemoryHeight(Int64(cacheHeight))
                         memoryLruCache.put(mMemoryKey, cacheBean)
                      }
                      if(let Some(j) <- encoded){
                          let fileExist = FileUtils.getInstance().exist(fileLruCache.path + mDiskKey)
                          if(!fileExist && mUri.startsWith("http")){
                               fileLruCache.put(mDiskKey,j.size,j)
                           }
                      }
                  }
                  value.issuccess = true
                  value.color = color
              }else{
                  value.issuccess = false
              }
              return value
          }else{
              value.issuccess = false
              return value
          }
      }




      public func release(): Unit {
          if (let Some(i) <- decoder) {
              return i.release()
          }
      }
  }