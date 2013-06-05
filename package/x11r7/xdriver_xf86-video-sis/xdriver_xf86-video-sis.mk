################################################################################
#
# xdriver_xf86-video-sis
#
################################################################################

XDRIVER_XF86_VIDEO_SIS_VERSION = 0.10.4
XDRIVER_XF86_VIDEO_SIS_SOURCE = xf86-video-sis-$(XDRIVER_XF86_VIDEO_SIS_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SIS_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SIS_LICENSE = MIT
XDRIVER_XF86_VIDEO_SIS_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_SIS_AUTORECONF = YES
XDRIVER_XF86_VIDEO_SIS_DEPENDENCIES = xserver_xorg-server libdrm xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86dgaproto xproto_xf86driproto xproto_xineramaproto xproto_xproto

$(eval $(autotools-package))
