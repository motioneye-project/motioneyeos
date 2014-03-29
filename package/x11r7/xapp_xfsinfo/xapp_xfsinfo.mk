################################################################################
#
# xapp_xfsinfo
#
################################################################################

XAPP_XFSINFO_VERSION = 1.0.4
XAPP_XFSINFO_SOURCE = xfsinfo-$(XAPP_XFSINFO_VERSION).tar.bz2
XAPP_XFSINFO_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XFSINFO_LICENSE = MIT
XAPP_XFSINFO_LICENSE_FILES = COPYING
XAPP_XFSINFO_DEPENDENCIES = xlib_libFS xlib_libX11

$(eval $(autotools-package))
