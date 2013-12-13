################################################################################
#
# xapp_xconsole
#
################################################################################

XAPP_XCONSOLE_VERSION = 1.0.6
XAPP_XCONSOLE_SOURCE = xconsole-$(XAPP_XCONSOLE_VERSION).tar.bz2
XAPP_XCONSOLE_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XCONSOLE_LICENSE = MIT
XAPP_XCONSOLE_LICENSE_FILES = COPYING
XAPP_XCONSOLE_DEPENDENCIES = xlib_libX11 xlib_libXaw xlib_libXt xproto_xproto \
			     xlib_libXmu

$(eval $(autotools-package))
