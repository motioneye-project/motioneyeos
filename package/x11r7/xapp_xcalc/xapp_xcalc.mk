################################################################################
#
# xapp_xcalc
#
################################################################################

XAPP_XCALC_VERSION = 1.0.7
XAPP_XCALC_SOURCE = xcalc-$(XAPP_XCALC_VERSION).tar.bz2
XAPP_XCALC_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XCALC_LICENSE = MIT
XAPP_XCALC_LICENSE_FILES = COPYING
XAPP_XCALC_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) install-exec install-data
XAPP_XCALC_DEPENDENCIES = xlib_libXaw
XAPP_XCALC_CONF_OPTS = --with-appdefaultdir=/usr/share/X11/app-defaults

$(eval $(autotools-package))
