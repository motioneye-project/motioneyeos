################################################################################
#
# xlib_liblbxutil -- X.Org lbxutil library
#
################################################################################

XLIB_LIBLBXUTIL_VERSION = 1.0.1
XLIB_LIBLBXUTIL_SOURCE = liblbxutil-$(XLIB_LIBLBXUTIL_VERSION).tar.bz2
XLIB_LIBLBXUTIL_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBLBXUTIL_AUTORECONF = YES
XLIB_LIBLBXUTIL_INSTALL_STAGING = YES
XLIB_LIBLBXUTIL_DEPENDANCIES = xproto_xextproto
XLIB_LIBLBXUTIL_CONF_OPT =  --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_liblbxutil))
