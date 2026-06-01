// build.cj


 import std.process.*
 import std.fs.*
 // Case of pre/post codes for 'cjpm build'.
 /* called before `cjpm build`
  * Success: return 0
  * Error: return any number except 0
  */


 func stagePreBuild(): Int64 {
     // process before "cjpm build"
     let sourcePathArm64 = "./build/default/intermediates/libs/default/arm64-v8a/libavif.so"
     let sourcePathX86 = "./build/default/intermediates/libs/default/x86_64/libavif.so"
     while (!exists(sourcePathArm64) || !exists(sourcePathX86)) {
     }
     0
 }


 /*
  * called after `cjpm build`
  */
 // func stagePostBuild(): Int64 {
 //     // process after "cjpm build"
 //     0
 // }


 // Case of pre/post codes for 'cjpm clean'.
 /* called before `cjpm clean`
  * Success: return 0
  * Error: return any number except 0
  */
 // func stagePreClean(): Int64 {
 //     // process before "cjpm clean"
 //     0
 // }


 /*
  * called after `cjpm clean`
  */
 // func stagePostClean(): Int64 {
 //     // process after "cjpm clean"
 //     0
 // }


 // For other options, define stagePreXXX and stagePostXXX in the same way.


 /*
  * Error code:
  * 0: success.
  * other: cjpm will finish running command. Check target-dir/build-script-cache/module-name/script-log for error outputs defind by user in functions.
  */
 main(): Int64 {
     match (Process.current.arguments[0]) {
         // Add operation here with format: "pre-"/"post-" + optionName
         case "pre-build" => stagePreBuild()
         // case "post-build" => stagePostBuild()
         // case "pre-clean" => stagePreClean()
         // case "post-clean" => stagePostClean()
         case _ => 0
     }
 }