################################################################################
#
# xapp_iceauth -- ICE authority file utility
#
################################################################################

XAPP_ICEAUTH_VERSION = 1.0.3
XAPP_ICEAUTH_SOURCE = iceauth-$(XAPP_ICEAUTH_VERSION).tar.bz2
XAPP_ICEAUTH_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_ICEAUTH_DEPENDENCIES = xlib_libICE xlib_libX11

$(eval $(autotools-package))
