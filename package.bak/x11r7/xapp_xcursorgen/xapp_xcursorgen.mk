################################################################################
#
# xapp_xcursorgen
#
################################################################################

XAPP_XCURSORGEN_VERSION = 1.0.6
XAPP_XCURSORGEN_SOURCE = xcursorgen-$(XAPP_XCURSORGEN_VERSION).tar.bz2
XAPP_XCURSORGEN_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XCURSORGEN_LICENSE = MIT
XAPP_XCURSORGEN_LICENSE_FILES = COPYING
XAPP_XCURSORGEN_DEPENDENCIES = libpng xlib_libX11 xlib_libXcursor
HOST_XAPP_XCURSORGEN_DEPENDENCIES = \
	host-libpng host-xlib_libX11 host-xlib_libXcursor

$(eval $(autotools-package))
$(eval $(host-autotools-package))
