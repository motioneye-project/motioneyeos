################################################################################
#
# xapp_xf86dga -- test program for the XFree86-DGA extension
#
################################################################################

XAPP_XF86DGA_VERSION = 1.0.2
XAPP_XF86DGA_SOURCE = xf86dga-$(XAPP_XF86DGA_VERSION).tar.bz2
XAPP_XF86DGA_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XF86DGA_DEPENDENCIES = \
	host-pkg-config \
	xlib_libX11 \
	xlib_libXxf86dga \
	xlib_libXt \
	xlib_libXaw \
	xlib_libXmu

$(eval $(autotools-package))
