
CT_MESON_C_COMPILER_PATH=${CT_PREFIX_DIR}/bin/${CT_TARGET}-gcc
CT_MESON_CXX_COMPILER_PATH=${CT_PREFIX_DIR}/bin/${CT_TARGET}-g++
CT_MESON_AR_COMPILER_PATH=${CT_PREFIX_DIR}/bin/${CT_TARGET}-gcc-ar
CT_MESON_STRIP_COMPILER_PATH==${CT_PREFIX_DIR}/bin/${CT_TARGET}-strip
[ -x "${CT_MESON_AR_COMPILER_PATH}" ] ||
	CT_MESON_AR_COMPILER_PATH=${CT_PREFIX_DIR}/bin/${CT_TARGET}-ar

CT_MESON_SYSTEM_NAME=$(echo "${CT_TARGET_KERNEL}" | tr [A-Z] [a-z])

CT_MESON_TARGET_CFLAGS=
CT_MESON_TARGET_CXXFLAGS=
CT_MESON_TARGET_LDFLAGS=

cat << EOF
[binaries]
c = '${CT_MESON_C_COMPILER_PATH}'
cpp ='${CT_MESON_CXX_COMPILER_PATH}'
ar = '${CT_MESON_AR_COMPILER_PATH}'
strip = '${CT_MESON_STRIP_COMPILER_PATH}'
# pkgconfig = ${CT_PREFIX_DIR}/usr/bin/pkg-config'

[properties]
needs_exe_wrapper = true
c_args = [${CT_MESON_TARGET_CFLAGS}]
c_link_args = [${CT_MESON_TARGET_LDFLAGS}]
cpp_args = [${CT_MESON_TARGET_CXXFLAGS}]
cpp_link_args = [${CT_MESON_TARGET_LDFLAGS}]

[host_machine]
system = '${CT_MESON_SYSTEM_NAME}'
cpu_family ='${CT_TARGET_ARCH}'
# cpu = ''
${CT_ARCH_ENDIAN:+endian = '${CT_ARCH_ENDIAN}'}
EOF