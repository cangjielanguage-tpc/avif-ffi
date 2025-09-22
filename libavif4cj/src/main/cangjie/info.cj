/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
package libavif4cj

@C
public struct Info {
    public var width: UInt32 = 0
    public var height: UInt32 = 0
    public var depth: UInt32 = 0
    public var alphaPresent: Bool = false
    public var frameCount: Int32 = 0
    public var repetitionCount: Int32 = 0
    public var frameDurations: CPointer<Float64> = CPointer<Float64>()

    init(width: UInt32, height: UInt32, depth: UInt32, alphaPresent: Bool, frameCount: Int32, repetitionCount: Int32,
        frameDurations: CPointer<Float64>) {
        this.width = width
        this.height = height
        this.depth = depth
        this.alphaPresent = alphaPresent
        this.frameCount = frameCount
        this.repetitionCount = repetitionCount
        this.frameDurations = frameDurations
    }
}
