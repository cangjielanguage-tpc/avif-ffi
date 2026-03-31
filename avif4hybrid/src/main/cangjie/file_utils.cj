package ohos_app_cangjie_avif4hybrid

import std.fs.File as FileStd
import std.fs.OpenMode

class FileUtils {
    static let SEPARATOR: String = "/"
    private static var sInstance: ?FileUtils = None

    private init() {
    }

    public static func getInstance(): FileUtils {
        if (sInstance.isNone()) {
            FileUtils.sInstance = FileUtils()
        }
        return FileUtils
            .sInstance
            .getOrThrow()
    }

    func createFolder(path: String): Bool {
        try {
            let isExist: Bool = FileFs.access(path)
            if (!isExist) {
                FileFs.mkdir(path,true)
            }
            return true
        } catch (e: Exception) {
            Hilog.error(0, "createFolder", e.toString())
        }
        return false
    }

    func listFile(path: String): Array<String> {
        try {
            return FileFs.listFile(path)
        } catch (e: Exception) {
            Hilog.error(0, "listFile", e.toString())
        }
        return Array<String>()
    }

    func stat(path: String): ?Stat {
        try {
            return FileFs.stat(path)
        } catch (e: Exception) {
            Hilog.error(0, "stat", e.toString())
        }
        return None
    }

    func deleteFile(path: String): Unit {
        try {
            FileFs.unlink(path)
        } catch (e: Exception) {
            Hilog.error(0, "deleteFile", e.toString())
        }
    }

      /**
   * 读取路径path的文件
   *
   * @param path 文件绝对路径
   */
  func readFileSync(path: String): ?Array<UInt8> {
    try {
      if (FileFs.access(path)) {
        let length = FileFs.stat(path).size
        let buf = Array<UInt8>(length,repeat: 0)
        let fd = FileFs.open(path, mode: READ_ONLY.mode).fd
        FileFs.read(fd, buf)
        FileFs.close(fd)
        return buf
      }
    } catch (e: Exception) {
        Hilog.error(0, "readFileSync", e.toString())
    }
    return None
  }

    /**
   * 向path写入数据
   *
   * @param path 文件绝对路径
   * @param content 文件内容
   */
  func writeDataSync(path: String, content: Array<UInt8>): Bool {
    try {
      let file = FileStd(path,ReadWrite)
      file.write(content)
      file.close()
      return true
    }catch (e: Exception) {
      Hilog.error(0, "writeDataSync", e.toString())
      return false
    }
  }

  func writeDataSync(path: String, wh:Array<UInt8>,content: Array<UInt8>): Bool {
    try {
      let fd = FileFs.open(path, mode:(READ_WRITE.mode | CREATE.mode | APPEND.mode)).fd
      FileFs.write(fd, wh)
      FileFs.write(fd, content)
      FileFs.fsync(fd)
      FileFs.close(fd)
      return true
    }catch (e: Exception) {
      Hilog.error(0, "writeDataSync", e.toString())
      return false
    }
  }

    /**
   * 判断path文件是否存在
   *
   * @param path 文件绝对路径
   */
  func exist(path: String): Bool {
    try {
      if (FileFs.access(path)) {
        let stat = FileFs.stat(path)
        return stat.isFile()
      } else {
        return false
      }
    }catch (e: Exception) {
      Hilog.error(0, "exist", e.toString())
    }
    return false
  }
}
