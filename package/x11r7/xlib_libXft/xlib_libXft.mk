################################################################################
#
# xlib_libXft -- X.Org Xft library
#
################################################################################

XLIB_LIBXFT_VERSION = 2.2.0
XLIB_LIBXFT_SOURCE = libXft-$(XLIB_LIBXFT_VERSION).tar.bz2
XLIB_LIBXFT_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXFT_AUTORECONF = YES
XLIB_LIBXFT_INSTALL_STAGING = YES
XLIB_LIBXFT_DEPENDENCIES = fontconfig freetype xlib_libX11 xlib_libXext xlib_libXrender xproto_xproto

define XLIB_LIBXFT_STAGING_XLIB_LIBXFT_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		$(STAGING_DIR)/usr/bin/xft-config
endef

XLIB_LIBXFT_POST_INSTALL_STAGING_HOOKS += XLIB_LIBXFT_STAGING_XLIB_LIBXFT_CONFIG_FIXUP

$(eval $(autotools-package))
