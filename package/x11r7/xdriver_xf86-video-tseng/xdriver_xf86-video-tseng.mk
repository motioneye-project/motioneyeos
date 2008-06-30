################################################################################
#
# xdriver_xf86-video-tseng -- Tseng Labs video driver
#
################################################################################

XDRIVER_XF86_VIDEO_TSENG_VERSION = 1.2.0
XDRIVER_XF86_VIDEO_TSENG_SOURCE = xf86-video-tseng-$(XDRIVER_XF86_VIDEO_TSENG_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_TSENG_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_TSENG_AUTORECONF = NO
XDRIVER_XF86_VIDEO_TSENG_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-tseng))
