################################################################################
#
# xapp_xdriinfo
#
################################################################################

XAPP_XDRIINFO_VERSION = 1.0.4
XAPP_XDRIINFO_SOURCE = xdriinfo-$(XAPP_XDRIINFO_VERSION).tar.bz2
XAPP_XDRIINFO_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XDRIINFO_LICENSE = MIT
XAPP_XDRIINFO_LICENSE_FILES = COPYING
XAPP_XDRIINFO_DEPENDENCIES = xlib_libX11 xproto_glproto mesa3d

$(eval $(autotools-package))
