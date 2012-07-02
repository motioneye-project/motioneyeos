################################################################################
#
# xapp_xsetroot -- X.Org xsetroot application
#
################################################################################

XAPP_XSETROOT_VERSION = 1.0.3
XAPP_XSETROOT_SOURCE = xsetroot-$(XAPP_XSETROOT_VERSION).tar.bz2
XAPP_XSETROOT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XSETROOT_DEPENDENCIES = xlib_libX11 xlib_libXmu xdata_xbitmaps

$(eval $(autotools-package))
