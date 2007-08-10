################################################################################
#
# xapp_xfontsel -- point and click selection of X11 font names
#
################################################################################

XAPP_XFONTSEL_VERSION = 1.0.1
XAPP_XFONTSEL_SOURCE = xfontsel-$(XAPP_XFONTSEL_VERSION).tar.bz2
XAPP_XFONTSEL_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XFONTSEL_AUTORECONF = YES
XAPP_XFONTSEL_DEPENDANCIES = xlib_libXaw

$(eval $(call AUTOTARGETS,xapp_xfontsel))
