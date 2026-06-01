/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

package ohos_app_cangjie_entry

import ohos.state_macro_manage.*
import ohos.component.Scroller
import ohos.component.Scroll
import ohos.router.Router

@Entry
@Component
class EntryView {
    let scroller = Scroller()

    func build() {
        Row {
            Scroll(this.scroller) {
                Column {
                    Button("index1").onClick {Router.push(url: "EntryView1")}
                    Button("index2").onClick {Router.push(url: "EntryView2")}
                    Button("index3").onClick {Router.push(url: "EntryView3")}
                    Button("index4").onClick {Router.push(url: "EntryView4")}
                    Button("index5").onClick {Router.push(url: "EntryView5")}
                    Button("index6").onClick {Router.push(url: "EntryView6")}
                    Button("index7").onClick {Router.push(url: "EntryView7")}
                    Button("index8").onClick {Router.push(url: "EntryView8")}
                    Button("index9").onClick {Router.push(url: "EntryView9")}
                    Button("index10").onClick {Router.push(url: "EntryView10")}
                    Button("example1").onClick {Router.push(url: "EntryView11")}
                    Button("example2").onClick {Router.push(url: "EntryView12")}
                }.width(100.percent)
            }
        }.height(100.percent)
    }
}
