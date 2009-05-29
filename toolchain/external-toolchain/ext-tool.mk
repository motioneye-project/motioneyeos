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

check_clibrary = \
	if ! test -f `$(TARGET_CC) -print-file-name=$(EXTERNAL_LIBC)` ; then \
		echo "Incorrect selection of the C library"; \
		exit -1; \
	fi

# 1: Buildroot option name
# 2: message
check_glibc_feature = \
	if [ x$($(1)) != x"y" ] ; then \
		echo "$(2) available in C library, please enable $(1)" ; \
		exit 1 ; \
	fi

check_glibc = \
	$(call check_glibc_feature,BR2_LARGEFILE,Large file support) ;\
	$(call check_glibc_feature,BR2_INET_IPV6,IPv6 support) ;\
	$(call check_glibc_feature,BR2_INET_RPC,RPC support) ;\
	$(call check_glibc_feature,BR2_ENABLE_LOCALE,Locale support) ;\
	$(call check_glibc_feature,BR2_USE_WCHAR,Wide char support)

# 1: uClibc macro name
# 2: Buildroot option name
# 3: uClibc config file
# 4: message
check_uclibc_feature = \
	IS_IN_LIBC=`grep -q "\#define $(1) 1" $(3) && echo y` ; \
	if [ x$($(2)) != x"y" -a x$${IS_IN_LIBC} == x"y" ] ; then \
		echo "$(4) available in C library, please enable $(2)" ; \
		exit 1 ; \
	fi ; \
	if [ x$($(2)) == x"y" -a x$${IS_IN_LIBC} != x"y" ] ; then \
		echo "$(4) not available in C library, please disable $(2)" ; \
		exit 1 ; \
	fi

check_uclibc = \
	SYSROOT_DIR=`$(TARGET_CC) -v 2>&1 | grep ^Configured | tr " " "\n" | grep -- "--with-sysroot" | cut -f2 -d=`; \
	UCLIBC_CONFIG_FILE=$${SYSROOT_DIR}/usr/include/bits/uClibc_config.h ; \
	$(call check_uclibc_feature,__UCLIBC_HAS_LFS__,BR2_LARGEFILE,$${UCLIBC_CONFIG_FILE},Large file support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_IPV6__,BR2_INET_IPV6,$${UCLIBC_CONFIG_FILE},IPv6 support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_RPC__,BR2_INET_RPC,$${UCLIBC_CONFIG_FILE},RPC support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_LOCALE__,BR2_ENABLE_LOCALE,$${UCLIBC_CONFIG_FILE},Locale support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_WCHAR__,BR2_USE_WCHAR,$${UCLIBC_CONFIG_FILE},Wide char support) ;\

uclibc: dependencies $(TARGET_DIR)/lib/$(EXTERNAL_LIBC)

$(TARGET_DIR)/lib/$(EXTERNAL_LIBC):
	@echo "Checking external toolchain settings"
	@$(call check_clibrary)
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_UCLIBC),y)
	@$(call check_uclibc)
else
	@$(call check_glibc)
endif
	mkdir -p $(TARGET_DIR)/lib
	@echo "Copy external toolchain libraries to target..."
	@$(call copy_toolchain_lib_root, $(EXTERNAL_LIBC), /lib, $(BR2_TOOLCHAIN_EXTERNAL_STRIP))
	@for libs in $(EXTERNAL_LIBS); do \
		$(call copy_toolchain_lib_root, $$libs, /lib, $(BR2_TOOLCHAIN_EXTERNAL_STRIP)); \
	done
	@echo "Copy external toolchain sysroot to staging..."
	@$(call copy_toolchain_sysroot)
