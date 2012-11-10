#############################################################
#
# libnspr
#
#############################################################
LIBNSPR_VERSION = 4.8.7
LIBNSPR_SOURCE = nspr-$(LIBNSPR_VERSION).tar.gz
LIBNSPR_SITE = https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v$(LIBNSPR_VERSION)/src/
LIBNSPR_SUBDIR = mozilla/nsprpub
LIBNSPR_INSTALL_STAGING = YES
# Set the host CFLAGS and LDFLAGS so NSPR does not guess wrongly
LIBNSPR_CONF_ENV = HOST_CFLAGS="-g -O2" \
		   HOST_LDFLAGS="-lc"
# NSPR mixes up --build and --host
LIBNSPR_CONF_OPT  = --host=$(GNU_HOST_NAME)
LIBNSPR_CONF_OPT += --$(if $(BR2_ARCH_IS_64),en,dis)able-64bit
LIBNSPR_CONF_OPT += --$(if $(BR2_INET_IPV6),en,dis)able-ipv6

ifeq ($(BR2_cortex_a8)$(BR2_cortex_a9),y)
LIBNSPR_CONF_OPT += --enable-thumb2
else
LIBNSPR_CONF_OPT += --disable-thumb2
endif

define LIBNSPR_INSTALL_STAGING_PC
	$(INSTALL) -D -m 0644 $(TOPDIR)/package/libnspr/nspr.pc.in \
		$(STAGING_DIR)/usr/lib/pkgconfig/nspr.pc
	$(SED) 's/@VERSION@/$(LIBNSPR_VERSION)/g;' \
		$(STAGING_DIR)/usr/lib/pkgconfig/nspr.pc
endef
LIBNSPR_POST_INSTALL_STAGING_HOOKS += LIBNSPR_INSTALL_STAGING_PC

define LIBNSPR_INSTALL_TARGET_PC
	$(INSTALL) -D -m 0644 $(TOPDIR)/package/libnspr/nspr.pc.in \
		$(TARGET_DIR)/usr/lib/pkgconfig/nspr.pc
	$(SED) 's/@VERSION@/$(LIBNSPR_VERSION)/g;' \
		$(TARGET_DIR)/usr/lib/pkgconfig/nspr.pc
endef
LIBNSPR_POST_INSTALL_TARGET_HOOKS += LIBNSPR_INSTALL_TARGET_PC

$(eval $(autotools-package))
