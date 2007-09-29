################################################################################
#
# xapp_xplsprinters -- shows a list of Xprint printers and it's attributes
#
################################################################################

XAPP_XPLSPRINTERS_VERSION = 1.0.1
XAPP_XPLSPRINTERS_SOURCE = xplsprinters-$(XAPP_XPLSPRINTERS_VERSION).tar.bz2
XAPP_XPLSPRINTERS_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XPLSPRINTERS_AUTORECONF = YES
XAPP_XPLSPRINTERS_DEPENDENCIES = xlib_libX11 xlib_libXp xlib_libXprintUtil

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xplsprinters))
