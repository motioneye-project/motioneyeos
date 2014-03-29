################################################################################
#
# xapp_xrdb
#
################################################################################

XAPP_XRDB_VERSION = 1.1.0
XAPP_XRDB_SOURCE = xrdb-$(XAPP_XRDB_VERSION).tar.bz2
XAPP_XRDB_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XRDB_LICENSE = MIT
XAPP_XRDB_LICENSE_FILES = COPYING
XAPP_XRDB_DEPENDENCIES = xlib_libX11 xlib_libXmu

$(eval $(autotools-package))
