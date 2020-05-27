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
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(ENV{PKG_CONFIG_PATH} "")
set(ENV{PKG_CONFIG_LIBDIR} "\${CMAKE_SYSROOT}/usr/lib/pkgconfig:\${CMAKE_SYSROOT}/usr/share/pkgconfig")
set(ENV{PKG_CONFIG_SYSROOT_DIR} "\${CMAKE_SYSROOT}")

# Compiler binaries
set(CMAKE_C_COMPILER "\${PACKAGE_PREFIX_DIR}/${CT_CMAKE_C_COMPILER_PATH}")
set(CMAKE_CXX_COMPILER "\${PACKAGE_PREFIX_DIR}/${CT_CMAKE_CXX_COMPILER_PATH}")
set(CMAKE_Fortran_COMPILER "\${PACKAGE_PREFIX_DIR}/${CT_CMAKE_Fortran_COMPILER_PATH}")
set(CMAKE_OBJC_COMPILER "\${PACKAGE_PREFIX_DIR}/${CT_CMAKE_OBJC_COMPILER_PATH}")
set(CMAKE_OBJCXX_COMPILER "\${PACKAGE_PREFIX_DIR}/${CT_CMAKE_OBJCXX_COMPILER_PATH}")

# Defaults are fitting for Debug and Release builds
# Remaining settings can be seeded by using the *_INIT variables
# The *_INIT variables have been around forever, even if they are
# only documented since 3.7

# TODO: potentially set global Makros via add_definitions, much cleaner
# these might require generator expressions for the various languages

# set(CMAKE_C_FLAGS_INIT "@@CT_CMAKE_TARGET_CFLAGS@@")
# set(CMAKE_CXX_FLAGS_INIT "@@CT_CMAKE_TARGET_CXXFLAGS@@")
# set(CMAKE_EXE_LINKER_FLAGS_INIT "@@CT_CMAKE_TARGET_LDFLAGS@@")
# set(CMAKE_SHARED_LINKER_FLAGS_INIT "@@CT_CMAKE_TARGET_LDFLAGS@@")
# set(CMAKE_MODULE_LINKER_FLAGS_INIT "@@CT_CMAKE_TARGET_LDFLAGS@@")
EOF
