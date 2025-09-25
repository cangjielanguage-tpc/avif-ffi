package ohos_app_cangjie_avifso_test

internal import ohos.ability.AbilityStage

class MyAbilityStage <: AbilityStage {
    public override func onCreate(): Unit {
        AppLog.info("MyAbilityStage onCreated.")
    }
}
