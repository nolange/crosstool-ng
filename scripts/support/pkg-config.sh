
# get the relative path back to prefix dir
toolchainbackpath=$(echo "${scriptsubdir}" | sed 's,//*[^/][^/]*,/..,g')
CT_PKGCONFIG_SYSROOT_SUBDIR="\"\${SCRIPTDIR}/${toolchainbackpath}/${CT_SYSROOT_DIR#${CT_PREFIX_DIR}}\""

cat << EOF
#!/bin/sh
SYSROOT="\$(dirname "\$(readlink -f "\$0")")/${CT_PKGCONFIG_SYSROOT_SUBDIR}"

export PKG_CONFIG_DIR=
export PKG_CONFIG_LIBDIR=${SYSROOT}/usr/lib/pkgconfig:${SYSROOT}/usr/share/pkgconfig
export PKG_CONFIG_SYSROOT_DIR=${SYSROOT}

exec /usr/bin/pkg-config "\$@"
EOF
