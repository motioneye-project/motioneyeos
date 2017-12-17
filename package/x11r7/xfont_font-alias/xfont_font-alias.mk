################################################################################
#
# xfont_font-alias
#
################################################################################

XFONT_FONT_ALIAS_VERSION = 1.0.3
XFONT_FONT_ALIAS_SOURCE = font-alias-$(XFONT_FONT_ALIAS_VERSION).tar.bz2
XFONT_FONT_ALIAS_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_ALIAS_LICENSE = MIT
XFONT_FONT_ALIAS_LICENSE_FILES = COPYING

XFONT_FONT_ALIAS_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install
XFONT_FONT_ALIAS_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install-data
XFONT_FONT_ALIAS_DEPENDENCIES = xfont_font-util host-xfont_font-util host-xapp_mkfontscale host-xapp_mkfontdir host-xapp_bdftopcf

$(eval $(autotools-package))
