################################################################################
#
# xlib_libXtst -- X.Org Xtst library
#
################################################################################

XLIB_LIBXTST_VERSION = 1.0.1
XLIB_LIBXTST_SOURCE = libXtst-$(XLIB_LIBXTST_VERSION).tar.bz2
XLIB_LIBXTST_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXTST_AUTORECONF = YES
XLIB_LIBXTST_INSTALL_STAGING = YES
XLIB_LIBXTST_DEPENDENCIES = xlib_libX11 xlib_libXext xproto_recordproto
XLIB_LIBXTST_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXtst))
