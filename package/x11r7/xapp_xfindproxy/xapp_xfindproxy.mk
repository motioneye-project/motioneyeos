################################################################################
#
# xapp_xfindproxy
#
################################################################################

XAPP_XFINDPROXY_VERSION = 1.0.4
XAPP_XFINDPROXY_SOURCE = xfindproxy-$(XAPP_XFINDPROXY_VERSION).tar.bz2
XAPP_XFINDPROXY_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XFINDPROXY_LICENSE = MIT
XAPP_XFINDPROXY_LICENSE_FILES = COPYING
XAPP_XFINDPROXY_DEPENDENCIES = \
	xlib_libICE \
	xlib_libXt \
	xorgproto

$(eval $(autotools-package))
