################################################################################
#
# xdriver_xf86-video-apm -- Alliance ProMotion video driver
#
################################################################################

XDRIVER_XF86_VIDEO_APM_VERSION = 1.1.1
XDRIVER_XF86_VIDEO_APM_SOURCE = xf86-video-apm-$(XDRIVER_XF86_VIDEO_APM_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_APM_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_APM_AUTORECONF = YES
XDRIVER_XF86_VIDEO_APM_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86rushproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-apm))
