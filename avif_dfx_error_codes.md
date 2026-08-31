# AVIF DFX 错误码

适用接口：`CJAvifDecoder.createAsync`、`createWithThreadAsync`、`nextFrameffiAsync`、`nthFrameffiAsync`、`CJCacheCheck.getMemoryCache`。

`createAsync` 和 `createWithThreadAsync` 均返回 `ReturnValue`，业务侧可通过 `code` 和 `codeMessage` 感知结果并进行埋点。

| 错误码 | 错误信息 | 触发场景 | 适用接口 |
|---:|---|---|---|
| `0` | `success` | 操作成功 | `createAsync`、`nextFrameffiAsync`、`nthFrameffiAsync`、`getMemoryCache` |
| `1001` | `图片宽高参数非法` | 传入的图片宽度或高度小于 `0` | `nextFrameffiAsync`、`nthFrameffiAsync` |
| `1002` | `解码器未初始化` | 执行帧解码时 decoder 不存在 | `nextFrameffiAsync`、`nthFrameffiAsync` |
| `1003` | `图片帧数非法或无法获取` | 获取到的帧数小于等于 `0` | `nextFrameffiAsync` |
| `1004` | `缓存数据为空` | `getMemoryCache` 命中 CacheBean 但 picData 为空 | `getMemoryCache` |
| `1005` | `创建解码器失败` | 创建流程开始时的默认错误；或未匹配到更具体的创建错误 | `createAsync` |
| `1006` | `网络响应内容为空，status={status}` | HTTP 响应没有 body size；网络请求异常或网络任务异常时，信息会替换为实际异常信息 | `createAsync` |
| `1007` | `获取raw文件内容失败` | RawFile 资源读取失败 | `createAsync` |
| `1008` | `获取media文件内容失败` | Media 资源读取失败 | `createAsync` |
| `1009` | `读取本地文件失败` | `file://` 路径读取失败 | `createAsync` |
| `1010` | `读取内容失败` | 普通本地路径读取失败 | `createAsync` |
| `1011` | `创建解码器失败` | 文件内容读取成功，但 AVIF decoder 创建失败 | `createAsync` |
| `1012` | `帧索引非法` | 帧索引小于 `0` 或大于等于总帧数 | `nthFrameffiAsync` |
| `1014` | `网络响应状态异常，status={status}` | HTTP 状态码小于 `200` 或大于等于 `400` | `createAsync` |
| `1015` | `网络响应数据不完整，已读取{read}/{total}` | 网络响应实际读取数据量小于声明的 body size | `createAsync` |
| `1016` | `无内存缓存` | `getMemoryCache` 未在 LRU 缓存中找到对应 key | `getMemoryCache` |
| `9000` | `Exception.toString()` 的实际异常信息 | Cangjie `Exception` 或 `Error` 未被业务逻辑处理时 | `createAsync`、`nextFrameffiAsync`、`nthFrameffiAsync` |

## 网络错误信息

`getImageFromNet` 的网络失败信息会通过 `getImageFromNet` 返回结果传递到 `createWithThreadAsync`，最终由 `createAsync` 返回：

```ts
{
  code: number,
  codeMessage: string,
  issuccess: boolean
}
```

网络错误的 `codeMessage` 可能包含以下动态内容：

- HTTP 状态异常：`网络响应状态异常，status=404`
- 响应内容为空：`网络响应内容为空，status=200`
- 响应数据不完整：`网络响应数据不完整，已读取512/1024`
- 请求异常：`网络请求异常：{异常类型}，message={异常消息}`
- 网络任务异常：`网络任务异常：{异常类型}，message={异常消息}`

## 备注

- native `nextFrameffi` 或 `nthFrameffi` 返回的非零错误码会原样写入 `ReturnValue.code`，当前统一使用帧解码失败信息补充 `codeMessage`。
- `createAsync` 成功时 `issuccess` 为 `true`；失败时 `issuccess` 为 `false`。
- `codeMessage` 中的 `status`、`read`、`total` 和异常内容为运行时动态值，埋点建议同时记录 `code` 与 `codeMessage`。
