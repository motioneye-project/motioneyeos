################################################################################
#
# xapp_x11perf
#
################################################################################

XAPP_X11PERF_VERSION = 1.6.0
XAPP_X11PERF_SOURCE = x11perf-$(XAPP_X11PERF_VERSION).tar.bz2
XAPP_X11PERF_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_X11PERF_LICENSE = MIT
XAPP_X11PERF_LICENSE_FILES = COPYING
XAPP_X11PERF_DEPENDENCIES = xlib_libX11 xlib_libXmu xlib_libXft

$(eval $(autotools-package))
