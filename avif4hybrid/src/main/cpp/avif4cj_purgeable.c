/*
 * avif4cj_purgeable.c — Purgeable Memory 极简封装
 *
 * 定位：只作为"可丢弃的解码帧存储"。
 *   - 创建时写入解码 RGBA（w*h*4）
 *   - 系统内存压力时可丢弃内容
 *   - 内容被丢弃后【不做任何重建逻辑】：BeginRead 返回 false，
 *     上层（仓颉缓存读取方）据此判定缓存失效，自行走磁盘缓存/重新解码
 *
 * 导出接口（供仓颉 FFI 调用）：
 *   void*    AvifPurgeCreate(contentLen)              创建（内容由 InitialBuild 写入）
 *   bool     AvifPurgeBeginRead(handle)               false = 内容已被回收 → 上层当未命中
 *   void*    AvifPurgeGetContent(handle)
 *   void     AvifPurgeEndRead(handle)
 *   int32_t  AvifPurgeContentSize(handle)
 *   int32_t  AvifPurgeCopyToByteArray(handle, out, outLen)   BeginRead 失败返回 -1
 *   void     AvifPurgeDestroy(handle)
 *
 * 依赖：libpurgeable_memory_ndk.z.so（系统 NDK 库）
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <purgeable_memory/purgeable_memory.h>

typedef struct PurgeHandle {
    OH_PurgeableMemory* obj;
    uint8_t* staged;    /* 首建数据源（创建时拷贝的解码 RGBA），首建后释放 */
    size_t   stagedLen;
} PurgeHandle;

/*
 * 首建：把 staged 内容 memcpy 进来（无论系统在 Create 时还是首次 BeginRead 时调用）。
 * 内容被系统回收后的"重建"调用：staged 已释放 → 返回 false，
 * BeginRead 随之返回 false → 上层判定缓存失效（不执行任何解码逻辑）。
 */
static bool InitialBuildFunc(void* data, size_t size, void* param)
{
    PurgeHandle* h = (PurgeHandle*)param;
    if (h == NULL || h->staged == NULL || data == NULL) {
        return false;   /* 被回收后的重建：不做逻辑，上层自愈 */
    }
    memcpy(data, h->staged, size < h->stagedLen ? size : h->stagedLen);
    free(h->staged);
    h->staged = NULL;
    h->stagedLen = 0;
    return true;
}

/* 创建。content 在本函数内拷贝为首建数据源，返回 PurgeHandle*，失败返回 NULL。 */
void* AvifPurgeCreate(int32_t contentLen)
{
    if (contentLen <= 0) {
        return NULL;
    }
    PurgeHandle* h = (PurgeHandle*)malloc(sizeof(PurgeHandle));
    if (h == NULL) {
        return NULL;
    }
    h->obj = NULL;
    h->stagedLen = (size_t)contentLen;
    h->staged = (uint8_t*)malloc(h->stagedLen);
    if (h->staged == NULL) {
        free(h);
        return NULL;
    }
    h->obj = OH_PurgeableMemory_Create(h->stagedLen, InitialBuildFunc, h);
    if (h->obj == NULL) {
        free(h->staged);
        free(h);
        return NULL;
    }
    return (void*)h;
}

/* 写入内容（创建后必须调用一次，填充解码 RGBA）。
   BeginWrite → memcpy → EndWrite，返回 true 成功。 */
bool AvifPurgeWriteContent(void* handle, const uint8_t* content, int32_t contentLen)
{
    PurgeHandle* h = (PurgeHandle*)handle;
    if (h == NULL || h->obj == NULL || content == NULL || contentLen <= 0) {
        return false;
    }
    if (!OH_PurgeableMemory_BeginWrite(h->obj)) {
        return false;
    }
    void* dst = OH_PurgeableMemory_GetContent(h->obj);
    size_t sz = OH_PurgeableMemory_ContentSize(h->obj);
    if (dst != NULL) {
        memcpy(dst, content, (size_t)contentLen < sz ? (size_t)contentLen : sz);
    }
    OH_PurgeableMemory_EndWrite(h->obj);
    return dst != NULL;
}

bool AvifPurgeBeginRead(void* handle)
{
    PurgeHandle* h = (PurgeHandle*)handle;
    if (h == NULL || h->obj == NULL) {
        return false;
    }
    return OH_PurgeableMemory_BeginRead(h->obj);
}

void* AvifPurgeGetContent(void* handle)
{
    PurgeHandle* h = (PurgeHandle*)handle;
    if (h == NULL || h->obj == NULL) {
        return NULL;
    }
    return OH_PurgeableMemory_GetContent(h->obj);
}

void AvifPurgeEndRead(void* handle)
{
    PurgeHandle* h = (PurgeHandle*)handle;
    if (h == NULL || h->obj == NULL) {
        return;
    }
    OH_PurgeableMemory_EndRead(h->obj);
}

int32_t AvifPurgeContentSize(void* handle)
{
    PurgeHandle* h = (PurgeHandle*)handle;
    if (h == NULL || h->obj == NULL) {
        return -1;
    }
    size_t sz = OH_PurgeableMemory_ContentSize(h->obj);
    return (sz > 0x7FFFFFFF) ? -1 : (int32_t)sz;
}

/* 便捷读取：BeginRead → memcpy → EndRead。
   内容已被回收（BeginRead 失败）返回 -1。 */
int32_t AvifPurgeCopyToByteArray(void* handle, uint8_t* out, int32_t outLen)
{
    PurgeHandle* h = (PurgeHandle*)handle;
    if (h == NULL || h->obj == NULL || out == NULL || outLen <= 0) {
        return -1;
    }
    if (!OH_PurgeableMemory_BeginRead(h->obj)) {
        return -1;
    }
    void* content = OH_PurgeableMemory_GetContent(h->obj);
    int32_t n = -1;
    if (content != NULL) {
        size_t sz = OH_PurgeableMemory_ContentSize(h->obj);
        n = (sz < (size_t)outLen) ? (int32_t)sz : outLen;
        memcpy(out, content, (size_t)n);
    }
    OH_PurgeableMemory_EndRead(h->obj);
    return n;
}

/* 销毁：释放 Purgeable 对象 + 残留的暂存内容 */
void AvifPurgeDestroy(void* handle)
{
    PurgeHandle* h = (PurgeHandle*)handle;
    if (h == NULL) {
        return;
    }
    if (h->obj != NULL) {
        OH_PurgeableMemory_Destroy(h->obj);
        h->obj = NULL;
    }
    if (h->staged != NULL) {
        free(h->staged);
        h->staged = NULL;
    }
    free(h);
}
