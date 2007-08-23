################################################################################
#
# xdriver_xf86-video-savage -- S3 Savage video driver
#
################################################################################

XDRIVER_XF86_VIDEO_SAVAGE_VERSION = 2.1.2
XDRIVER_XF86_VIDEO_SAVAGE_SOURCE = xf86-video-savage-$(XDRIVER_XF86_VIDEO_SAVAGE_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SAVAGE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SAVAGE_AUTORECONF = YES
XDRIVER_XF86_VIDEO_SAVAGE_DEPENDENCIES = xserver_xorg-server libdrm xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86driproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-savage))
