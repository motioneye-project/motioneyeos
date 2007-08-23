################################################################################
#
# xapp_xsetpointer -- set an X Input device as the main pointer
#
################################################################################

XAPP_XSETPOINTER_VERSION = 1.0.0
XAPP_XSETPOINTER_SOURCE = xsetpointer-$(XAPP_XSETPOINTER_VERSION).tar.bz2
XAPP_XSETPOINTER_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XSETPOINTER_AUTORECONF = YES
XAPP_XSETPOINTER_DEPENDENCIES = xproto_inputproto xlib_libX11 xlib_libXi

$(eval $(call AUTOTARGETS,xapp_xsetpointer))
