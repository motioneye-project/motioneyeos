################################################################################
#
# xapp_xfontsel -- point and click selection of X11 font names
#
################################################################################

XAPP_XFONTSEL_VERSION = 1.0.1
XAPP_XFONTSEL_SOURCE = xfontsel-$(XAPP_XFONTSEL_VERSION).tar.bz2
XAPP_XFONTSEL_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XFONTSEL_AUTORECONF = NO
XAPP_XFONTSEL_DEPENDENCIES = xlib_libXaw

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xfontsel))
