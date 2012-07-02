################################################################################
#
# xapp_xwininfo -- window information utility for X
#
################################################################################

XAPP_XWININFO_VERSION = 1.0.5
XAPP_XWININFO_SOURCE = xwininfo-$(XAPP_XWININFO_VERSION).tar.bz2
XAPP_XWININFO_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XWININFO_DEPENDENCIES = xlib_libX11 xlib_libXmu

$(eval $(autotools-package))
