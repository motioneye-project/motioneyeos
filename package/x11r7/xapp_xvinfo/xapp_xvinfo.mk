################################################################################
#
# xapp_xvinfo
#
################################################################################

XAPP_XVINFO_VERSION = 1.1.1
XAPP_XVINFO_SOURCE = xvinfo-$(XAPP_XVINFO_VERSION).tar.bz2
XAPP_XVINFO_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XVINFO_LICENSE = MIT
XAPP_XVINFO_LICENSE_FILES = COPYING
XAPP_XVINFO_DEPENDENCIES = xlib_libX11 xlib_libXv

$(eval $(autotools-package))
