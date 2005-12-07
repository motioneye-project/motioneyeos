#############################################################
#
# uClibc (the C library)
#
#############################################################

ifndef UCLIBC_CONFIG_FILE
ifeq ($(BR2_ENABLE_LOCALE),y)
UCLIBC_CONFIG_FILE=toolchain/uClibc/uClibc.config-locale
else
UCLIBC_CONFIG_FILE=toolchain/uClibc/uClibc.config
endif
endif

ifeq ($(BR2_UCLIBC_VERSION_SNAPSHOT),y)
# Be aware that this changes daily....
UCLIBC_DIR:=$(TOOL_BUILD_DIR)/uClibc
UCLIBC_SOURCE:=uClibc-$(strip $(subst ",, $(BR2_USE_UCLIBC_SNAPSHOT))).tar.bz2
#"
UCLIBC_SITE:=http://www.uclibc.org/downloads/snapshots
else
UCLIBC_VER:=0.9.28
UCLIBC_DIR:=$(TOOL_BUILD_DIR)/uClibc-$(UCLIBC_VER)
UCLIBC_SOURCE:=uClibc-$(UCLIBC_VER).tar.bz2
UCLIBC_SITE:=http://www.uclibc.org/downloads
endif

UCLIBC_TARGET_ARCH:=$(shell echo $(ARCH) | sed -e s'/-.*//' \
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
)
# just handle the ones that can be big or little
UCLIBC_TARGET_ENDIAN:=$(shell echo $(ARCH) | sed \
		-e 's/armeb/BIG/' \
		-e 's/arm/LITTLE/' \
		-e 's/mipsel/LITTLE/' \
		-e 's/mips/BIG/' \
)
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
	mkdir -p $(DL_DIR)
	$(WGET) -P $(DL_DIR) $(UCLIBC_SITE)/$(UCLIBC_SOURCE)

uclibc-unpacked: $(UCLIBC_DIR)/.unpacked
$(UCLIBC_DIR)/.unpacked: $(DL_DIR)/$(UCLIBC_SOURCE)
	mkdir -p $(TOOL_BUILD_DIR)
	bzcat $(DL_DIR)/$(UCLIBC_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(UCLIBC_DIR) toolchain/uClibc/ \*.patch
	touch $(UCLIBC_DIR)/.unpacked

uclibc-configured: $(UCLIBC_DIR)/.configured
$(UCLIBC_DIR)/.configured: $(UCLIBC_DIR)/.unpacked
	cp $(UCLIBC_CONFIG_FILE) $(UCLIBC_DIR)/.config
	$(SED) 's,^CROSS_COMPILER_PREFIX=.*,CROSS_COMPILER_PREFIX="$(TARGET_CROSS)",g' \
		-e 's,# TARGET_$(UCLIBC_TARGET_ARCH) is not set,TARGET_$(UCLIBC_TARGET_ARCH)=y,g' \
		-e 's,^TARGET_ARCH="none",TARGET_ARCH=\"$(UCLIBC_TARGET_ARCH)\",g' \
		-e 's,^KERNEL_SOURCE=.*,KERNEL_SOURCE=\"$(LINUX_HEADERS_DIR)\",g' \
		-e 's,^RUNTIME_PREFIX=.*,RUNTIME_PREFIX=\"/\",g' \
		-e 's,^DEVEL_PREFIX=.*,DEVEL_PREFIX=\"/usr/\",g' \
		-e 's,^SHARED_LIB_LOADER_PREFIX=.*,SHARED_LIB_LOADER_PREFIX=\"/lib\",g' \
		$(UCLIBC_DIR)/.config
ifneq ($(UCLIBC_TARGET_ENDIAN),)
	$(SED) '/^# ARCH_$(UCLIBC_TARGET_ENDIAN)_ENDIAN /s,# ,,;s, is not set,=y,g' \
		-e '/^# ARCH_$(UCLIBC_NOT_TARGET_ENDIAN)_ENDIAN /s,# ,,;s, is not set,=n,' \
		$(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_LARGEFILE),y)
	$(SED) 's,^.*UCLIBC_HAS_LFS.*,UCLIBC_HAS_LFS=y,g' $(UCLIBC_DIR)/.config
else
	$(SED) 's,^.*UCLIBC_HAS_LFS.*,UCLIBC_HAS_LFS=n,g' $(UCLIBC_DIR)/.config
endif
	$(SED) 's,.*UCLIBC_HAS_WCHAR.*,UCLIBC_HAS_WCHAR=y,g' $(UCLIBC_DIR)/.config
ifeq ($(BR2_SOFT_FLOAT),y)
	$(SED) 's,.*HAS_FPU.*,HAS_FPU=n\nUCLIBC_HAS_FLOATS=y\nUCLIBC_HAS_SOFT_FLOAT=y,g' $(UCLIBC_DIR)/.config
endif
ifneq ($(BR2_PTHREADS_NONE),y)
	$(SED) 's,# UCLIBC_HAS_THREADS is not set,UCLIBC_HAS_THREADS=y,g' $(UCLIBC_DIR)/.config
	$(SED) 's,# PTHREADS_DEBUG_SUPPORT is not set,PTHREADS_DEBUG_SUPPORT=y,g' $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_PTHREADS),y)
	$(SED) 's,# LINUXTHREADS is not set,LINUXTHREADS=y,g' $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_PTHREADS_OLD),y)
	$(SED) 's,# LINUXTHREADS_OLD is not set,LINUXTHREADS_OLD=y,g' $(UCLIBC_DIR)/.config
endif
ifeq ($(BR2_PTHREADS_NATIVE),y)
	$(SED) 's,# UCLIBC_HAS_THREADS_NATIVE is not set,UCLIBC_HAS_THREADS_NATIVE=y,g' $(UCLIBC_DIR)/.config
endif
	mkdir -p $(TOOL_BUILD_DIR)/uClibc_dev/usr/include
	mkdir -p $(TOOL_BUILD_DIR)/uClibc_dev/usr/lib
	mkdir -p $(TOOL_BUILD_DIR)/uClibc_dev/lib
	$(MAKE1) -C $(UCLIBC_DIR) \
		PREFIX=$(TOOL_BUILD_DIR)/uClibc_dev/ \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=$(TOOL_BUILD_DIR)/uClibc_dev/ \
		HOSTCC="$(HOSTCC)" \
		pregen install_dev;
	touch $(UCLIBC_DIR)/.configured

$(UCLIBC_DIR)/lib/libc.a: $(UCLIBC_DIR)/.configured $(LIBFLOAT_TARGET)
	$(MAKE1) -C $(UCLIBC_DIR) \
		PREFIX= \
		DEVEL_PREFIX=/ \
		RUNTIME_PREFIX=/ \
		HOSTCC="$(HOSTCC)" \
		all
	touch -c $(UCLIBC_DIR)/lib/libc.a

$(STAGING_DIR)/lib/libc.a: $(UCLIBC_DIR)/lib/libc.a
	$(MAKE1) -C $(UCLIBC_DIR) \
		PREFIX= \
		DEVEL_PREFIX=$(STAGING_DIR)/ \
		RUNTIME_PREFIX=$(STAGING_DIR)/ \
		install_runtime install_dev
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

uclibc-configured: $(UCLIBC_DIR)/.configured

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
	touch -c $(TARGET_DIR)/usr/lib/libc.a

uclibc_target: gcc uclibc $(TARGET_DIR)/usr/lib/libc.a $(TARGET_DIR)/usr/bin/ldd

uclibc_target-clean:
	rm -f $(TARGET_DIR)/include

uclibc_target-dirclean:
	rm -f $(TARGET_DIR)/include

