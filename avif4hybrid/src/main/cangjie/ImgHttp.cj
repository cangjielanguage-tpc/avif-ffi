package ohos_app_cangjie_avif4hybrid

public let TAG: String = "ImgHttp"

public class ImgHttp {
    public static func request(urlStr: String, callback: (Option<Exception>, Option<Array<UInt8>>) -> Unit): Unit {
        spawn {
            var tlsConfig = TlsClientConfig()
            tlsConfig.verifyMode = TrustAll
            let client = ClientBuilder().tlsConfig(tlsConfig).build()
            let ret = client.get(urlStr)
            if (let Some(v) <- ret.bodySize) {
                let buf = Array<UInt8>(v, repeat: 0)
                var readNumAll = 0
                while (readNumAll < v) {
                    let readNum = ret.body.read(buf[readNumAll..v])
                    if (readNum <= 0) {
                        break
                    }
                    readNumAll += readNum
                }
                callback(None, buf)
            } else {
                callback(None, None)
            }
            client.close()
        }
    }
}
