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
	perl -i -p -e 's,^CROSS=.*,TARGET_ARCH=$(ARCH)\nCROSS=$(TARGET_CROSS),g' \
		$(UCLIBC_DIR)/Rules.mak
ifeq ($(ENABLE_LOCALE),true)
	cp $(SOURCE_DIR)/uClibc.config-locale $(UCLIBC_DIR)/.config
else
	cp $(SOURCE_DIR)/uClibc.config $(UCLIBC_DIR)/.config
endif
	perl -i -p -e 's,^KERNEL_SOURCE=.*,KERNEL_SOURCE=\"$(LINUX_DIR)\",g' \
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
	perl -i -p -e 's,^GCC_BIN.*,GCC_BIN=$(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc,g' \
		$(UCLIBC_DIR)/extra/gcc-uClibc/Makefile
	perl -i -p -e 's,^LD_BIN.*,LD_BIN=$(STAGING_DIR)/bin/$(ARCH)-uclibc-ld,g' \
		$(UCLIBC_DIR)/extra/gcc-uClibc/Makefile
	$(MAKE) -C $(UCLIBC_DIR) oldconfig
	$(MAKE) -C $(UCLIBC_DIR) pregen
	$(MAKE) -C $(UCLIBC_DIR) headers
	$(MAKE) -C $(UCLIBC_DIR) install_dev;
	touch $(UCLIBC_DIR)/.configured

$(UCLIBC_DIR)/lib/libc.a: $(UCLIBC_DIR)/.configured
	$(MAKE) -C $(UCLIBC_DIR)

$(STAGING_DIR)/lib/libc.a: $(UCLIBC_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) install_dev install_runtime install_utils

ifneq ($(TARGET_DIR),)
$(TARGET_DIR)/lib/libc.so.0: $(STAGING_DIR)/lib/libc.a
	$(MAKE) -C $(UCLIBC_DIR) DEVEL_PREFIX=$(TARGET_DIR) \
		SYSTEM_DEVEL_PREFIX=$(TARGET_DIR) \
		DEVEL_TOOL_PREFIX=$(TARGET_DIR)/usr install_runtime

$(TARGET_DIR)/usr/bin/ldd: $(TARGET_DIR)/lib/libc.so.0
	$(MAKE) -C $(UCLIBC_DIR) PREFIX=$(TARGET_DIR) install_target_utils

UCLIBC_TARGETS=$(TARGET_DIR)/lib/libc.so.0 $(TARGET_DIR)/usr/bin/ldd
endif

uclibc-configured: $(UCLIBC_DIR)/.configured

uclibc: $(STAGING_DIR)/bin/$(ARCH)-uclibc-gcc $(STAGING_DIR)/lib/libc.a \
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
	$(MAKE) DEVEL_PREFIX=$(TARGET_DIR)/usr SYSTEM_DEVEL_PREFIX=$(TARGET_DIR) \
		DEVEL_TOOL_PREFIX=$(TARGET_DIR) -C $(UCLIBC_DIR) \
		install_dev
	#remove the extra copy of the shared libs
	rm -f $(TARGET_DIR)/usr/lib/*-*.so
	(cd $(TARGET_DIR)/usr/lib; \
		ln -fs /lib/libc.so.0 libc.so; \
		ln -fs /lib/libdl.so.0 libdl.so; \
		ln -fs /lib/libcrypt.so.0 libcrypt.so; \
		ln -fs /lib/libresolv.so.0 libresolv.so; \
		ln -fs /lib/libutil.so.0 libutil.so; \
		ln -fs /lib/libm.so.0 libm.so; \
		ln -fs /lib/libpthread.so.0 libpthread.so; \
		ln -fs /lib/libnsl.so.0 libnsl.so; \
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

