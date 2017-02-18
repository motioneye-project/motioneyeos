################################################################################
#
# xapp_rstart
#
################################################################################

XAPP_RSTART_VERSION = 1.0.5
XAPP_RSTART_SOURCE = rstart-$(XAPP_RSTART_VERSION).tar.bz2
XAPP_RSTART_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_RSTART_LICENSE = MIT
XAPP_RSTART_LICENSE_FILES = COPYING
XAPP_RSTART_DEPENDENCIES = xlib_libX11

$(eval $(autotools-package))
