################################################################################
#
# xdriver_xf86-video-i128 -- Number 9 I128 video driver
#
################################################################################

XDRIVER_XF86_VIDEO_I128_VERSION = 1.2.1
XDRIVER_XF86_VIDEO_I128_SOURCE = xf86-video-i128-$(XDRIVER_XF86_VIDEO_I128_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_I128_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_I128_AUTORECONF = YES
XDRIVER_XF86_VIDEO_I128_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-i128))
