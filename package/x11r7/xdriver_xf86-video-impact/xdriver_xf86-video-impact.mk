################################################################################
#
# xdriver_xf86-video-impact -- Impact video driver
#
################################################################################

XDRIVER_XF86_VIDEO_IMPACT_VERSION = 0.2.0
XDRIVER_XF86_VIDEO_IMPACT_SOURCE = xf86-video-impact-$(XDRIVER_XF86_VIDEO_IMPACT_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_IMPACT_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_IMPACT_AUTORECONF = NO
XDRIVER_XF86_VIDEO_IMPACT_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto
XDRIVER_XF86_VIDEO_IMPACT_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-impact))
