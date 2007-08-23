################################################################################
#
# xapp_xcursorgen -- create an X cursor file from a collection of PNG images
#
################################################################################

XAPP_XCURSORGEN_VERSION = 1.0.1
XAPP_XCURSORGEN_SOURCE = xcursorgen-$(XAPP_XCURSORGEN_VERSION).tar.bz2
XAPP_XCURSORGEN_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XCURSORGEN_AUTORECONF = YES
XAPP_XCURSORGEN_DEPENDENCIES = libpng xlib_libX11 xlib_libXcursor

$(eval $(call AUTOTARGETS,xapp_xcursorgen))
