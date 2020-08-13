################################################################################
#
# xfont_font-adobe-utopia-100dpi
#
################################################################################

XFONT_FONT_ADOBE_UTOPIA_100DPI_VERSION = 1.0.4
XFONT_FONT_ADOBE_UTOPIA_100DPI_SOURCE = font-adobe-utopia-100dpi-$(XFONT_FONT_ADOBE_UTOPIA_100DPI_VERSION).tar.bz2
XFONT_FONT_ADOBE_UTOPIA_100DPI_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_ADOBE_UTOPIA_100DPI_LICENSE = Adobe License (no modification allowed)
XFONT_FONT_ADOBE_UTOPIA_100DPI_LICENSE_FILES = COPYING

XFONT_FONT_ADOBE_UTOPIA_100DPI_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install
XFONT_FONT_ADOBE_UTOPIA_100DPI_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install-data
XFONT_FONT_ADOBE_UTOPIA_100DPI_DEPENDENCIES = \
	xfont_font-util \
	host-xfont_font-util \
	host-xapp_mkfontscale \
	host-xapp_bdftopcf \
	host-gzip

$(eval $(autotools-package))
