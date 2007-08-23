################################################################################
#
# xapp_ico -- animate an icosahedron or other polyhedron
#
################################################################################

XAPP_ICO_VERSION = 1.0.1
XAPP_ICO_SOURCE = ico-$(XAPP_ICO_VERSION).tar.bz2
XAPP_ICO_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_ICO_AUTORECONF = YES
XAPP_ICO_DEPENDENCIES = xlib_libX11

$(eval $(call AUTOTARGETS,xapp_ico))
