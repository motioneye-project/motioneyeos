################################################################################
#
# xfont_font-util
#
################################################################################

XFONT_FONT_UTIL_VERSION = 1.3.1
XFONT_FONT_UTIL_SOURCE = font-util-$(XFONT_FONT_UTIL_VERSION).tar.bz2
XFONT_FONT_UTIL_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_UTIL_LICENSE = MIT/BSD-2c
XFONT_FONT_UTIL_LICENSE_FILES = COPYING

XFONT_FONT_UTIL_DEPENDENCIES = host-pkgconf
XFONT_FONT_UTIL_INSTALL_STAGING = YES
XFONT_FONT_UTIL_INSTALL_TARGET = NO

$(eval $(autotools-package))
$(eval $(host-autotools-package))
