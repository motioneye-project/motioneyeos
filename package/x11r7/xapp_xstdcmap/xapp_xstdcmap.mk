################################################################################
#
# xapp_xstdcmap -- X standard colormap utility
#
################################################################################

XAPP_XSTDCMAP_VERSION = 1.0.1
XAPP_XSTDCMAP_SOURCE = xstdcmap-$(XAPP_XSTDCMAP_VERSION).tar.bz2
XAPP_XSTDCMAP_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XSTDCMAP_DEPENDENCIES = xlib_libX11 xlib_libXmu

$(eval $(autotools-package))
