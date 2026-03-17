/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package ohos_app_cangjie_avif4hybrid

import ohos.ark_interop_macro.Interop

@Interop[ArkTS]
public class CJReturnValue {
    public var code: Int32 = 0
    public var color: Option<Array<Byte>> = None
    public var issuccess: Bool = false
    //内存缓存的时候要取到图片的宽高给SIZE转pixelMap
    public var memoryWidth:Int64 = 0
    public var memoryHeight:Int64 = 0

    public init() {
    }
}
