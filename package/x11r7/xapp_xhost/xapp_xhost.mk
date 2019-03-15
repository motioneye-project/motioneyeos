################################################################################
#
# xapp_xhost
#
################################################################################

XAPP_XHOST_VERSION = 1.0.8
XAPP_XHOST_SOURCE = xhost-$(XAPP_XHOST_VERSION).tar.bz2
XAPP_XHOST_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XHOST_LICENSE = MIT
XAPP_XHOST_LICENSE_FILES = COPYING
XAPP_XHOST_DEPENDENCIES = xlib_libX11 xlib_libXmu

$(eval $(autotools-package))
