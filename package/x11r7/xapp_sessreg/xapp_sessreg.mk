################################################################################
#
# xapp_sessreg
#
################################################################################

XAPP_SESSREG_VERSION = 1.1.1
XAPP_SESSREG_SOURCE = sessreg-$(XAPP_SESSREG_VERSION).tar.bz2
XAPP_SESSREG_SITE = https://xorg.freedesktop.org/archive/individual/app
XAPP_SESSREG_LICENSE = MIT
XAPP_SESSREG_LICENSE_FILES = COPYING
XAPP_SESSREG_DEPENDENCIES = xlib_libX11 xorgproto

$(eval $(autotools-package))
