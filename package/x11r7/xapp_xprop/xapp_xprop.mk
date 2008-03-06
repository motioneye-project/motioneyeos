################################################################################
#
# xapp_xprop -- property displayer for X
#
################################################################################

XAPP_XPROP_VERSION = 1.0.3
XAPP_XPROP_SOURCE = xprop-$(XAPP_XPROP_VERSION).tar.bz2
XAPP_XPROP_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XPROP_AUTORECONF = NO
XAPP_XPROP_DEPENDENCIES = xlib_libX11 xlib_libXmu

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xprop))
