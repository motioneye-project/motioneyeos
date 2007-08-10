################################################################################
#
# xlib_libSM -- X.Org SM library
#
################################################################################

XLIB_LIBSM_VERSION = 1.0.2
XLIB_LIBSM_SOURCE = libSM-$(XLIB_LIBSM_VERSION).tar.bz2
XLIB_LIBSM_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBSM_AUTORECONF = YES
XLIB_LIBSM_INSTALL_STAGING = YES
XLIB_LIBSM_DEPENDANCIES = xlib_libICE xlib_xtrans xproto_xproto
XLIB_LIBSM_CONF_OPT =  --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libSM))
