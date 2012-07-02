################################################################################
#
# xapp_xev -- print contents of X events
#
################################################################################

XAPP_XEV_VERSION = 1.0.4
XAPP_XEV_SOURCE = xev-$(XAPP_XEV_VERSION).tar.bz2
XAPP_XEV_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XEV_DEPENDENCIES = xlib_libX11

$(eval $(autotools-package))
