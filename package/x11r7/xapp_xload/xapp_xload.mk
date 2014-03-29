################################################################################
#
# xapp_xload
#
################################################################################

XAPP_XLOAD_VERSION = 1.1.2
XAPP_XLOAD_SOURCE = xload-$(XAPP_XLOAD_VERSION).tar.bz2
XAPP_XLOAD_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XLOAD_LICENSE = MIT
XAPP_XLOAD_LICENSE_FILES = COPYING
XAPP_XLOAD_DEPENDENCIES = xlib_libXaw

$(eval $(autotools-package))
