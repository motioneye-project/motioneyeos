################################################################################
#
# xapp_xrx -- X.Org xrx application
#
################################################################################

XAPP_XRX_VERSION = 1.0.1
XAPP_XRX_SOURCE = xrx-$(XAPP_XRX_VERSION).tar.bz2
XAPP_XRX_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XRX_AUTORECONF = YES
XAPP_XRX_DEPENDENCIES = xlib_libX11 xlib_libXext xlib_libXt

$(eval $(call AUTOTARGETS,xapp_xrx))
