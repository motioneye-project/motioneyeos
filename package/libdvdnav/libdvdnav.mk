#############################################################
#
# libdvdnav
#
#############################################################

LIBDVDNAV_VERSION = 4.1.3
LIBDVDNAV_SOURCE = libdvdnav-$(LIBDVDNAV_VERSION).tar.bz2
LIBDVDNAV_SITE = http://dvdnav.mplayerhq.hu/releases
LIBDVDNAV_AUTORECONF = YES
LIBDVDNAV_INSTALL_STAGING = YES

LIBDVDNAV_DEPENDENCIES = libdvdread host-pkgconf

# By default libdvdnav tries to find dvdread-config in $PATH. Because
# of cross compilation, we prefer using pkg-config.
LIBDVDNAV_CONF_OPT = --with-dvdread-config="$(PKG_CONFIG_HOST_BINARY) dvdread"

define LIBDVDNAV_TARGET_CLEANUP
	$(RM) -f $(TARGET_DIR)/usr/bin/dvdnav-config
endef

ifneq ($(BR2_HAVE_DEVFILES),y)
LIBDVDNAV_POST_INSTALL_TARGET_HOOKS += LIBDVDNAV_TARGET_CLEANUP
endif

define LIBDVDNAV_STAGING_FIXUP_DVDNAV_CONFIG
	$(SED) "s,prefix=/usr,prefix=$(STAGING_DIR)/usr," $(STAGING_DIR)/usr/bin/dvdnav-config
endef

LIBDVDNAV_POST_INSTALL_STAGING_HOOKS += LIBDVDNAV_STAGING_FIXUP_DVDNAV_CONFIG

$(eval $(autotools-package))
