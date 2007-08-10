################################################################################
#
# xdriver_xf86-video-nv -- NVIDIA video driver
#
################################################################################

XDRIVER_XF86_VIDEO_NV_VERSION = 1.2.2.1
XDRIVER_XF86_VIDEO_NV_SOURCE = xf86-video-nv-$(XDRIVER_XF86_VIDEO_NV_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_NV_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_NV_AUTORECONF = YES
XDRIVER_XF86_VIDEO_NV_DEPENDANCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-nv))
