################################################################################
#
# xfont_font-bitstream-100dpi
#
################################################################################

XFONT_FONT_BITSTREAM_100DPI_VERSION = 1.0.3
XFONT_FONT_BITSTREAM_100DPI_SOURCE = font-bitstream-100dpi-$(XFONT_FONT_BITSTREAM_100DPI_VERSION).tar.bz2
XFONT_FONT_BITSTREAM_100DPI_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_BITSTREAM_100DPI_LICENSE = MIT
XFONT_FONT_BITSTREAM_100DPI_LICENSE_FILES = COPYING

XFONT_FONT_BITSTREAM_100DPI_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install
XFONT_FONT_BITSTREAM_100DPI_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install-data
XFONT_FONT_BITSTREAM_100DPI_DEPENDENCIES = xfont_font-util host-xfont_font-util host-xapp_mkfontscale host-xapp_mkfontdir host-xapp_bdftopcf

$(eval $(autotools-package))
