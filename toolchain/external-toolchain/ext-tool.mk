#
# copy_toolchain_lib_root
#
# $1: source
# $2: destination
# $3: strip (y|n)       default is to strip
#
copy_toolchain_lib_root = \
	LIB="$(strip $1)"; \
	DST="$(strip $2)"; \
	STRIP="$(strip $3)"; \
 \
	LIB_DIR=`$(TARGET_CC) -print-file-name=$${LIB} | sed -e "s,$${LIB}\$$,,"`; \
 \
	if test -z "$${LIB_DIR}"; then \
		echo "copy_toolchain_lib_root: lib=$${LIB} not found"; \
		exit -1; \
	fi; \
 \
	LIB="$(strip $1)"; \
	for FILE in `find $${LIB_DIR} -maxdepth 1 -type l -name "$${LIB}*"`; do \
		LIB=`basename $${FILE}`; \
		while test \! -z "$${LIB}"; do \
			rm -fr $(TARGET_DIR)$${DST}/$${LIB}; \
			mkdir -p $(TARGET_DIR)$${DST}; \
			if test -h $${LIB_DIR}/$${LIB}; then \
				cp -d $${LIB_DIR}/$${LIB} $(TARGET_DIR)$${DST}/; \
			elif test -f $${LIB_DIR}/$${LIB}; then \
				$(INSTALL) -D -m0755 $${LIB_DIR}/$${LIB} $(TARGET_DIR)$${DST}/$${LIB}; \
				case "$${STRIP}" in \
				(0 | n | no) \
;; \
				(*) \
					$(TARGET_CROSS)strip "$(TARGET_DIR)$${DST}/$${LIB}"; \
;; \
				esac; \
			else \
				exit -1; \
			fi; \
			LIB="`readlink $${LIB_DIR}/$${LIB}`"; \
		done; \
	done; \
 \
	echo -n

copy_toolchain_sysroot = \
	SYSROOT_DIR=`$(TARGET_CC) -v 2>&1 | grep ^Configured | tr " " "\n" | grep -- "--with-sysroot" | cut -f2 -d=`; \
	if [ -n "$${SYSROOT_DIR}" ]; then cp -a $${SYSROOT_DIR}/* $(STAGING_DIR)/ ; \
	find $(STAGING_DIR) -type d | xargs chmod 755; fi

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_UCLIBC),y)
EXTERNAL_LIBC=libc.so.0
EXTERNAL_LIBS=ld-uClibc.so.0 libcrypt.so.0 libdl.so.0 libgcc_s.so libm.so.0 libnsl.so.0 libpthread.so.0 libresolv.so.0 librt.so.0 libutil.so.0
else
EXTERNAL_LIBC=libc.so.6
EXTERNAL_LIBS=ld-linux.so.3 libcrypt.so.1 libdl.so.2 libgcc_s.so.1 libm.so.6 libnsl.so.1 libpthread.so.0 libresolv.so.2 librt.so.1 libutil.so.1 libnss_files.so.2
endif


uclibc: dependencies $(TARGET_DIR)/lib/$(EXTERNAL_LIBC)

$(TARGET_DIR)/lib/$(EXTERNAL_LIBC):
	mkdir -p $(TARGET_DIR)/lib
	@echo "Copy external toolchain libraries to target..."
	@$(call copy_toolchain_lib_root, $(EXTERNAL_LIBC), /lib, $(BR2_TOOLCHAIN_EXTERNAL_STRIP))
	@for libs in $(EXTERNAL_LIBS); do \
		$(call copy_toolchain_lib_root, $$libs, /lib, $(BR2_TOOLCHAIN_EXTERNAL_STRIP)); \
	done
	@echo "Copy external toolchain sysroot to staging..."
	@$(call copy_toolchain_sysroot)
