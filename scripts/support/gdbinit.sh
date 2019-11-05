
if [ "${CT_SHARED_LIBS}" = "y" ]; then
	cat << EOF
python sys.path.append("${CT_PREFIX_DIR}/share/gcc-${CT_GCC_VERSION}/python");
add-auto-load-safe-path ${CT_SYSROOT_DIR}/lib
EOF
fi
cat << EOF
set sysroot ${CT_SYSROOT_DIR}
EOF
