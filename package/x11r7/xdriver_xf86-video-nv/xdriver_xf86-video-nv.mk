################################################################################
#
# xdriver_xf86-video-nv -- NVIDIA video driver
#
################################################################################

XDRIVER_XF86_VIDEO_NV_VERSION = 2.1.3
XDRIVER_XF86_VIDEO_NV_SOURCE = xf86-video-nv-$(XDRIVER_XF86_VIDEO_NV_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_NV_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_NV_AUTORECONF = NO
XDRIVER_XF86_VIDEO_NV_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-nv))
