################################################################################
#
# xapp_xwud -- image displayer for X
#
################################################################################

XAPP_XWUD_VERSION = 1.0.1
XAPP_XWUD_SOURCE = xwud-$(XAPP_XWUD_VERSION).tar.bz2
XAPP_XWUD_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XWUD_AUTORECONF = NO
XAPP_XWUD_DEPENDENCIES = xlib_libX11

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xwud))
