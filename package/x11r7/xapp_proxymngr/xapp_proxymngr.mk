################################################################################
#
# xapp_proxymngr -- proxy manager service
#
################################################################################

XAPP_PROXYMNGR_VERSION = 1.0.1
XAPP_PROXYMNGR_SOURCE = proxymngr-$(XAPP_PROXYMNGR_VERSION).tar.bz2
XAPP_PROXYMNGR_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_PROXYMNGR_AUTORECONF = YES
XAPP_PROXYMNGR_DEPENDENCIES = xlib_libICE xlib_libX11 xlib_libXt xproto_xproxymanagementprotocol

$(eval $(call AUTOTARGETS,xapp_proxymngr))
