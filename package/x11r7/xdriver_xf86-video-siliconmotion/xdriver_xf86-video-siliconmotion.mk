################################################################################
#
# xdriver_xf86-video-siliconmotion -- Silicon Motion video driver
#
################################################################################

XDRIVER_XF86_VIDEO_SILICONMOTION_VERSION = 1.6.0
XDRIVER_XF86_VIDEO_SILICONMOTION_SOURCE = xf86-video-siliconmotion-$(XDRIVER_XF86_VIDEO_SILICONMOTION_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SILICONMOTION_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SILICONMOTION_AUTORECONF = NO
XDRIVER_XF86_VIDEO_SILICONMOTION_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto
XDRIVER_XF86_VIDEO_SILICONMOTION_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-siliconmotion))
