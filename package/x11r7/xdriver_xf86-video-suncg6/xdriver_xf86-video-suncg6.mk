################################################################################
#
# xdriver_xf86-video-suncg6 -- GX/Turbo GX video driver
#
################################################################################

XDRIVER_XF86_VIDEO_SUNCG6_VERSION = 1.1.0
XDRIVER_XF86_VIDEO_SUNCG6_SOURCE = xf86-video-suncg6-$(XDRIVER_XF86_VIDEO_SUNCG6_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SUNCG6_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SUNCG6_AUTORECONF = NO
XDRIVER_XF86_VIDEO_SUNCG6_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xproto
XDRIVER_XF86_VIDEO_SUNCG6_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-suncg6))
