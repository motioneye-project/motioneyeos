################################################################################
#
# xdriver_xf86-video-suncg14 -- CG14 video driver
#
################################################################################

XDRIVER_XF86_VIDEO_SUNCG14_VERSION = 1.1.0
XDRIVER_XF86_VIDEO_SUNCG14_SOURCE = xf86-video-suncg14-$(XDRIVER_XF86_VIDEO_SUNCG14_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SUNCG14_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SUNCG14_AUTORECONF = NO
XDRIVER_XF86_VIDEO_SUNCG14_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-suncg14))
