################################################################################
#
# xfont_font-schumacher-misc
#
################################################################################

XFONT_FONT_SCHUMACHER_MISC_VERSION = 1.1.2
XFONT_FONT_SCHUMACHER_MISC_SOURCE = font-schumacher-misc-$(XFONT_FONT_SCHUMACHER_MISC_VERSION).tar.bz2
XFONT_FONT_SCHUMACHER_MISC_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_SCHUMACHER_MISC_LICENSE = MIT
XFONT_FONT_SCHUMACHER_MISC_LICENSE_FILES = COPYING

XFONT_FONT_SCHUMACHER_MISC_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) MKFONTSCALE=$(HOST_DIR)/usr/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/usr/bin/mkfontdir install
XFONT_FONT_SCHUMACHER_MISC_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) MKFONTSCALE=$(HOST_DIR)/usr/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/usr/bin/mkfontdir install-data
XFONT_FONT_SCHUMACHER_MISC_DEPENDENCIES = xfont_font-util host-xfont_font-util host-xapp_mkfontscale host-xapp_mkfontdir host-xapp_bdftopcf

$(eval $(autotools-package))
