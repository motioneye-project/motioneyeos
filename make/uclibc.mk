#############################################################
#
# uClibc (the C library)
#
#############################################################
ifeq ($(USE_UCLIBC_SNAPSHOT),true)
# Be aware that this changes daily....
UCLIBC_DIR=$(BUILD_DIR)/uClibc
UCLIBC_SOURCE=uClibc-snapshot.tar.bz2
UCLIBC_SITE:=http://www.uclibc.org/downloads/snapshots
else
UCLIBC_DIR:=$(BUILD_DIR)/uClibc-0.9.26
UCLIBC_SOURCE:=uClibc-0.9.26.tar.bz2
UCLIBC_SITE:=http://www.uclibc.org/downloads
endif

UCLIBC_TARGET_ARCH:=$(shell echo $(ARCH) | sed -e s'/-.*//' \
                -e 's/i.86/i386/' \
		-e 's/sparc.*/sparc/' \
		-e 's/arm.*/arm/g' \
		-e 's/m68k.*/m68k/' \
		-e 's/ppc/powerpc/g' \
		-e 's/v850.*/v850/g' \
		-e 's/sh64/sh/' \
		-e 's/sh[234]/sh/' \
		-e 's/mips.*/mips/' \
		-e 's/mipsel.*/mips/' \
		-e 's/cris.*/cris/' \
)


$(DL_DIR)/$(UCLIBC_SOURCE):
	$(WGET) -P $(DL_DIR) $(UCLIBC_SITE)/$(UCLIBC_SOURCE)

$(UCLIBC_DIR)/.unpacked: $(DL_DIR)/$(UCLIBC_SOURCE)
	bzcat $(DL_DIR)/$(UCLIBC_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	#(cd $(BUILD_DIR) ; ln -s $(DL_DIR)/uClibc)
	#-mkdir $(UCLIBC_DIR)
	#(cd $(DL_DIR)/uClibc && tar cf - .) | (cd $(UCLIBC_DIR) && tar xvfp - )
	touch $(UCLIBC_DIR)/.unpacked

$(UCLIBC_DIR)/.configured: $(UCLIBC_DIR)/.unpacked $(LINUX_DIR)/.configured
	$(SED) 's,^CROSS=.*,CROSS=$(TARGET_CROSS),g' $(UCLIBC_DIR)/Rules.mak
ifeq ($(ENABLE_LOCALE),true)
	cp $(SOURCE_DIR)/uClibc.config-locale $(UCLIBC_DIR)/.config
else
	cp $(SOURCE_DIR)/uClibc.config $(UCLIBC_DIR)/.config
endif
	$(SED) 's,^.*TARGET_$(UCLIBC_TARGET_ARCH).*,TARGET_$(UCLIBC_TARGET_ARCH)=y,g' \
		$(UCLIBC_DIR)/.config
	$(SED) 's,^TARGET_ARCH.*,TARGET_ARCH=\"$(UCLIBC_TARGET_ARCH)\",g' $(UCLIBC_DIR)/.config
	$(SED) 's,^KERNEL_SOURCE=.*,KERNEL_SOURCE=\"$(LINUX_DIR)\",g' \
		$(UCLIBC_DIR)/.config
	$(SED) 's,^RUNTIME_PREFIX=.*,RUNTIME_PREFIX=\"/\",g' \
		$(UCLIBC_DIR)/.config
	$(SED) 's,^DEVEL_PREFIX=.*,DEVEL_PREFIX=\"/usr/\",g' \
		$(UCLIBC_DIR)/.config
	$(SED) 's,^SHARED_LIB_LOADER_PREFIX=.*,SHARED_LIB_LOADER_PREFIX=\"/lib\",g' \
		$(UCLIBC_DIR)/.config
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
	$(SED) 's,^.*UCLIBC_HAS_LFS.*,UCLIBC_HAS_LFS=y,g' $(UCLIBC_DIR)/.config
else
	$(SED) 's,^.*UCLIBC_HAS_LFS.*,UCLIBC_HAS_LFS=n,g' $(UCLIBC_DIR)/.config
endif
	$(SED) 's,.*UCLIBC_HAS_WCHAR.*,UCLIBC_HAS_WCHAR=y,g' $(UCLIBC_DIR)/.config
	if [ -n "$(strip $(TARGET_SOFT_FLOAT))" ] ; then \
		$(SED) 's,.*HAS_FPU.*,HAS_FPU=n\nUCLIBC_HAS_FLOATS=y\nUCLIBC_HAS_SOFT_FLOAT=y,g' \
			$(UCLIBC_DIR)/.config; \
	fi
	$(MAKE) -C $(UCLIBC_DIR) \
		PREFIX=$(STAGING_DIR)/ \
		DEVEL_PREFIX=$(REAL_GNU_TARGET_NAME)/ \
		RUNTIME_PREFIX=$(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/ \
		pregen install_dev;
	touch $(UCLIBC_DIR)/.configured

$(UCLIBC_DIR)/lib/libc.a: $(UCLIBC_DIR)/.configured $(LIBFLOAT_TARGET)
	$(MAKE) -C $(UCLIBC_DIR) \
		PREFIX= \
		DEVEL_PREFIX=$(REAL_GNU_TARGET_NAME)/ \
		RUNTIME_PREFIX=/ \
		all

$(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/lib/libc.a: $(UCLIBC_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) \
		PREFIX=$(STAGING_DIR)/ \
		DEVEL_PREFIX=$(REAL_GNU_TARGET_NAME)/ \
		RUNTIME_PREFIX=$(REAL_GNU_TARGET_NAME)/ \
		install_runtime
	$(MAKE) -C $(UCLIBC_DIR) \
		PREFIX=$(STAGING_DIR)/ \
		DEVEL_PREFIX=$(REAL_GNU_TARGET_NAME)/ \
		RUNTIME_PREFIX=$(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/ \
		install_dev
	$(MAKE) -C $(UCLIBC_DIR) \
		PREFIX=$(STAGING_DIR) \
		utils install_utils
	# Clean up the host compiled utils...
	$(MAKE) -C $(UCLIBC_DIR)/utils clean

ifneq ($(TARGET_DIR),)
$(TARGET_DIR)/lib/libc.so.0: $(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) \
		PREFIX=$(TARGET_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=/ \
		install_runtime

$(TARGET_DIR)/usr/bin/ldd: $(TARGET_DIR)/lib/libc.so.0
	$(MAKE) -C $(UCLIBC_DIR) $(TARGET_CONFIGURE_OPTS) \
		PREFIX=$(TARGET_DIR) utils install_utils

UCLIBC_TARGETS=$(TARGET_DIR)/lib/libc.so.0 $(TARGET_DIR)/usr/bin/ldd
endif

uclibc-configured: $(UCLIBC_DIR)/.configured

uclibc: $(STAGING_DIR)/bin/$(REAL_GNU_TARGET_NAME)-gcc $(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/lib/libc.a \
	$(UCLIBC_TARGETS)

uclibc-source: $(DL_DIR)/$(UCLIBC_SOURCE)

uclibc-configured-source: uclibc-source

uclibc-clean:
	-$(MAKE) -C $(UCLIBC_DIR) clean
	rm -f $(UCLIBC_DIR)/.config

uclibc-dirclean:
	rm -rf $(UCLIBC_DIR)




#############################################################
#
# uClibc for the target just needs its header files
# and whatnot installed.
#
#############################################################

$(TARGET_DIR)/usr/lib/libc.a: $(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) \
		PREFIX=$(TARGET_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=/ \
		install_dev

ifeq ($(GCC_2_95_TOOLCHAIN),true)
uclibc_target: gcc2_95 uclibc $(TARGET_DIR)/usr/lib/libc.a
else
uclibc_target: gcc3_3 uclibc $(TARGET_DIR)/usr/lib/libc.a
endif

uclibc_target-clean:
	rm -f $(TARGET_DIR)/include

uclibc_target-dirclean:
	rm -f $(TARGET_DIR)/include

