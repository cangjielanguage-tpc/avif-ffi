/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package ohos_app_cangjie_entry

import ohos.arkui.state_macro_manage.*
import ohos.arkui.component.Scroller
import ohos.arkui.component.Scroll
import ohos.arkui.ui_context.Router
@Entry
@Component
class EntryView {
    let scroller = Scroller()

    func build() {
        Row {
            Scroll(this.scroller) {
                Column {
                    Button("index1").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView1")})
                    Button("index2").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView2")})
                    Button("index3").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView3")})
                    Button("index4").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView4")})
                    Button("index5").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView5")})
                    Button("index6").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView6")})
                    Button("index7").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView7")})
                    Button("index8").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView8")})
                    Button("index9").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView9")})
                    Button("index10").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView10")})
                    Button("example1").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView11")})
                    Button("example2").onClick ({e=>getUIContext().getRouter().pushUrl(url: "EntryView12")})
                }.width(100.percent)
            }
        }.height(100.percent)
    }
}
