################################################################################
#
# xapp_xauth
#
################################################################################

XAPP_XAUTH_VERSION = 1.0.10
XAPP_XAUTH_SOURCE = xauth-$(XAPP_XAUTH_VERSION).tar.bz2
XAPP_XAUTH_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XAUTH_LICENSE = MIT
XAPP_XAUTH_LICENSE_FILES = COPYING
XAPP_XAUTH_DEPENDENCIES = xlib_libX11 xlib_libXau xlib_libXext xlib_libXmu

$(eval $(autotools-package))
