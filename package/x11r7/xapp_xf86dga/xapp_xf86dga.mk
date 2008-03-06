################################################################################
#
# xapp_xf86dga -- test program for the XFree86-DGA extension
#
################################################################################

XAPP_XF86DGA_VERSION = 1.0.2
XAPP_XF86DGA_SOURCE = xf86dga-$(XAPP_XF86DGA_VERSION).tar.bz2
XAPP_XF86DGA_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XF86DGA_AUTORECONF = NO
XAPP_XF86DGA_DEPENDENCIES = xlib_libX11 xlib_libXxf86dga

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xf86dga))
