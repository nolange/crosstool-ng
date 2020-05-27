: << 'EOF'
CT_CMAKE_SYS_KERNEL: Should be one of Linux, Window, Darwin or Generic
CT_CMAKE_SYSTEM_PROCESSOR: Research
EOF

# get the relative path back to prefix dir
toolchainbackpath=$(echo "${scriptsubdir}" | sed 's,//*[^/][^/]*,/..,g')

# Todo: map these to cmake systems
case ${CT_TARGET_KERNEL} in
  [Ll]inux) CT_CMAKE_SYSTEM_NAME=Linux;;
esac
CT_CMAKE_SYSTEM_NAME=${CT_TARGET_KERNEL:-Generic}
CT_CMAKE_SYSTEM_PROCESSOR=${CT_TARGET_ARCH}
CT_CMAKE_SYSTEM_VERSION=${CT_LINUX_VERSION:-1}

# CT_ARCH_ENDIAN

CT_CMAKE_SYSROOT_SUBDIR=${CT_SYSROOT_DIR#${CT_PREFIX_DIR}}
CT_CMAKE_C_COMPILER_PATH=bin/${CT_TARGET}-gcc
CT_CMAKE_CXX_COMPILER_PATH=bin/${CT_TARGET}-g++
CT_CMAKE_Fortran_COMPILER_PATH=bin/${CT_TARGET}-gfortran
CT_CMAKE_OBJC_COMPILER_PATH=bin/${CT_TARGET}-gobjc
CT_CMAKE_OBJCXX_COMPILER_PATH=bin/${CT_TARGET}-gobjc++

cat << EOF
# CMake toolchain file

# Allow relocation of the toolchain, PACKAGE_PREFIX_DIR
# should point to the root installation (CT prefix path during build)
get_filename_component(PACKAGE_PREFIX_DIR "\${CMAKE_CURRENT_LIST_DIR}${toolchainbackpath}" ABSOLUTE)

set(CMAKE_SYSTEM_NAME ${CT_CMAKE_SYSTEM_NAME})
set(CMAKE_SYSTEM_PROCESSOR ${CT_CMAKE_SYSTEM_PROCESSOR})
set(CMAKE_SYSTEM_VERSION ${CT_CMAKE_SYSTEM_VERSION})

set(CMAKE_INSTALL_SO_NO_EXE 0)

# Generic paths and search settings
set(CMAKE_PROGRAM_PATH "\${PACKAGE_PREFIX_DIR}/bin")
set(CMAKE_SYSROOT "\${PACKAGE_PREFIX_DIR}${CT_CMAKE_SYSROOT_SUBDIR}")
set(CMAKE_FIND_ROOT_PATH "\${CMAKE_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


set(gcc_toolchain \${PACKAGE_PREFIX_DIR})

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

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)


foreach(_thelper C CXX ASM)
	set(CMAKE_${_thelper}_COMPILER_TARGET ${triple})
	# set(CMAKE_${_thelper}_COMPILER_EXTERNAL_TOOLCHAIN ${gcc_toolchain})
	# _COMPILE_OPTIONS_EXTERNAL_TOOLCHAIN
endforeach()

# Notwendig damit der korrekte gcc fürs linken benutzt wird
set(CMAKE_EXE_LINKER_FLAGS "-B${gcc_toolchain}/bin/${triple}- -fuse-ld=bfd -L${gcc_toolchain}/lib/gcc/${triple}/${gcc_ver} -L${gcc_toolchain}/${triple}/lib" CACHE STRING "Flags used by the linker")

# Linken
# SET (CMAKE_LINKER      "/opt/hip-toolchain-5/bin/arm-none-eabi-ld")

set(_thelper "-isystem${gcc_toolchain}/${triple}/include/c++/${gcc_ver}")

set(CMAKE_CXX_FLAGS_INIT "${_thelper} ${_thelper}/${triple} ${_thelper}/backward -isystem${gcc_toolchain}/${triple}/include")
set(CMAKE_C_FLAGS_INIT "-isystem${gcc_toolchain}/${triple}/include")
#set(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=bfd")

unset(_thelper)
unset(clang_ext)
unset(gcc_toolchain)
unset(triple)
# unset(gcc_ver)

unset(_prefix)
unset(_suffix)
EOF
