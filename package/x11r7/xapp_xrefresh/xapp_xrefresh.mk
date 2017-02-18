################################################################################
#
# xapp_xrefresh
#
################################################################################

XAPP_XREFRESH_VERSION = 1.0.5
XAPP_XREFRESH_SOURCE = xrefresh-$(XAPP_XREFRESH_VERSION).tar.bz2
XAPP_XREFRESH_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XREFRESH_LICENSE = MIT
XAPP_XREFRESH_LICENSE_FILES = COPYING
XAPP_XREFRESH_DEPENDENCIES = xlib_libX11

$(eval $(autotools-package))
