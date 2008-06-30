################################################################################
#
# xdriver_xf86-video-suncg3 -- CG3 video driver
#
################################################################################

XDRIVER_XF86_VIDEO_SUNCG3_VERSION = 1.1.0
XDRIVER_XF86_VIDEO_SUNCG3_SOURCE = xf86-video-suncg3-$(XDRIVER_XF86_VIDEO_SUNCG3_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SUNCG3_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SUNCG3_AUTORECONF = NO
XDRIVER_XF86_VIDEO_SUNCG3_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xproto
XDRIVER_XF86_VIDEO_SUNCG3_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-suncg3))
