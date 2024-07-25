set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_VERSION 5.2)
set(CMAKE_SYSTEM_PROCESSOR X86)

set(_SDK_PATH "${CMAKE_SOURCE_DIR}/srv03rtm/public/sdk" CACHE STRING "")
set(SDK_LIB_PATH "${_SDK_PATH}/lib/i386" CACHE STRING "")
set(SDK_INC_PATH "${_SDK_PATH}/inc" CACHE STRING "")

# use clang-cl and lld-link
find_program(CLANG_CL_PATH NAMES clang-cl REQUIRED)
find_program(LLD_LINK_PATH NAMES lld-link REQUIRED)
set(CMAKE_C_COMPILER "${CLANG_CL_PATH}" CACHE FILEPATH "")
set(CMAKE_CXX_COMPILER "${CLANG_CL_PATH}" CACHE FILEPATH "")
set(CMAKE_LINKER "${LLD_LINK_PATH}" CACHE FILEPATH "")

# use llvm-rc instead of rc
find_program(LLVM_RC_PATH NAMES llvm-rc REQUIRED)
set(CMAKE_RC_COMPILER "${LLVM_RC_PATH}")
set(CMAKE_RC_OUTPUT_EXTENSION .res)
set(CMAKE_RC_SOURCE_FILE_EXTENSIONS .rc)
set(_CMAKE_RC_FLAGS_INITIAL "${CMAKE_RC_FLAGS}" CACHE STRING "")
set(CMAKE_RC_FLAGS "/I ${SDK_INC_PATH} ${_CMAKE_RC_FLAGS_INITIAL}")

# clang for building native binaries
find_program(CLANG_PATH NAMES clang REQUIRED)
list(APPEND _CTF_NATIVE_DEFAULT "-DCMAKE_ASM_COMPILER=${CLANG_PATH}")
list(APPEND _CTF_NATIVE_DEFAULT "-DCMAKE_C_COMPILER=${CLANG_PATH}")
list(APPEND _CTF_NATIVE_DEFAULT "-DCMAKE_CXX_COMPILER=${CLANG_PATH}")

set(CROSS_TOOLCHAIN_FLAGS_NATIVE "${_CTF_NATIVE_DEFAULT}" CACHE STRING "")

set(COMPILE_FLAGS
  -D_CRT_SECURE_NO_WARNINGS
  --target=i686-windows-msvc
  -fms-compatibility-version=13.10
  -Wno-unused-command-line-argument
  -Wno-implicit-int
  -imsvc "${SDK_INC_PATH}"
  -imsvc "${SDK_INC_PATH}/crt"
)

string(REPLACE ";" " " COMPILE_FLAGS "${COMPILE_FLAGS}")

# preserve the user's C flags
set(_CMAKE_C_FLAGS_INITIAL "${CMAKE_C_FLAGS}" CACHE STRING "")
# this shitty codebase requires ancient C standards
set(CMAKE_C_FLAGS "${_CMAKE_C_FLAGS_INITIAL} ${COMPILE_FLAGS}" CACHE STRING "" FORCE)

set(_CMAKE_CXX_FLAGS_INITIAL "${CMAKE_CXX_FLAGS}" CACHE STRING "")
set(CMAKE_CXX_FLAGS "${_CMAKE_CXX_FLAGS_INITIAL} ${COMPILE_FLAGS}" CACHE STRING "" FORCE)

set(LINK_FLAGS
  # don't invoke mt.exe
  /manifest:no
  
  -libpath:"${SDK_LIB_PATH}"
)

string(REPLACE ";" " " LINK_FLAGS "${LINK_FLAGS}")

SET(MSVC_INCREMENTAL_DEFAULT ON)

set(_CMAKE_EXE_LINKER_FLAGS_INITIAL "${CMAKE_EXE_LINKER_FLAGS}" CACHE STRING "")
set(CMAKE_EXE_LINKER_FLAGS "${_CMAKE_EXE_LINKER_FLAGS_INITIAL} ${LINK_FLAGS}" CACHE STRING "" FORCE)

set(_CMAKE_MODULE_LINKER_FLAGS_INITIAL "${CMAKE_MODULE_LINKER_FLAGS}" CACHE STRING "")
set(CMAKE_MODULE_LINKER_FLAGS "${_CMAKE_MODULE_LINKER_FLAGS_INITIAL} ${LINK_FLAGS}" CACHE STRING "" FORCE)

set(_CMAKE_SHARED_LINKER_FLAGS_INITIAL "${CMAKE_SHARED_LINKER_FLAGS}" CACHE STRING "")
set(CMAKE_SHARED_LINKER_FLAGS "${_CMAKE_SHARED_LINKER_FLAGS_INITIAL} ${LINK_FLAGS}" CACHE STRING "" FORCE)

# CMake populates these with a bunch of unnecessary libraries, which requires
# extra case-correcting symlinks and what not. Instead, let projects explicitly
# control which libraries they require.
set(CMAKE_C_STANDARD_LIBRARIES "" CACHE STRING "" FORCE)
set(CMAKE_CXX_STANDARD_LIBRARIES "" CACHE STRING "" FORCE)
