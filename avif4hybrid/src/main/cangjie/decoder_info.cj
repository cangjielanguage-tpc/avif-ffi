/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package ohos_app_cangjie_avif4hybrid

@C
 struct DecoderInfo {
    public var address: Int64 = 0
    public var info: CPointer<Info>

    init(address: Int64, info: CPointer<Info>) {
        this.address = address
        this.info = info
    }
}
