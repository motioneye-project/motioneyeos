################################################################################
#
# xapp_xclock
#
################################################################################

XAPP_XCLOCK_VERSION = 1.0.9
XAPP_XCLOCK_SOURCE = xclock-$(XAPP_XCLOCK_VERSION).tar.bz2
XAPP_XCLOCK_SITE = https://xorg.freedesktop.org/archive/individual/app
XAPP_XCLOCK_LICENSE = MIT
XAPP_XCLOCK_LICENSE_FILES = COPYING
XAPP_XCLOCK_DEPENDENCIES = xlib_libX11 xlib_libXaw xlib_libXft xlib_libXrender xlib_libxkbfile
XAPP_XCLOCK_CONF_OPTS = --with-appdefaultdir=/usr/share/X11/app-defaults

$(eval $(autotools-package))
