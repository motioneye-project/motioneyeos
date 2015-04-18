################################################################################
#
# xapp_xdbedizzy
#
################################################################################

XAPP_XDBEDIZZY_VERSION = 1.1.0
XAPP_XDBEDIZZY_SOURCE = xdbedizzy-$(XAPP_XDBEDIZZY_VERSION).tar.bz2
XAPP_XDBEDIZZY_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XDBEDIZZY_LICENSE = MIT
XAPP_XDBEDIZZY_LICENSE_FILES = COPYING
XAPP_XDBEDIZZY_DEPENDENCIES = xlib_libXext

$(eval $(autotools-package))
