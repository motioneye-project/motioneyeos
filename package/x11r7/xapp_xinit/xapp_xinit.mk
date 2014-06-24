################################################################################
#
# xapp_xinit
#
################################################################################

XAPP_XINIT_VERSION = 1.3.3
XAPP_XINIT_SOURCE = xinit-$(XAPP_XINIT_VERSION).tar.bz2
XAPP_XINIT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XINIT_DEPENDENCIES = xapp_xauth xlib_libX11
XAPP_XINIT_LICENSE = MIT
XAPP_XINIT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
