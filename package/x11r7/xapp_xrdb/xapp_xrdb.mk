################################################################################
#
# xapp_xrdb -- X server resource database utility
#
################################################################################

XAPP_XRDB_VERSION = 1.0.2
XAPP_XRDB_SOURCE = xrdb-$(XAPP_XRDB_VERSION).tar.bz2
XAPP_XRDB_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XRDB_AUTORECONF = YES
XAPP_XRDB_DEPENDENCIES = xlib_libX11 xlib_libXmu

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xrdb))
