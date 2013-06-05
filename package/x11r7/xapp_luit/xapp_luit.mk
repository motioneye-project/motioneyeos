################################################################################
#
# xapp_luit
#
################################################################################

XAPP_LUIT_VERSION = 1.1.1
XAPP_LUIT_SOURCE = luit-$(XAPP_LUIT_VERSION).tar.bz2
XAPP_LUIT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_LUIT_LICENSE = MIT
XAPP_LUIT_LICENSE_FILES = COPYING
XAPP_LUIT_DEPENDENCIES = xlib_libX11 xlib_libfontenc

$(eval $(autotools-package))
