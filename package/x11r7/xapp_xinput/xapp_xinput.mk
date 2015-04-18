################################################################################
#
# xapp_xinput
#
################################################################################

XAPP_XINPUT_VERSION = 1.6.1
XAPP_XINPUT_SOURCE = xinput-$(XAPP_XINPUT_VERSION).tar.bz2
XAPP_XINPUT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XINPUT_LICENSE = MIT
XAPP_XINPUT_LICENSE_FILES = COPYING
XAPP_XINPUT_DEPENDENCIES = xlib_libX11 xlib_libXi xlib_libXrandr xlib_libXinerama

$(eval $(autotools-package))
