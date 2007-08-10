################################################################################
#
# xapp_xfindproxy -- X.Org xfindproxy application
#
################################################################################

XAPP_XFINDPROXY_VERSION = 1.0.1
XAPP_XFINDPROXY_SOURCE = xfindproxy-$(XAPP_XFINDPROXY_VERSION).tar.bz2
XAPP_XFINDPROXY_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XFINDPROXY_AUTORECONF = YES
XAPP_XFINDPROXY_DEPENDANCIES = xlib_libICE xlib_libX11 xlib_libXt

$(eval $(call AUTOTARGETS,xapp_xfindproxy))
