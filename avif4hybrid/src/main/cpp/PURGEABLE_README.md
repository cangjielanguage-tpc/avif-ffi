# Purgeable Memory 接入说明（avif4hybrid）

## 架构

```
仓颉 MemoryLruCache
   └─ CacheBean.purgeFrame: PurgeableFrame（FFI → libavifpurge.so）
         └─ OH_PurgeableMemory 对象（内容 = 解码 RGBA，w*h*4）
               ├─ 首建：直接 memcpy 仓颉已解码好的内容（零二次解码）
               └─ 被系统丢弃后：不做任何重建逻辑——BeginRead 返回 false，
                  上层当缓存未命中，自行走磁盘缓存/重新解码（自愈）
```

- **native 源码**：`src/main/cpp/avif4cj_purgeable.c`
- **构建脚本**：`src/main/cpp/build_purge_arm64.cmd` / `build_purge_x64.cmd`
  （产物 → `libs/arm64-v8a|libs/x86_64/libavifpurge.so`）
- **仓颉封装**：`purgeable_frame.cj`（FFI 声明 + PurgeableFrame 类）
- **ffi 注册**：cjpm.toml 新增 `[ffi.c.avifpurge]`

## 行为约定

1. 缓存写入（`cj_avifdecoder.cj` nextFrame/nthFrame 单帧路径）：
   优先创建 PurgeableFrame（携带编码字节作为重建源）；创建失败自动回退为原 Array 缓存。
2. 缓存读取（`cj_cache_check.cj` / `cache_check.cj` getMemoryCache）：
   `BeginRead → 拷贝 → EndRead`；若内容已被系统丢弃，BeginRead 内自动触发重建（重解码一次）。
3. 缓存逐出（`memory_lru_cache.cj` removeMemorySize/removeAll）：
   必须调用 `PurgeableFrame.destroy()`（释放 Purgeable 对象 + 编码数据副本）。

## 已知注意点

- **重建走胶水同路径**：`BuildContent` 在内容被丢弃后调用 libavif.so 导出的胶水函数
  （`createDecoder → nextFrame/nthFrame → destroyDecoder`），与首次解码完全同一代码路径，
  输出字节（通道顺序/预乘/裁剪/缩放）与首建一致，不会出现 R/B 互换。
  ⚠️ 不要改成用 libavif API（avifDecoderCreate + avifImageYUVToRGB）直接重解码——
  `avifRGBImage` 的 format/premultiply 设置与胶水层不一致时，会出现重建后颜色互换的问题（已踩过）。
- 重建代价：单帧重解码 5~20ms，发生在丢弃后的首次访问，动画播放场景慎用。
- 设备要求：OH_PurgeableMemory 自 API 10 起可用。
- 重新编译 native：在 `src/main/cpp` 下运行 `build_purge_arm64.cmd` / `build_purge_x64.cmd`。
