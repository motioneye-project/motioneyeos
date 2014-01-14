################################################################################
#
# libnss
#
################################################################################

LIBNSS_VERSION = 3.14.5
LIBNSS_SOURCE = nss-$(LIBNSS_VERSION).tar.gz
LIBNSS_SITE = https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_$(subst .,_,$(LIBNSS_VERSION))_RTM/src
LIBNSS_SUBDIR = mozilla/security
LIBNSS_DISTDIR = mozilla/dist
LIBNSS_INSTALL_STAGING = YES
LIBNSS_DEPENDENCIES = libnspr sqlite zlib
LIBNSS_LICENSE = MPLv2.0
LIBNSS_LICENSE_FILES = mozilla/security/nss/COPYING

LIBNSS_BUILD_VARS = MOZILLA_CLIENT=1 \
		NSPR_INCLUDE_DIR=$(STAGING_DIR)/usr/include/nspr \
		NSPR_LIB_DIR=$(STAGING_DIR)/usr/lib \
		BUILD_OPT=1 \
		NS_USE_GCC=1 \
		NSS_USE_SYSTEM_SQLITE=1 \
		NSS_ENABLE_ECC=1 \
		NATIVE_CC="$(HOSTCC)" \
		TARGETCC="$(TARGET_CC)" \
		TARGETCCC="$(TARGET_CXX)" \
		TARGETRANLIB="$(TARGET_RANLIB)" \
		OS_ARCH="Linux" \
		OS_RELEASE="2.6" \
		OS_TEST="$(ARCH)"

ifeq ($(BR2_ARCH_IS_64),y)
LIBNSS_BUILD_VARS += USE_64=1
endif


define LIBNSS_BUILD_CMDS
	$(MAKE1) -C $(@D)/$(LIBNSS_SUBDIR)/nss build_coreconf \
			SOURCE_MD_DIR=$(@D)/$(LIBNSS_DISTDIR) \
			DIST=$(@D)/$(LIBNSS_DISTDIR) \
			CHECKLOC= \
			$(LIBNSS_BUILD_VARS)
	$(MAKE1) -C $(@D)/$(LIBNSS_SUBDIR)/nss build_dbm all \
			SOURCE_MD_DIR=$(@D)/$(LIBNSS_DISTDIR) \
			DIST=$(@D)/$(LIBNSS_DISTDIR) \
			CHECKLOC= \
			$(LIBNSS_BUILD_VARS) OPTIMIZER="$(TARGET_CFLAGS)"
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

$(eval $(generic-package))
