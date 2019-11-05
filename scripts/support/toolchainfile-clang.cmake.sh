GCC=/opt/hipase2/usr/bin/x86_64-linux-gnu-g++
$GCC -print-search-dirs | sed -n 's,libraries:[^/]*\(.*\),\1,p' | tr ':' ' ' | xargs realpath -m

$GCC -E -x c++ -v - < /dev/null 2>&1 >/dev/null |
  sed -n -e '/\#include <\.\.\.> search starts here:/,/End of search list\./ p' |
  sed '1d;$d' | tr '\n\r' ' ' | xargs realpath -m

set(triple arm-none-eabi)
set(clang_ext -6.0)
set(gcc_toolchain /opt/gcc-arm-none-eabi-7-2017-q4-major)
# set(gcc_ver 7.1.0)

if(NOT CMAKE_C_COMPILER)
set(_prefix)
set(_suffix)
if(triple)
	set(_prefix ${triple}-)
endif()
if(gcc_ver)
	set(_suffix -${gcc_ver})
endif()

find_program(_GCC_COMPILER_HELPER NAMES ${_prefix}gcc${_suffix} ${_prefix}gcc PATHS "${gcc_toolchain}/bin" NO_DEFAULT_PATH)

execute_process(COMMAND "${_GCC_COMPILER_HELPER}" --version OUTPUT_VARIABLE gcc_ver)
unset(_GCC_COMPILER_HELPER CACHE)
# Zeile ".*gcc .* <version>" ausschneiden
string(REGEX MATCH "[^ ]*gcc[^\r\n]*" gcc_ver "${gcc_ver}")
# <version> extrahieren
string(REGEX MATCH "[0-9\\.]+\\.[0-9\\.]+\\.[0-9\\.]+" gcc_ver "${gcc_ver}")

# Hilft derzeit nicht, erzeugt nur zusätzliche Warnungen
# set(CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN ${gcc_toolchain})

# find_program (CMAKE_C_COMPILER NAMES clang${clang_ext} clang)
# find_program (CMAKE_CXX_COMPILER NAMES clang++${clang_ext} clang++)

# find_program(CMAKE_ASM_COMPILER NAMES clang${clang_ext})
find_program(CMAKE_C_COMPILER clang${clang_ext})
find_program(CMAKE_CXX_COMPILER clang++${clang_ext})

find_program (CMAKE_RANLIB NAMES llvm-ranlib${clang_ext} lvm-ranlib)
find_program (CMAKE_NM NAMES llvm-nm${clang_ext} llvm-nm)
find_program (CMAKE_OBJDUMP NAMES llvm-objdump${clang_ext} llvm-objdump)
find_program (CMAKE_NM NAMES llvm-nm${clang_ext} llvm-nm)

find_program (CMAKE_LINKER NAMES ${_prefix}ld${_suffix} ${_prefix}ld PATHS ${gcc_toolchain}/bin NO_DEFAULT_PATH)
find_program (CMAKE_OBJCOPY NAMES ${_prefix}objcopy${_suffix} ${_prefix}objcopy PATHS ${gcc_toolchain}/bin NO_DEFAULT_PATH)
find_program (CMAKE_STRIP NAMES ${_prefix}strip${_suffix} ${_prefix}strip PATHS ${gcc_toolchain}/bin NO_DEFAULT_PATH)

find_program (CMAKE_AR NAMES llvm-ar${clang_ext} llvm-ar)
find_program (CMAKE_RANLIB NAMES llvm-ranlib${clang_ext} llvm-ranlib)

find_program(CMAKE_C_COMPILER_AR llvm-ar${clang_ext} llvm-ar)
find_program(CMAKE_CXX_COMPILER_AR llvm-ar${clang_ext} llvm-ar)
find_program (CMAKE_C_COMPILER_RANLIB NAMES llvm-ranlib${clang_ext} llvm-ranlib)
find_program (CMAKE_CXX_COMPILER_RANLIB NAMES llvm-ranlib${clang_ext} llvm-ranlib)
endif()

foreach(_thelper C CXX ASM)
	set(CMAKE_${_thelper}_COMPILER_TARGET ${triple})
	# set(CMAKE_${_thelper}_COMPILER_EXTERNAL_TOOLCHAIN ${gcc_toolchain})
	# _COMPILE_OPTIONS_EXTERNAL_TOOLCHAIN
endforeach()

set(CMAKE_SYSROOT ${gcc_toolchain}/${triple})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Notwendig damit der korrekte gcc fürs linken benutzt wird
set(CMAKE_EXE_LINKER_FLAGS "-B${gcc_toolchain}/bin/${triple}- -fuse-ld=bfd -L${gcc_toolchain}/lib/gcc/${triple}/${gcc_ver} -L${gcc_toolchain}/${triple}/lib" CACHE STRING "Flags used by the linker")

# Linken
# SET (CMAKE_LINKER      "/opt/hip-toolchain-5/bin/arm-none-eabi-ld")

set(_thelper "-isystem${gcc_toolchain}/${triple}/include/c++/${gcc_ver}")

set(CMAKE_CXX_FLAGS_INIT "${_thelper} ${_thelper}/${triple} ${_thelper}/backward -isystem${gcc_toolchain}/${triple}/include")
set(CMAKE_C_FLAGS_INIT "-isystem${gcc_toolchain}/${triple}/include")
#set(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=bfd")

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

unset(_thelper)
unset(clang_ext)
unset(gcc_toolchain)
unset(triple)
# unset(gcc_ver)

unset(_prefix)
unset(_suffix)
