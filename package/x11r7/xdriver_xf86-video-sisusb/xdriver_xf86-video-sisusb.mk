################################################################################
#
# xdriver_xf86-video-sisusb -- SiS USB video driver
#
################################################################################

XDRIVER_XF86_VIDEO_SISUSB_VERSION = 0.9.0
XDRIVER_XF86_VIDEO_SISUSB_SOURCE = xf86-video-sisusb-$(XDRIVER_XF86_VIDEO_SISUSB_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SISUSB_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SISUSB_AUTORECONF = NO
XDRIVER_XF86_VIDEO_SISUSB_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86miscproto xproto_xineramaproto xproto_xproto
XDRIVER_XF86_VIDEO_SISUSB_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-sisusb))
