################################################################################
#
# xapp_xfsinfo -- X font server information utility
#
################################################################################

XAPP_XFSINFO_VERSION = 1.0.1
XAPP_XFSINFO_SOURCE = xfsinfo-$(XAPP_XFSINFO_VERSION).tar.bz2
XAPP_XFSINFO_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XFSINFO_AUTORECONF = YES
XAPP_XFSINFO_DEPENDENCIES = xlib_libFS xlib_libX11

$(eval $(call AUTOTARGETS,xapp_xfsinfo))
