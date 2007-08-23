################################################################################
#
# xapp_lbxproxy -- Low BandWidth X proxy
#
################################################################################

XAPP_LBXPROXY_VERSION = 1.0.1
XAPP_LBXPROXY_SOURCE = lbxproxy-$(XAPP_LBXPROXY_VERSION).tar.bz2
XAPP_LBXPROXY_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_LBXPROXY_AUTORECONF = YES
XAPP_LBXPROXY_DEPENDENCIES = xlib_libICE xlib_libX11 xlib_libXext xlib_liblbxutil xlib_xtrans xproto_xproxymanagementprotocol

$(eval $(call AUTOTARGETS,xapp_lbxproxy))
