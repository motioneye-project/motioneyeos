################################################################################
#
# xapp_xwd
#
################################################################################

XAPP_XWD_VERSION = 1.0.7
XAPP_XWD_SOURCE = xwd-$(XAPP_XWD_VERSION).tar.bz2
XAPP_XWD_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XWD_LICENSE = MIT
XAPP_XWD_LICENSE_FILES = COPYING
XAPP_XWD_DEPENDENCIES = xlib_libX11 xlib_libXmu xlib_libxkbfile

$(eval $(autotools-package))
