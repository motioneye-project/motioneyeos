################################################################################
#
# xapp_xfd -- X.Org xfd application
#
################################################################################

XAPP_XFD_VERSION = 1.0.1
XAPP_XFD_SOURCE = xfd-$(XAPP_XFD_VERSION).tar.bz2
XAPP_XFD_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XFD_AUTORECONF = NO
XAPP_XFD_DEPENDENCIES = freetype fontconfig xlib_libXaw xlib_libXft

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xfd))
