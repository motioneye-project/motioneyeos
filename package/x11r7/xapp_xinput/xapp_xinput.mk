################################################################################
#
# xapp_xinput
#
################################################################################

XAPP_XINPUT_VERSION = 1.6.3
XAPP_XINPUT_SOURCE = xinput-$(XAPP_XINPUT_VERSION).tar.bz2
XAPP_XINPUT_SITE = https://xorg.freedesktop.org/archive/individual/app
XAPP_XINPUT_LICENSE = MIT
XAPP_XINPUT_LICENSE_FILES = COPYING
XAPP_XINPUT_DEPENDENCIES = xlib_libX11 xlib_libXi xlib_libXrandr xlib_libXinerama

$(eval $(autotools-package))
