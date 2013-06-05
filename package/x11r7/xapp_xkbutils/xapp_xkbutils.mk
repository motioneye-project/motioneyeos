################################################################################
#
# xapp_xkbutils
#
################################################################################

XAPP_XKBUTILS_VERSION = 1.0.3
XAPP_XKBUTILS_SOURCE = xkbutils-$(XAPP_XKBUTILS_VERSION).tar.bz2
XAPP_XKBUTILS_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XKBUTILS_LICENSE = MIT
XAPP_XKBUTILS_LICENSE_FILES = COPYING
XAPP_XKBUTILS_DEPENDENCIES = xlib_libXaw xlib_libxkbfile

$(eval $(autotools-package))
