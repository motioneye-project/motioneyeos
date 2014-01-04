################################################################################
#
# xlib_libSM
#
################################################################################

XLIB_LIBSM_VERSION = 1.2.2
XLIB_LIBSM_SOURCE = libSM-$(XLIB_LIBSM_VERSION).tar.bz2
XLIB_LIBSM_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBSM_LICENSE = MIT
XLIB_LIBSM_LICENSE_FILES = COPYING
XLIB_LIBSM_INSTALL_STAGING = YES
XLIB_LIBSM_DEPENDENCIES = xlib_libICE xlib_xtrans xproto_xproto
XLIB_LIBSM_CONF_OPT = --without-libuuid

$(eval $(autotools-package))
