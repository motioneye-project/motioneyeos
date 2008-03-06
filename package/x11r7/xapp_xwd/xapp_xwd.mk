################################################################################
#
# xapp_xwd -- dump an image of an X window
#
################################################################################

XAPP_XWD_VERSION = 1.0.1
XAPP_XWD_SOURCE = xwd-$(XAPP_XWD_VERSION).tar.bz2
XAPP_XWD_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XWD_AUTORECONF = NO
XAPP_XWD_DEPENDENCIES = xlib_libX11 xlib_libXmu

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xwd))
