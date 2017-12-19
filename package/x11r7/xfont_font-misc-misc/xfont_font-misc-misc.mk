################################################################################
#
# xfont_font-misc-misc
#
################################################################################

XFONT_FONT_MISC_MISC_VERSION = 1.1.2
XFONT_FONT_MISC_MISC_SOURCE = font-misc-misc-$(XFONT_FONT_MISC_MISC_VERSION).tar.bz2
XFONT_FONT_MISC_MISC_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_MISC_MISC_LICENSE = Public Domain
XFONT_FONT_MISC_MISC_LICENSE_FILES = COPYING

XFONT_FONT_MISC_MISC_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install
XFONT_FONT_MISC_MISC_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install-data
XFONT_FONT_MISC_MISC_DEPENDENCIES = xfont_font-util host-xfont_font-util host-xapp_mkfontscale host-xapp_mkfontdir host-xapp_bdftopcf

$(eval $(autotools-package))
