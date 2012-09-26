#############################################################
#
# libdvdread
#
#############################################################

LIBDVDREAD_VERSION = 4.1.3
LIBDVDREAD_SOURCE = libdvdread-$(LIBDVDREAD_VERSION).tar.bz2
LIBDVDREAD_SITE = http://dvdnav.mplayerhq.hu/releases
LIBDVDREAD_AUTORECONF = YES
LIBDVDREAD_LIBTOOL_PATCH = YES
LIBDVDREAD_INSTALL_STAGING = YES

define LIBDVDREAD_TARGET_CLEANUP
	$(RM) -f $(TARGET_DIR)/usr/bin/dvdread-config
endef

ifneq ($(BR2_HAVE_DEVFILES),y)
LIBDVDREAD_POST_INSTALL_TARGET_HOOKS += LIBDVDREAD_TARGET_CLEANUP
endif

define LIBDVDREAD_STAGING_FIXUP_DVDREAD_CONFIG
	$(SED) "s,prefix=/usr,prefix=$(STAGING_DIR)/usr," $(STAGING_DIR)/usr/bin/dvdread-config
endef

LIBDVDREAD_POST_INSTALL_STAGING_HOOKS += LIBDVDREAD_STAGING_FIXUP_DVDREAD_CONFIG

$(eval $(autotools-package))
