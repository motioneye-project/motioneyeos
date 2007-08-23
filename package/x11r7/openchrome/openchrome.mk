#############################################################
#
# openchrome
#
#############################################################
OPENCHROME_VERSION = r355
OPENCHROME_SOURCE = openchrome-$(OPENCHROME_VERSION).tar.bz2
OPENCHROME_SITE = http://bazaar.mezis.net/

OPENCHROME_DEPENDENCIES = xserver_xorg-server libdrm xlib_libX11 xlib_libXvMC xproto_fontsproto xproto_glproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xf86driproto xproto_xproto

OPENCHROME_AUTORECONF = YES
OPENCHROME_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,openchrome))
