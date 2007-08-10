################################################################################
#
# xapp_xsetmode -- set the mode for an X Input device
#
################################################################################

XAPP_XSETMODE_VERSION = 1.0.0
XAPP_XSETMODE_SOURCE = xsetmode-$(XAPP_XSETMODE_VERSION).tar.bz2
XAPP_XSETMODE_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XSETMODE_AUTORECONF = YES
XAPP_XSETMODE_DEPENDANCIES = xlib_libX11 xlib_libXi

$(eval $(call AUTOTARGETS,xapp_xsetmode))
