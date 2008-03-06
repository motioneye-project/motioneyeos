################################################################################
#
# xapp_xlsatoms -- list interned atoms defined on server
#
################################################################################

XAPP_XLSATOMS_VERSION = 1.0.1
XAPP_XLSATOMS_SOURCE = xlsatoms-$(XAPP_XLSATOMS_VERSION).tar.bz2
XAPP_XLSATOMS_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XLSATOMS_AUTORECONF = NO
XAPP_XLSATOMS_DEPENDENCIES = xlib_libX11 xlib_libXmu

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xlsatoms))
