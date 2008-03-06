################################################################################
#
# xapp_xfindproxy -- X.Org xfindproxy application
#
################################################################################

XAPP_XFINDPROXY_VERSION = 1.0.1
XAPP_XFINDPROXY_SOURCE = xfindproxy-$(XAPP_XFINDPROXY_VERSION).tar.bz2
XAPP_XFINDPROXY_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XFINDPROXY_AUTORECONF = NO
XAPP_XFINDPROXY_DEPENDENCIES = xlib_libICE xlib_libX11 xlib_libXt xproto_xproxymanagementprotocol

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xfindproxy))
