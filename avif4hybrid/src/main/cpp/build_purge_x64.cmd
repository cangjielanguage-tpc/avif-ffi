@echo off
rem Build libavifpurge.so (x86_64-linux-ohos, for emulator)
rem Deps: DevEco OHOS NDK, avif.h (copied from avifso), prebuilt libavif.so (x86_64)
setlocal
set "NATIVE=E:\deveco611280install\DevEco Studio\sdk\default\openharmony\native"
set "CLANG=%NATIVE%\llvm\bin\clang.exe"
set "HERE=%~dp0"
set "LIBS=%HERE%..\..\..\libs\x86_64"

"%CLANG%" --target=x86_64-linux-ohos --sysroot="%NATIVE%\sysroot" -shared -fPIC -O2 ^
  -I"%HERE%include" ^
  "%HERE%avif4cj_purgeable.c" ^
  -L"%NATIVE%\sysroot\usr\lib\x86_64-linux-ohos" -lpurgeable_memory_ndk.z ^
  -L"%LIBS%" -lavif ^
  -o "%LIBS%\libavifpurge.so"

if %ERRORLEVEL% EQU 0 (
  echo BUILD OK: %LIBS%\libavifpurge.so
) else (
  echo BUILD FAILED, errorlevel=%ERRORLEVEL%
)
endlocal
