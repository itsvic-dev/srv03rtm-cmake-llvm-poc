# using CMake and Linux to build (parts of) srv03rtm

> [!WARNING]
> you acknowledge that by viewing any portions of leaked Windows code, including code bundled with this repository, you absolve your right to contribute to ReactOS, Wine or other similar projects.

this serves as a PoC of being able to use CMake and LLVM on Linux to build winmine from the leaked Server 2003 RTM source tree.

it expects `srv03rtm` to live in here as a subdirectory, as it's used for the SDK. it can be a symlink

copy over winmine's sources from `shell/osshell/ep/winmine` to the `winmine` folder here. be careful to not remove the cmakelists or overwrite the included menu.inc as it is patched to fix building under llvm-rc

make sure that you have `clang-cl`, `lld-link` and `llvm-rc` available in PATH (with the nix flake for example), then just build it like any other cmake project:
```sh
mkdir build
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=../clang-cl-msvc-i386.cmake
make
```
