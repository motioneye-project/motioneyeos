################################################################################
#
# xapp_xcmsdb
#
################################################################################

XAPP_XCMSDB_VERSION = 1.0.5
XAPP_XCMSDB_SOURCE = xcmsdb-$(XAPP_XCMSDB_VERSION).tar.bz2
XAPP_XCMSDB_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XCMSDB_LICENSE = MIT
XAPP_XCMSDB_LICENSE_FILES = COPYING
XAPP_XCMSDB_DEPENDENCIES = xlib_libX11

$(eval $(autotools-package))
