/**
 * Created on 2025/2/26
 */
package ohos_app_cangjie_libavif4cj_test

import std.unittest.expectEqual
import std.unittest.testmacro.Expect

func unittest() {
	let a = "abc"
    let b = "b"
    @Expect(a.contains(b))
    @Expect(a, a)
}