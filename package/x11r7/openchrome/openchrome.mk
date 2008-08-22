#############################################################
#
# openchrome
#
#############################################################
OPENCHROME_VERSION = 0.2.902
OPENCHROME_SOURCE = xf86-video-openchrome-$(OPENCHROME_VERSION).tar.bz2
OPENCHROME_SITE = http://www.openchrome.org/releases

OPENCHROME_DEPENDENCIES = xserver_xorg-server libdrm xlib_libX11 xlib_libXvMC xproto_fontsproto xproto_glproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xf86driproto xproto_xproto

OPENCHROME_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

OPENCHROME_AUTORECONF = YES
OPENCHROME_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,openchrome))
