################################################################################
#
# xapp_xpr
#
################################################################################

XAPP_XPR_VERSION = 1.0.5
XAPP_XPR_SOURCE = xpr-$(XAPP_XPR_VERSION).tar.bz2
XAPP_XPR_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XPR_LICENSE = MIT
XAPP_XPR_LICENSE_FILES = COPYING
XAPP_XPR_DEPENDENCIES = xlib_libX11 xlib_libXmu

$(eval $(autotools-package))
