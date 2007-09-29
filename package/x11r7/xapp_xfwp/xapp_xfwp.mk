################################################################################
#
# xapp_xfwp -- X.Org xfwp application
#
################################################################################

XAPP_XFWP_VERSION = 1.0.1
XAPP_XFWP_SOURCE = xfwp-$(XAPP_XFWP_VERSION).tar.bz2
XAPP_XFWP_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XFWP_AUTORECONF = YES
XAPP_XFWP_DEPENDENCIES = xlib_libICE xlib_libX11 xproto_xproxymanagementprotocol

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xfwp))
