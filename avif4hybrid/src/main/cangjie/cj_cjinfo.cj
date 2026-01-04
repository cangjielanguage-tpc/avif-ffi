/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package ohos_app_cangjie_avif4hybrid

import ohos.ark_interop_macro.Interop

@Interop[ArkTS]
public class CJCjinfo {
    public var width: UInt32 = 0
    public var height: UInt32 = 0
    public var depth: UInt32 = 0
    public var alphaPresent: Bool = false
    public var frameCount: Int32 = 0
    public var repetitionCount: Int32 = 0
    public var frameDurations: JSArrayEx<Float64> = JSArrayEx<Float64>()

    public init() {
    }

    public func setWidth(width: UInt32): Unit {
        this.width = width
    }

    public func setHeight(height: UInt32): Unit {
        this.height = height
    }

    public func setDepth(depth: UInt32): Unit {
        this.depth = depth
    }

    public func setAlphaPresent(alphaPresent: Bool): Unit {
        this.alphaPresent = alphaPresent
    }

    public func setFrameCount(frameCount: Int32): Unit {
        this.frameCount = frameCount
    }

    public func setRepetitionCount(repetitionCount: Int32): Unit {
        this.repetitionCount = repetitionCount
    }

    public func setFrameDurations(frameDurations: JSArrayEx<Float64>): Unit {
        this.frameDurations = frameDurations
    }
}
