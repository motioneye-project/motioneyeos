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
UCLIBC_DIR:=$(BUILD_DIR)/uClibc-0.9.21
UCLIBC_SOURCE:=uClibc-0.9.21.tar.bz2
UCLIBC_SITE:=http://www.uclibc.org/downloads
endif

$(DL_DIR)/$(UCLIBC_SOURCE):
	$(WGET) -P $(DL_DIR) $(UCLIBC_SITE)/$(UCLIBC_SOURCE)

uclibc-source: $(DL_DIR)/$(UCLIBC_SOURCE) #$(UCLIBC_PATCH)

$(UCLIBC_DIR)/.unpacked: $(DL_DIR)/$(UCLIBC_SOURCE)
	bzcat $(DL_DIR)/$(UCLIBC_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(UCLIBC_DIR)/.unpacked

$(UCLIBC_DIR)/.configured: $(UCLIBC_DIR)/.unpacked $(BUILD_DIR)/linux/.configured
	perl -i -p -e 's,^CROSS=.*,CROSS=$(TARGET_CROSS),g' $(UCLIBC_DIR)/Rules.mak
ifeq ($(ENABLE_LOCALE),true)
	cp $(SOURCE_DIR)/uClibc.config-locale $(UCLIBC_DIR)/.config
else
	cp $(SOURCE_DIR)/uClibc.config $(UCLIBC_DIR)/.config
endif
	perl -i -p -e 's,^TARGET_[a-z].*,TARGET_$(ARCH)=y,g' $(UCLIBC_DIR)/.config
	perl -i -p -e 's,^TARGET_ARCH.*,TARGET_ARCH=\"$(ARCH)\",g' $(UCLIBC_DIR)/.config
	perl -i -p -e 's,^KERNEL_SOURCE=.*,KERNEL_SOURCE=\"$(LINUX_DIR)\",g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,^RUNTIME_PREFIX=.*,RUNTIME_PREFIX=\"$(STAGING_DIR)\",g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,^DEVEL_PREFIX=.*,DEVEL_PREFIX=\"$(STAGING_DIR)\",g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,^SYSTEM_DEVEL_PREFIX=.*,SYSTEM_DEVEL_PREFIX=\"$(STAGING_DIR)\",g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,^DEVEL_TOOL_PREFIX=.*,DEVEL_TOOL_PREFIX=\"$(STAGING_DIR)/usr\",g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,^SHARED_LIB_LOADER_PATH=.*,SHARED_LIB_LOADER_PATH=\"/lib\",g' \
		$(UCLIBC_DIR)/.config
	perl -i -p -e 's,.*UCLIBC_HAS_WCHAR.*,UCLIBC_HAS_WCHAR=y\nUCLIBC_HAS_LOCALE=n,g' \
		$(UCLIBC_DIR)/.config
	if [ -n "$(strip $(TARGET_SOFT_FLOAT))" ] ; then \
		perl -i -p -e 's,.*HAS_FPU.*,# HAS_FPU is not set\nUCLIBC_HAS_SOFT_FLOAT=y,g' \
			$(UCLIBC_DIR)/.config; \
	fi
	perl -i -p -e 's,^GCC_BIN.*,GCC_BIN=$(STAGING_DIR)/bin/$(ARCH)-linux-gcc,g' \
		$(UCLIBC_DIR)/extra/gcc-uClibc/Makefile
	perl -i -p -e 's,^LD_BIN.*,LD_BIN=$(STAGING_DIR)/bin/$(ARCH)-linux-ld,g' \
		$(UCLIBC_DIR)/extra/gcc-uClibc/Makefile
	$(MAKE) -C $(UCLIBC_DIR) oldconfig
	$(MAKE) -C $(UCLIBC_DIR) pregen
	$(MAKE) -C $(UCLIBC_DIR) headers
	$(MAKE) -C $(UCLIBC_DIR) install_dev;
	touch $(UCLIBC_DIR)/.configured

$(UCLIBC_DIR)/lib/libc.a: $(UCLIBC_DIR)/.configured $(LIBFLOAT_TARGET)
	$(MAKE) -C $(UCLIBC_DIR)

$(STAGING_DIR)/lib/libc.a: $(UCLIBC_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) install_dev install_runtime install_utils

ifneq ($(TARGET_DIR),)
$(TARGET_DIR)/lib/libc.so.0: $(STAGING_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) \
		RUNTIME_PREFIX=$(TARGET_DIR) \
		DEVEL_PREFIX=$(TARGET_DIR) \
		SYSTEM_DEVEL_PREFIX=$(TARGET_DIR) \
		DEVEL_TOOL_PREFIX=$(TARGET_DIR)/usr install_runtime

$(TARGET_DIR)/usr/bin/ldd: $(TARGET_DIR)/lib/libc.so.0
	$(MAKE) -C $(UCLIBC_DIR) PREFIX=$(TARGET_DIR) install_target_utils

UCLIBC_TARGETS=$(TARGET_DIR)/lib/libc.so.0 $(TARGET_DIR)/usr/bin/ldd
endif

uclibc-configured: $(UCLIBC_DIR)/.configured

uclibc: $(STAGING_DIR)/bin/$(ARCH)-linux-gcc $(STAGING_DIR)/lib/libc.a \
	$(UCLIBC_TARGETS)

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

$(TARGET_DIR)/usr/lib/libc.a: $(STAGING_DIR)/lib/libc.a
	$(MAKE) RUNTIME_PREFIX=$(TARGET_DIR) \
		DEVEL_PREFIX=$(TARGET_DIR)/usr \
		SYSTEM_DEVEL_PREFIX=$(TARGET_DIR) \
		DEVEL_TOOL_PREFIX=$(TARGET_DIR) -C $(UCLIBC_DIR) \
		install_dev
	(cd $(TARGET_DIR)/usr/lib; \
		ln -fs /lib/libc.so.0 libc.so; \
		ln -fs /lib/libdl.so.0 libdl.so; \
		ln -fs /lib/libcrypt.so.0 libcrypt.so; \
		ln -fs /lib/libresolv.so.0 libresolv.so; \
		ln -fs /lib/libutil.so.0 libutil.so; \
		ln -fs /lib/libm.so.0 libm.so; \
		ln -fs /lib/libpthread.so.0 libpthread.so; \
		ln -fs /lib/libnsl.so.0 libnsl.so; \
		\
		ln -fs /lib/libthread_db.so.1 libthread_db.so; \
		rm -f ld-uClibc-0.9.21.so; \
		rm -f libcrypt-0.9.21.so; \
		rm -f libdl-0.9.21.so; \
		rm -f libm-0.9.21.so; \
		rm -f libnsl-0.9.21.so; \
		rm -f libpthread-0.9.21.so; \
		rm -f libresolv-0.9.21.so; \
		rm -f libuClibc-0.9.21.so; \
		rm -f libutil-0.9.21.so; \
		rm -f libthread_db-0.9.21.so; \
	)

ifeq ($(USE_UCLIBC_TOOLCHAIN),true)
ifeq ($(GCC_2_95_TOOLCHAIN),true)
uclibc_target: gcc2_95 uclibc $(TARGET_DIR)/usr/lib/libc.a
else
uclibc_target: gcc3_3 uclibc $(TARGET_DIR)/usr/lib/libc.a
endif
else
uclibc_target: uclibc $(TARGET_DIR)/usr/lib/libc.a
endif

uclibc_target-clean:
	rm -f $(TARGET_DIR)/include

uclibc_target-dirclean:
	rm -f $(TARGET_DIR)/include

