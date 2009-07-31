#
# This file implements the support for external toolchains, i.e
# toolchains that have not been produced by Buildroot itself and that
# are already available on the system on which Buildroot runs.
#
# The basic principle is the following
#
#  1. Perform some checks on the conformity between the toolchain
#  configuration described in the Buildroot menuconfig system, and the
#  real configuration of the external toolchain. This is for example
#  important to make sure that the Buildroot configuration system
#  knows whether the toolchain supports RPC, IPv6, locales, large
#  files, etc. Unfortunately, these things cannot be detected
#  automatically, since the value of these options (such as
#  BR2_INET_RPC) are needed at configuration time because these
#  options are used as dependencies for other options. And at
#  configuration time, we are not able to retrieve the external
#  toolchain configuration.
#
#  2. Copy the libraries needed at runtime to the target directory,
#  $(TARGET_DIR). Obviously, things such as the C library, the dynamic
#  loader and a few other utility libraries are needed if dynamic
#  applications are to be executed on the target system.
#
#  3. Copy the libraries and headers to the staging directory. This
#  will allow all further calls to gcc to be made using --sysroot
#  $(STAGING_DIR), which greatly simplifies the compilation of the
#  packages when using external toolchains. So in the end, only the
#  cross-compiler binaries remains external, all libraries and headers
#  are imported into the Buildroot tree.

#
# Copy a toolchain library and its symbolic links from the sysroot
# directory to the target directory. Also optionaly strips the
# library.
#
# $1: sysroot directory
# $2: library name
# $3: destination directory
# $4: strip (y|n), default is to strip
#
copy_toolchain_lib_root = \
	SYSROOT_DIR="$(strip $1)"; \
	LIB="$(strip $2)"; \
	DST="$(strip $3)"; \
	STRIP="$(strip $4)"; \
 \
	LIB_DIR="$${SYSROOT_DIR}/lib" ; \
	for FILE in `find $${LIB_DIR} -maxdepth 1 -name "$${LIB}.*"`; do \
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

#
# Copy the full external toolchain sysroot directory to the staging
# dir
#
# $1: sysroot directory
#
copy_toolchain_sysroot = \
	SYSROOT_DIR="$(strip $1)"; \
	cp -a $${SYSROOT_DIR}/* $(STAGING_DIR)/ ; \
	find $(STAGING_DIR) -type d | xargs chmod 755

#
# Check the availability of a particular glibc feature. We assume that
# all Buildroot toolchain options are supported by glibc, so we just
# check that they are enabled.
#
# $1: Buildroot option name
# $2: feature description
#
check_glibc_feature = \
	if [ x$($(1)) != x"y" ] ; then \
		echo "$(2) available in C library, please enable $(1)" ; \
		exit 1 ; \
	fi

#
# Check the correctness of a glibc external toolchain configuration.
#  1. Check that the C library selected in Buildroot matches the one
#     of the external toolchain
#  2. Check that all the C library-related features are enabled in the
#     config, since glibc always supports all of them
#
# $1: sysroot directory
#
check_glibc = \
	SYSROOT_DIR="$(strip $1)"; \
	if ! test -f $${SYSROOT_DIR}/lib/ld-linux.so.* ; then \
		echo "Incorrect selection of the C library"; \
		exit -1; \
	fi; \
	$(call check_glibc_feature,BR2_LARGEFILE,Large file support) ;\
	$(call check_glibc_feature,BR2_INET_IPV6,IPv6 support) ;\
	$(call check_glibc_feature,BR2_INET_RPC,RPC support) ;\
	$(call check_glibc_feature,BR2_ENABLE_LOCALE,Locale support) ;\
	$(call check_glibc_feature,BR2_USE_WCHAR,Wide char support) ;\
	$(call check_glibc_feature,BR2_PROGRAM_INVOCATION,Program invocation support)

#
# Check the conformity of Buildroot configuration with regard to the
# uClibc configuration of the external toolchain, for a particular
# feature.
#
# $1: uClibc macro name
# $2: Buildroot option name
# $3: uClibc config file
# $4: feature description
#
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

#
# Check the correctness of a uclibc external toolchain configuration
#  1. Check that the C library selected in Buildroot matches the one
#     of the external toolchain
#  2. Check that the features enabled in the Buildroot configuration
#     match the features available in the uClibc of the external
#     toolchain
#
# $1: sysroot directory
#
check_uclibc = \
	SYSROOT_DIR="$(strip $1)"; \
	if ! test -f $${SYSROOT_DIR}/lib/ld-uClibc.so.* ; then \
		echo "Incorrect selection of the C library"; \
		exit -1; \
	fi; \
	UCLIBC_CONFIG_FILE=$${SYSROOT_DIR}/usr/include/bits/uClibc_config.h ; \
	$(call check_uclibc_feature,__UCLIBC_HAS_LFS__,BR2_LARGEFILE,$${UCLIBC_CONFIG_FILE},Large file support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_IPV6__,BR2_INET_IPV6,$${UCLIBC_CONFIG_FILE},IPv6 support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_RPC__,BR2_INET_RPC,$${UCLIBC_CONFIG_FILE},RPC support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_LOCALE__,BR2_ENABLE_LOCALE,$${UCLIBC_CONFIG_FILE},Locale support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_WCHAR__,BR2_USE_WCHAR,$${UCLIBC_CONFIG_FILE},Wide char support) ;\
	$(call check_uclibc_feature,__UCLIBC_HAS_PROGRAM_INVOCATION_NAME__,BR2_PROGRAM_INVOCATION,$${UCLIBC_CONFIG_FILE},Program invocation support) ;\

#
# Check that the Buildroot configuration of the ABI matches the
# configuration of the external toolchain.
#
check_arm_abi = \
	EXT_TOOLCHAIN_TARGET=$(shell LANG=C $(TARGET_CC) -v 2>&1 | grep ^Target | cut -f2 -d ' ') ; \
	if echo $${EXT_TOOLCHAIN_TARGET} | grep -q 'eabi$$' ; then \
		EXT_TOOLCHAIN_ABI="eabi" ; \
	else \
		EXT_TOOLCHAIN_ABI="oabi" ; \
	fi ; \
	if [ x$(BR2_ARM_OABI) == x"y" -a $${EXT_TOOLCHAIN_ABI} == "eabi" ] ; then \
		echo "Incorrect ABI setting" ; \
		exit 1 ; \
	fi ; \
	if [ x$(BR2_ARM_EABI) == x"y" -a $${EXT_TOOLCHAIN_ABI} == "oabi" ] ; then \
		echo "Incorrect ABI setting" ; \
		exit 1 ; \
	fi ; \

#
# Check that the cross-compiler given in the configuration exists
#
check_cross_compiler_exists = \
	if ! test -x $(TARGET_CC) ; then \
		echo "Cannot find cross-compiler $(TARGET_CC)" ; \
		exit 1 ; \
	fi ; \

uclibc: dependencies $(STAMP_DIR)/ext-toolchain-installed

EXTERNAL_LIBS=libc.so libcrypt.so libdl.so libgcc_s.so libm.so libnsl.so libpthread.so libresolv.so librt.so libutil.so
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_UCLIBC),y)
EXTERNAL_LIBS+=ld-uClibc.so
else
EXTERNAL_LIBS+=ld-linux.so libnss_files.so
endif

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
EXTERNAL_LIBS+=libstdc++.so
endif

SYSROOT_DIR=$(shell LANG=C $(TARGET_CC) -v 2>&1 | grep ^Configured | tr " " "\n" | grep -- "--with-sysroot" | cut -f2 -d=)

$(STAMP_DIR)/ext-toolchain-installed:
	@echo "Checking external toolchain settings"
	$(Q)$(call check_cross_compiler_exists)
ifeq ($(strip $(SYSROOT_DIR)),)
	@echo "External toolchain doesn't support --sysroot. Cannot use."
	exit 1
endif
ifeq ($(BR2_arm),y)
	$(Q)$(call check_arm_abi)
endif
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_UCLIBC),y)
	$(Q)$(call check_uclibc,$(SYSROOT_DIR))
else
	$(Q)$(call check_glibc,$(SYSROOT_DIR))
endif
	mkdir -p $(TARGET_DIR)/lib
	@echo "Copy external toolchain libraries to target..."
	$(Q)for libs in $(EXTERNAL_LIBS); do \
		$(call copy_toolchain_lib_root,$(SYSROOT_DIR),$$libs,/lib,$(BR2_TOOLCHAIN_EXTERNAL_STRIP)); \
	done
	@echo "Copy external toolchain sysroot to staging..."
	$(Q)$(call copy_toolchain_sysroot,$(SYSROOT_DIR))
	@touch $@
