################################################################################
#
# xlib_xtrans -- X.Org xtrans library
#
################################################################################

XLIB_XTRANS_VERSION = 1.0.3
XLIB_XTRANS_SOURCE = xtrans-$(XLIB_XTRANS_VERSION).tar.bz2
XLIB_XTRANS_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_XTRANS_AUTORECONF = YES
XLIB_XTRANS_INSTALL_STAGING = YES
XLIB_XTRANS_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_xtrans))
