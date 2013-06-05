################################################################################
#
# xapp_xset
#
################################################################################

XAPP_XSET_VERSION = 1.2.2
XAPP_XSET_SOURCE = xset-$(XAPP_XSET_VERSION).tar.bz2
XAPP_XSET_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XSET_LICENSE = MIT
XAPP_XSET_LICENSE_FILES = COPYING
XAPP_XSET_DEPENDENCIES = xlib_libXmu

$(eval $(autotools-package))
