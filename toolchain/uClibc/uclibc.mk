#############################################################
#
# uClibc (the C library)
#
#############################################################

ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)

ifeq ($(BR2_UCLIBC_VERSION_SNAPSHOT),y)
# Be aware that this changes daily....
UCLIBC_VER:=0.9.29
UCLIBC_DIR:=$(TOOL_BUILD_DIR)/uClibc
UCLIBC_SOURCE:=uClibc-$(strip $(subst ",, $(BR2_USE_UCLIBC_SNAPSHOT))).tar.bz2
#"))
UCLIBC_SITE:=http://www.uclibc.org/downloads/snapshots
ifndef UCLIBC_CONFIG_FILE
UCLIBC_CONFIG_FILE=toolchain/uClibc/uClibc-0.9.29.config
endif
else
ifeq ($(BR2_UCLIBC_VERSION_0_9_28_1),y)
UCLIBC_VER:=0.9.28.1
endif
ifeq ($(BR2_UCLIBC_VERSION_0_9_28),y)
UCLIBC_VER:=0.9.28
endif
UCLIBC_DIR:=$(TOOL_BUILD_DIR)/uClibc-$(UCLIBC_VER)
UCLIBC_SOURCE:=uClibc-$(UCLIBC_VER).tar.bz2
UCLIBC_SITE:=http://www.uclibc.org/downloads
ifndef UCLIBC_CONFIG_FILE
UCLIBC_CONFIG_FILE=toolchain/uClibc/uClibc-0.9.28.config
endif
endif

UCLIBC_CAT:=$(BZCAT)

UCLIBC_TARGET_ARCH:=$(shell $(SHELL) -c "echo $(ARCH) | sed -e s'/-.*//' \
		-e 's/i.86/i386/' \
		-e 's/sparc.*/sparc/' \
		-e 's/arm.*/arm/g' \
		-e 's/m68k.*/m68k/' \
		-e 's/ppc/powerpc/g' \
		-e 's/v850.*/v850/g' \
		-e 's/sh[234].*/sh/' \
		-e 's/mips.*/mips/' \
		-e 's/mipsel.*/mips/' \
		-e 's/cris.*/cris/' \
		-e 's/nios2.*/nios2/' \
")
# just handle the ones that can be big or little
UCLIBC_TARGET_ENDIAN:=$(shell $(SHELL) -c "echo $(ARCH) | sed \
		-e 's/armeb/BIG/' \
		-e 's/arm/LITTLE/' \
		-e 's/mipsel/LITTLE/' \
		-e 's/mips/BIG/' \
")
ifneq ($(UCLIBC_TARGET_ENDIAN),LITTLE)
ifneq ($(UCLIBC_TARGET_ENDIAN),BIG)
UCLIBC_TARGET_ENDIAN:=
endif
endif
ifeq ($(UCLIBC_TARGET_ENDIAN),LITTLE)
UCLIBC_NOT_TARGET_ENDIAN:=BIG
else
UCLIBC_NOT_TARGET_ENDIAN:=LITTLE
endif

$(DL_DIR)/$(UCLIBC_SOURCE):
	$(WGET) -P $(DL_DIR) $(UCLIBC_SITE)/$(UCLIBC_SOURCE)

ifneq ($(BR2_ENABLE_LOCALE),)
UCLIBC_SITE_LOCALE:=http://www.uclibc.org/downloads
UCLIBC_SOURCE_LOCALE:=uClibc-locale-030818.tgz

$(DL_DIR)/$(UCLIBC_SOURCE_LOCALE):
	$(WGET) -P $(DL_DIR) $(UCLIBC_SITE_LOCALE)/$(UCLIBC_SOURCE_LOCALE)

UCLIBC_LOCALE_DATA:=$(DL_DIR)/$(UCLIBC_SOURCE_LOCALE)
else
UCLIBC_LOCALE_DATA=
endif

uclibc-unpacked: $(UCLIBC_DIR)/.unpacked
$(UCLIBC_DIR)/.unpacked: $(DL_DIR)/$(UCLIBC_SOURCE) $(UCLIBC_LOCALE_DATA)
	[ -d $(TOOL_BUILD_DIR) ] || $(INSTALL) -d $(TOOL_BUILD_DIR)
	$(UCLIBC_CAT) $(DL_DIR)/$(UCLIBC_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(UCLIBC_DIR) toolchain/uClibc/ uClibc-$(UCLIBC_VER)-\*.patch
ifneq ($(BR2_ENABLE_LOCALE),)
	cp -dpf $(DL_DIR)/$(UCLIBC_SOURCE_LOCALE) $(UCLIBC_DIR)/extra/locale/
endif
	touch $(UCLIBC_DIR)/.unpacked

# Some targets may wish to provide their own UCLIBC_CONFIG_FILE...
$(UCLIBC_DIR)/.config: $(UCLIBC_DIR)/.unpacked $(UCLIBC_CONFIG_FILE)
	cp -f $(UCLIBC_CONFIG_FILE) $(UCLIBC_DIR)/.config
	$(SED) 's,^CROSS_COMPILER_PREFIX=.*,CROSS_COMPILER_PREFIX="$(TARGET_CROSS)",g' \
		-e 's,# TARGET_$(UCLIBC_TARGET_ARCH) is not set,TARGET_$(UCLIBC_TARGET_ARCH)=y,g' \
		-e 's,^TARGET_ARCH="none",TARGET_ARCH=\"$(UCLIBC_TARGET_ARCH)\",g' \
		-e 's,^KERNEL_SOURCE=.*,KERNEL_SOURCE=\"$(LINUX_HEADERS_DIR)\",g' \
		-e 's,^KERNEL_HEADERS=.*,KERNEL_HEADERS=\"$(LINUX_HEADERS_DIR)/include\",g' \
		-e 's,^RUNTIME_PREFIX=.*,RUNTIME_PREFIX=\"/\",g' \
		-e 's,^DEVEL_PREFIX=.*,DEVEL_PREFIX=\"/usr/\",g' \
		-e 's,^SHARED_LIB_LOADER_PREFIX=.*,SHARED_LIB_LOADER_PREFIX=\"/lib\",g' \
		$(UCLIBC_DIR)/.config
ifeq ($(UCLIBC_TARGET_ARCH),arm)
	$(SED) 's/^\(CONFIG_[^_]*[_]*ARM[^=]*\)=.*/# \1 is not set/g' \
		 $(UCLIBC_DIR)/.config
	/bin/echo "CONFIG_$(BR2_ARM_TYPE)=y" >> \
		$(UCLIBC_DIR)/.config
ifeq ($(BR2_ARM_EABI),y)
	/bin/echo "# CONFIG_ARM_OABI is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "CONFIG_ARM_EABI=y" >> $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_ARM_OABI),y)
	/bin/echo "CONFIG_ARM_OABI=y" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_ARM_EABI is not set" >> $(UCLIBC_DIR)/.config
endif
endif
ifneq ($(UCLIBC_TARGET_ENDIAN),)
	$(SED) '/^# ARCH_$(UCLIBC_TARGET_ENDIAN)_ENDIAN /{s,# ,,;s, is not set,=y,g}' \
		-e '/^# ARCH_$(UCLIBC_NOT_TARGET_ENDIAN)_ENDIAN /{s,# ,,;s, is not set,=n,g}' \
		$(UCLIBC_DIR)/.config

	$(SED) '/^# ARCH_WANTS_$(UCLIBC_TARGET_ENDIAN)_ENDIAN /{s,# ,,;s, is not set,=y,g}' \
		-e '/^# ARCH_WANTS_$(UCLIBC_NOT_TARGET_ENDIAN)_ENDIAN /{s,# ,,;s, is not set,=n,g}' \
		$(UCLIBC_DIR)/.config
endif
ifneq ($(UCLIBC_TARGET_ENDIAN),)
	# The above doesn't work for me, so redo
	$(SED) 's/.*\(ARCH_$(UCLIBC_NOT_TARGET_ENDIAN)_ENDIAN\).*/# \1 is not set/g' \
		-e 's/.*\(ARCH_WANTS_$(UCLIBC_NOT_TARGET_ENDIAN)_ENDIAN\).*/# \1 is not set/g' \
		-e 's/.*\(ARCH_$(UCLIBC_TARGET_ENDIAN)_ENDIAN\).*/\1=y/g' \
		-e 's/.*\(ARCH_WANTS_$(UCLIBC_TARGET_ENDIAN)_ENDIAN\).*/\1=y/g' \
		$(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_LARGEFILE),y)
	$(SED) 's,.*UCLIBC_HAS_LFS.*,UCLIBC_HAS_LFS=y,g' $(UCLIBC_DIR)/.config
else
	$(SED) 's,.*UCLIBC_HAS_LFS.*,UCLIBC_HAS_LFS=n,g' $(UCLIBC_DIR)/.config
	$(SED) '/.*UCLIBC_HAS_FOPEN_LARGEFILE_MODE.*/d' $(UCLIBC_DIR)/.config
	echo "# UCLIBC_HAS_FOPEN_LARGEFILE_MODE is not set" >> $(UCLIBC_DIR)/.config
endif
	$(SED) 's,.*UCLIBC_HAS_WCHAR.*,UCLIBC_HAS_WCHAR=y,g' $(UCLIBC_DIR)/.config
ifeq ($(BR2_SOFT_FLOAT),y)
	$(SED) 's,.*UCLIBC_HAS_FPU.*,UCLIBC_HAS_FPU=n,g' \
		-e 's,.*[^_]HAS_FPU.*,HAS_FPU=n,g' \
		-e 's,.*UCLIBC_HAS_FLOATS.*,UCLIBC_HAS_FLOATS=y,g' \
		-e 's,.*DO_C99_MATH.*,DO_C99_MATH=y,g' \
		$(UCLIBC_DIR)/.config
	#$(SED) 's,.*UCLIBC_HAS_FPU.*,UCLIBC_HAS_FPU=n\nHAS_FPU=n\nUCLIBC_HAS_FLOATS=y\nUCLIBC_HAS_SOFT_FLOAT=y,g' $(UCLIBC_DIR)/.config
else
	$(SED) 's,.*UCLIBC_HAS_FPU.*,UCLIBC_HAS_FPU=y\nHAS_FPU=y\nUCLIBC_HAS_FLOATS=y\n,g' $(UCLIBC_DIR)/.config
endif
	$(SED) '/UCLIBC_HAS_THREADS/d' $(UCLIBC_DIR)/.config
	$(SED) '/LINUXTHREADS/d' $(UCLIBC_DIR)/.config
	$(SED) '/LINUXTHREADS_OLD/d' $(UCLIBC_DIR)/.config
	$(SED) '/PTHREADS_DEBUG_SUPPORT/d' $(UCLIBC_DIR)/.config
	$(SED) '/UCLIBC_HAS_THREADS_NATIVE/d' $(UCLIBC_DIR)/.config
ifeq ($(BR2_PTHREADS_NONE),y)
	echo "# UCLIBC_HAS_THREADS is not set" >> $(UCLIBC_DIR)/.config
else
	echo "UCLIBC_HAS_THREADS=y" >> $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_PTHREADS),y)
	echo "LINUXTHREADS=y" >> $(UCLIBC_DIR)/.config
else
	echo "# LINUXTHREADS is not set" >> $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_PTHREADS_OLD),y)
	echo "LINUXTHREADS_OLD=y" >> $(UCLIBC_DIR)/.config
else
	echo "# LINUXTHREADS_OLD is not set" >> $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_PTHREADS_NATIVE),y)
	echo "UCLIBC_HAS_THREADS_NATIVE=y" >> $(UCLIBC_DIR)/.config
else
	echo "# UCLIBC_HAS_THREADS_NATIVE is not set" >> $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_PTHREAD_DEBUG),y)
	echo "PTHREADS_DEBUG_SUPPORT=y" >> $(UCLIBC_DIR)/.config
else
	echo "# PTHREADS_DEBUG_SUPPORT is not set" >> $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_ENABLE_LOCALE),y)
	$(SED) 's,^.*UCLIBC_HAS_LOCALE.*,UCLIBC_HAS_LOCALE=y\nUCLIBC_PREGENERATED_LOCALE_DATA=y\nUCLIBC_DOWNLOAD_PREGENERATED_LOCALE_DATA=y\nUCLIBC_HAS_XLOCALE=y\nUCLIBC_HAS_GLIBC_DIGIT_GROUPING=n\n,g' $(UCLIBC_DIR)/.config
else
	$(SED) 's,^.*UCLIBC_HAS_LOCALE.*,UCLIBC_HAS_LOCALE=n,g' $(UCLIBC_DIR)/.config
endif
ifeq ("$(KERNEL_ARCH)","i386")
	/bin/echo "# CONFIG_GENERIC_386 is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_386 is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_486 is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_586 is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_586MMX is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_686 is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_PENTIUMII is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_PENTIUMIII is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_PENTIUM4 is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_K6 is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_K7 is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_ELAN is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_CRUSOE is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_WINCHIPC6 is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_WINCHIP2 is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_CYRIXIII is not set" >> $(UCLIBC_DIR)/.config
	/bin/echo "# CONFIG_NEHEMIAH is not set" >> $(UCLIBC_DIR)/.config
ifeq ($(BR2_x86_i386),y)
	$(SED) 's,# CONFIG_386 is not set,CONFIG_386=y,g' $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_x86_i486),y)
	$(SED) 's,# CONFIG_486 is not set,CONFIG_486=y,g' $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_x86_i586),y)
	$(SED) 's,# CONFIG_586 is not set,CONFIG_586=y,g' $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_x86_i686),y)
	$(SED) 's,# CONFIG_686 is not set,CONFIG_686=y,g' $(UCLIBC_DIR)/.config
endif
endif
	mkdir -p $(TOOL_BUILD_DIR)/uClibc_dev/usr/include
	mkdir -p $(TOOL_BUILD_DIR)/uClibc_dev/usr/lib
	mkdir -p $(TOOL_BUILD_DIR)/uClibc_dev/lib
	$(MAKE1) -C $(UCLIBC_DIR) \
		PREFIX=$(TOOL_BUILD_DIR)/uClibc_dev/ \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=$(TOOL_BUILD_DIR)/uClibc_dev/ \
		HOSTCC="$(HOSTCC)" \
		oldconfig
	touch $(UCLIBC_DIR)/.config

$(UCLIBC_DIR)/.configured: $(UCLIBC_DIR)/.config
	set -x && $(MAKE1) -C $(UCLIBC_DIR) \
		PREFIX=$(TOOL_BUILD_DIR)/uClibc_dev/ \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=$(TOOL_BUILD_DIR)/uClibc_dev/ \
		HOSTCC="$(HOSTCC)" \
		pregen install_dev
	# Install the kernel headers to the first stage gcc include dir if necessary
	if [ ! -f $(STAGING_DIR)/include/linux/version.h ] ; then \
		cp -pLR $(LINUX_HEADERS_DIR)/include/asm $(TOOL_BUILD_DIR)/uClibc_dev/usr/include/ ; \
		cp -pLR $(LINUX_HEADERS_DIR)/include/linux $(TOOL_BUILD_DIR)/uClibc_dev/usr/include/ ; \
		if [ -d $(LINUX_HEADERS_DIR)/include/asm-generic ] ; then \
			cp -pLR $(LINUX_HEADERS_DIR)/include/asm-generic \
				$(TOOL_BUILD_DIR)/uClibc_dev/usr/include/ ; \
		fi; \
	fi;
	touch $(UCLIBC_DIR)/.configured

$(UCLIBC_DIR)/lib/libc.a: $(UCLIBC_DIR)/.configured $(LIBFLOAT_TARGET)
	$(MAKE1) -C $(UCLIBC_DIR) \
		PREFIX= \
		DEVEL_PREFIX=/ \
		RUNTIME_PREFIX=/ \
		HOSTCC="$(HOSTCC)" \
		all
	touch -c $(UCLIBC_DIR)/lib/libc.a

uclibc-menuconfig: $(UCLIBC_DIR)/.config host-sed
	$(MAKE1) -C $(UCLIBC_DIR) \
		PREFIX=$(TOOL_BUILD_DIR)/uClibc_dev/ \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=$(TOOL_BUILD_DIR)/uClibc_dev/ \
		HOSTCC="$(HOSTCC)" \
		menuconfig && \
	cp -f $(UCLIBC_DIR)/.config $(UCLIBC_CONFIG_FILE) && \
	touch $(UCLIBC_DIR)/.configured


$(STAGING_DIR)/lib/libc.a: $(UCLIBC_DIR)/lib/libc.a
	$(MAKE1) -C $(UCLIBC_DIR) \
		PREFIX= \
		DEVEL_PREFIX=$(STAGING_DIR)/ \
		RUNTIME_PREFIX=$(STAGING_DIR)/ \
		install_runtime install_dev
	# Install the kernel headers to the staging dir if necessary
	if [ ! -f $(STAGING_DIR)/include/linux/version.h ] ; then \
		cp -pLR $(LINUX_HEADERS_DIR)/include/asm $(STAGING_DIR)/include/ ; \
		cp -pLR $(LINUX_HEADERS_DIR)/include/linux $(STAGING_DIR)/include/ ; \
		if [ -d $(LINUX_HEADERS_DIR)/include/asm-generic ] ; then \
			cp -pLR $(LINUX_HEADERS_DIR)/include/asm-generic \
				$(STAGING_DIR)/include/ ; \
		fi; \
	fi;
	# Build the host utils.  Need to add an install target...
	$(MAKE1) -C $(UCLIBC_DIR)/utils \
		PREFIX=$(STAGING_DIR) \
		HOSTCC="$(HOSTCC)" \
		hostutils
	touch -c $(STAGING_DIR)/lib/libc.a

ifneq ($(TARGET_DIR),)
$(TARGET_DIR)/lib/libc.so.0: $(STAGING_DIR)/lib/libc.a
	$(MAKE1) -C $(UCLIBC_DIR) \
		PREFIX=$(TARGET_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=/ \
		install_runtime
	touch -c $(TARGET_DIR)/lib/libc.so.0

$(TARGET_DIR)/usr/bin/ldd:
	$(MAKE1) -C $(UCLIBC_DIR) $(TARGET_CONFIGURE_OPTS) \
		PREFIX=$(TARGET_DIR) utils install_utils
ifeq ($(strip $(BR2_CROSS_TOOLCHAIN_TARGET_UTILS)),y)
	mkdir -p $(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/target_utils
	install -c $(TARGET_DIR)/usr/bin/ldd \
		$(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/target_utils/ldd
endif
	touch -c $(TARGET_DIR)/usr/bin/ldd

UCLIBC_TARGETS=$(TARGET_DIR)/lib/libc.so.0
endif

uclibc-configured: dependencies kernel-headers $(UCLIBC_DIR)/.configured


uclibc: $(STAGING_DIR)/bin/$(REAL_GNU_TARGET_NAME)-gcc $(STAGING_DIR)/lib/libc.a \
	$(UCLIBC_TARGETS)

uclibc-source: $(DL_DIR)/$(UCLIBC_SOURCE)

uclibc-configured-source: uclibc-source

uclibc-clean:
	-$(MAKE1) -C $(UCLIBC_DIR) clean
	rm -f $(UCLIBC_DIR)/.config

uclibc-dirclean:
	rm -rf $(UCLIBC_DIR)

uclibc-target-utils: $(TARGET_DIR)/usr/bin/ldd

#############################################################
#
# uClibc for the target just needs its header files
# and whatnot installed.
#
#############################################################

$(TARGET_DIR)/usr/lib/libc.a: $(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/lib/libc.a
	$(MAKE1) -C $(UCLIBC_DIR) \
		PREFIX=$(TARGET_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=/ \
		install_dev
	# Install the kernel headers to the target dir if necessary
	if [ ! -f $(TARGET_DIR)/usr/include/linux/version.h ] ; then \
		cp -pLR $(LINUX_HEADERS_DIR)/include/asm $(TARGET_DIR)/usr/include/ ; \
		cp -pLR $(LINUX_HEADERS_DIR)/include/linux $(TARGET_DIR)/usr/include/ ; \
		if [ -d $(LINUX_HEADERS_DIR)/include/asm-generic ] ; then \
			cp -pLR $(LINUX_HEADERS_DIR)/include/asm-generic \
				$(TARGET_DIR)/usr/include/ ; \
		fi; \
	fi;
	touch -c $(TARGET_DIR)/usr/lib/libc.a

uclibc_target: gcc uclibc $(TARGET_DIR)/usr/lib/libc.a $(TARGET_DIR)/usr/bin/ldd

uclibc_target-clean:
	rm -rf $(TARGET_DIR)/usr/include \
		$(TARGET_DIR)/usr/lib/libc.a $(TARGET_DIR)/usr/bin/ldd

uclibc_target-dirclean:
	rm -rf $(TARGET_DIR)/usr/include

endif
