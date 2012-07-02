################################################################################
#
# xapp_xinput -- xinput
#
################################################################################

XAPP_XINPUT_VERSION = 1.5.4
XAPP_XINPUT_SOURCE = xinput-$(XAPP_XINPUT_VERSION).tar.bz2
XAPP_XINPUT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XINPUT_DEPENDENCIES = xlib_libX11 xlib_libXi

$(eval $(autotools-package))
