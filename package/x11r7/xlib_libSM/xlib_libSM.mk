################################################################################
#
# xlib_libSM -- X.Org SM library
#
################################################################################

XLIB_LIBSM_VERSION = 1.2.0
XLIB_LIBSM_SOURCE = libSM-$(XLIB_LIBSM_VERSION).tar.bz2
XLIB_LIBSM_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBSM_INSTALL_STAGING = YES
XLIB_LIBSM_DEPENDENCIES = xlib_libICE xlib_xtrans xproto_xproto
XLIB_LIBSM_CONF_OPT = --without-libuuid

ifneq ($(BR2_HAVE_DOCUMENTATION),y)
# documentation generation is slow
XLIB_LIBSM_CONF_OPT += --disable-docs
endif

$(eval $(autotools-package))
