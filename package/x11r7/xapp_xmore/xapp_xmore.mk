################################################################################
#
# xapp_xmore
#
################################################################################

XAPP_XMORE_VERSION = 1.0.3
XAPP_XMORE_SOURCE = xmore-$(XAPP_XMORE_VERSION).tar.bz2
XAPP_XMORE_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XMORE_LICENSE = MIT
XAPP_XMORE_LICENSE_FILES = COPYING
XAPP_XMORE_DEPENDENCIES = xlib_libXaw

$(eval $(autotools-package))
