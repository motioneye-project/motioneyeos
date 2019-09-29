################################################################################
#
# libnss
#
################################################################################

LIBNSS_VERSION = 3.39
LIBNSS_SOURCE = nss-$(LIBNSS_VERSION).tar.gz
LIBNSS_SITE = https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_$(subst .,_,$(LIBNSS_VERSION))_RTM/src
LIBNSS_DISTDIR = dist
LIBNSS_INSTALL_STAGING = YES
LIBNSS_DEPENDENCIES = libnspr sqlite zlib
LIBNSS_LICENSE = MPL-2.0
LIBNSS_LICENSE_FILES = nss/COPYING

# --gc-sections triggers binutils ld segfault
# https://sourceware.org/bugzilla/show_bug.cgi?id=21180
ifeq ($(BR2_microblaze),y)
define LIBNSS_DROP_GC_SECTIONS
	sed -i 's:-Wl,--gc-sections::g' $(@D)/nss/coreconf/Linux.mk
endef

LIBNSS_PRE_CONFIGURE_HOOKS += LIBNSS_DROP_GC_SECTIONS
endif

ifeq ($(BR2_aarch64_be),y)
LIBNSS_ARCH = aarch64
else
LIBNSS_ARCH = $(ARCH)
endif

LIBNSS_BUILD_VARS = \
	MOZILLA_CLIENT=1 \
	NSPR_INCLUDE_DIR=$(STAGING_DIR)/usr/include/nspr \
	NSPR_LIB_DIR=$(STAGING_DIR)/usr/lib \
	BUILD_OPT=1 \
	NS_USE_GCC=1 \
	NSS_DISABLE_GTESTS=1 \
	NSS_USE_SYSTEM_SQLITE=1 \
	NSS_ENABLE_ECC=1 \
	NATIVE_CC="$(HOSTCC)" \
	OS_ARCH="Linux" \
	OS_RELEASE="2.6" \
	OS_TEST="$(LIBNSS_ARCH)"

# #pragma usage needs gcc >= 4.8
# See https://bugzilla.mozilla.org/show_bug.cgi?id=1226179
ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_4_8),)
LIBNSS_BUILD_VARS += NSS_ENABLE_WERROR=0
endif

ifeq ($(BR2_ARCH_IS_64),y)
# MIPS64 n32 is treated as a 32-bit architecture by libnss.
# See: https://bugzilla.mozilla.org/show_bug.cgi?id=1010730
ifeq ($(BR2_MIPS_NABI32),)
LIBNSS_BUILD_VARS += USE_64=1
endif
endif

define LIBNSS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D)/nss coreconf \
		SOURCE_MD_DIR=$(@D)/$(LIBNSS_DISTDIR) \
		DIST=$(@D)/$(LIBNSS_DISTDIR) \
		CHECKLOC= \
		$(LIBNSS_BUILD_VARS)
	$(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D)/nss lib/dbm all \
		SOURCE_MD_DIR=$(@D)/$(LIBNSS_DISTDIR) \
		DIST=$(@D)/$(LIBNSS_DISTDIR) \
		CHECKLOC= \
		$(LIBNSS_BUILD_VARS) NATIVE_FLAGS="$(HOST_CFLAGS)"
endef

define LIBNSS_INSTALL_STAGING_CMDS
	$(INSTALL) -m 755 -t $(STAGING_DIR)/usr/lib/ \
		$(@D)/$(LIBNSS_DISTDIR)/lib/*.so
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/nss
	$(INSTALL) -m 644 -t $(STAGING_DIR)/usr/include/nss \
		$(@D)/$(LIBNSS_DISTDIR)/public/nss/*
	$(INSTALL) -m 755 -t $(STAGING_DIR)/usr/lib/ \
		$(@D)/$(LIBNSS_DISTDIR)/lib/*.a
	$(INSTALL) -D -m 0644 $(TOPDIR)/package/libnss/nss.pc.in \
		$(STAGING_DIR)/usr/lib/pkgconfig/nss.pc
	$(SED) 's/@VERSION@/$(LIBNSS_VERSION)/g;' \
		$(STAGING_DIR)/usr/lib/pkgconfig/nss.pc
endef

define LIBNSS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -t $(TARGET_DIR)/usr/lib/ \
		$(@D)/$(LIBNSS_DISTDIR)/lib/*.so
	$(INSTALL) -m 755 -d $(TARGET_DIR)/usr/include/nss
	$(INSTALL) -m 644 -t $(TARGET_DIR)/usr/include/nss \
		$(@D)/$(LIBNSS_DISTDIR)/public/nss/*
	$(INSTALL) -m 755 -t $(TARGET_DIR)/usr/lib/ \
		$(@D)/$(LIBNSS_DISTDIR)/lib/*.a
	$(INSTALL) -D -m 0644 $(TOPDIR)/package/libnss/nss.pc.in \
		$(TARGET_DIR)/usr/lib/pkgconfig/nss.pc
	$(SED) 's/@VERSION@/$(LIBNSS_VERSION)/g;' \
		$(TARGET_DIR)/usr/lib/pkgconfig/nss.pc
endef

HOST_LIBNSS_BUILD_VARS = \
	MOZILLA_CLIENT=1 \
	NSPR_INCLUDE_DIR=$(HOST_DIR)/include/nspr \
	NSPR_LIB_DIR=$(HOST_DIR)/lib \
	BUILD_OPT=1 \
	NS_USE_GCC=1 \
	NSS_DISABLE_GTESTS=1 \
	NSS_USE_SYSTEM_SQLITE=1 \
	SQLITE_INCLUDE_DIR=$(HOST_DIR)/include \
	ZLIB_INCLUDE_DIR=$(HOST_DIR)/include \
	NSS_ENABLE_ECC=1

HOST_LIBNSS_DEPENDENCIES = host-libnspr host-sqlite host-zlib

ifneq ($(filter %64,$(HOSTARCH)),)
HOST_LIBNSS_BUILD_VARS += USE_64=1
endif

define HOST_LIBNSS_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE1) -C $(@D)/nss coreconf \
		SOURCE_MD_DIR=$(@D)/$(LIBNSS_DISTDIR) \
		DIST=$(@D)/$(LIBNSS_DISTDIR) \
		CHECKLOC= \
		$(HOST_LIBNSS_BUILD_VARS)
	$(HOST_CONFIGURE_OPTS) $(MAKE1) -C $(@D)/nss lib/dbm all \
		SOURCE_MD_DIR=$(@D)/$(LIBNSS_DISTDIR) \
		DIST=$(@D)/$(LIBNSS_DISTDIR) \
		CHECKLOC= \
		$(HOST_LIBNSS_BUILD_VARS)
endef

define HOST_LIBNSS_INSTALL_CMDS
	$(INSTALL) -m 755 -t $(HOST_DIR)/lib/ \
		$(@D)/$(LIBNSS_DISTDIR)/lib/*.so
	$(INSTALL) -m 755 -d $(HOST_DIR)/include/nss
	$(INSTALL) -m 644 -t $(HOST_DIR)/include/nss \
		$(@D)/$(LIBNSS_DISTDIR)/public/nss/*
	$(INSTALL) -m 755 -t $(HOST_DIR)/lib/ \
		$(@D)/$(LIBNSS_DISTDIR)/lib/*.a
	$(INSTALL) -D -m 0644 $(TOPDIR)/package/libnss/nss.pc.in \
		$(HOST_DIR)/lib/pkgconfig/nss.pc
	$(SED) 's/@VERSION@/$(LIBNSS_VERSION)/g;' \
		$(HOST_DIR)/lib/pkgconfig/nss.pc
	$(SED) '/^prefix/s,=.*,=$(HOST_DIR),g;' \
		$(HOST_DIR)/lib/pkgconfig/nss.pc
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
