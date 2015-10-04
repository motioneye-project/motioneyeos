################################################################################
#
# xfont_font-bh-type1
#
################################################################################

XFONT_FONT_BH_TYPE1_VERSION = 1.0.3
XFONT_FONT_BH_TYPE1_SOURCE = font-bh-type1-$(XFONT_FONT_BH_TYPE1_VERSION).tar.bz2
XFONT_FONT_BH_TYPE1_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_BH_TYPE1_LICENSE = Bigelow & Holmes License (no modification)
XFONT_FONT_BH_TYPE1_LICENSE_FILES = COPYING

XFONT_FONT_BH_TYPE1_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) MKFONTSCALE=$(HOST_DIR)/usr/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/usr/bin/mkfontdir install
XFONT_FONT_BH_TYPE1_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) MKFONTSCALE=$(HOST_DIR)/usr/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/usr/bin/mkfontdir install-data
XFONT_FONT_BH_TYPE1_DEPENDENCIES = xfont_font-util host-xfont_font-util host-xapp_mkfontscale host-xapp_mkfontdir host-xapp_bdftopcf

$(eval $(autotools-package))
