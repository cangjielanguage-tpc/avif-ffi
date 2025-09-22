/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package ohos_app_cangjie_entry

internal import ohos.ability.AbilityStage

class MyAbilityStage <: AbilityStage {
    public override func onCreate(): Unit {
        AppLog.info("MyAbilityStage onCreated.")
    }
}
