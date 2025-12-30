/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_avif4hybrid

internal import ohos.component.*
internal import ohos.base.*
internal import ohos.state_manage.*
internal import ohos.matrix4.*
internal import ohos.resource_manager.*
internal import ohos.display.getDefaultDisplaySync
internal import ohos.ark_interop.*
internal import ohos.ark_interop_helper.*
internal import std.collection.*
internal import std.sync.ReentrantMutex
internal import std.process.Process
internal import std.collection.concurrent.ConcurrentHashMap
internal import std.convert.Parsable
internal import ohos.hilog.Hilog
internal import ohos.device_info.DeviceInfo
internal import ohos.image.createImageSource