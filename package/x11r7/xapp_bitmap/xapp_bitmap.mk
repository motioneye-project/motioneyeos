################################################################################
#
# xapp_bitmap
#
################################################################################

XAPP_BITMAP_VERSION = 1.0.7
XAPP_BITMAP_SOURCE = bitmap-$(XAPP_BITMAP_VERSION).tar.bz2
XAPP_BITMAP_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_BITMAP_LICENSE = MIT
XAPP_BITMAP_LICENSE_FILES = COPYING
XAPP_BITMAP_DEPENDENCIES = xlib_libX11 xlib_libXaw xlib_libXmu xdata_xbitmaps

$(eval $(autotools-package))
