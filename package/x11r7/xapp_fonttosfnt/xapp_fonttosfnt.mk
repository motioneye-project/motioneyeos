################################################################################
#
# xapp_fonttosfnt
#
################################################################################

XAPP_FONTTOSFNT_VERSION = 1.0.3
XAPP_FONTTOSFNT_SOURCE = fonttosfnt-$(XAPP_FONTTOSFNT_VERSION).tar.bz2
XAPP_FONTTOSFNT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_FONTTOSFNT_LICENSE = MIT
XAPP_FONTTOSFNT_LICENSE_FILES = COPYING
XAPP_FONTTOSFNT_DEPENDENCIES = freetype xlib_libX11 xlib_libfontenc

$(eval $(autotools-package))
