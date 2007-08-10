################################################################################
#
# xdriver_xf86-video-s3virge -- S3 ViRGE video driver
#
################################################################################

XDRIVER_XF86_VIDEO_S3VIRGE_VERSION = 1.9.1
XDRIVER_XF86_VIDEO_S3VIRGE_SOURCE = xf86-video-s3virge-$(XDRIVER_XF86_VIDEO_S3VIRGE_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_S3VIRGE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_S3VIRGE_AUTORECONF = YES
XDRIVER_XF86_VIDEO_S3VIRGE_DEPENDANCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-s3virge))
