################################################################################
#
# xdriver_xf86-video-r128
#
################################################################################

XDRIVER_XF86_VIDEO_R128_VERSION = 6.10.0
XDRIVER_XF86_VIDEO_R128_SOURCE = xf86-video-r128-$(XDRIVER_XF86_VIDEO_R128_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_R128_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_R128_LICENSE = MIT
XDRIVER_XF86_VIDEO_R128_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_R128_AUTORECONF = YES
XDRIVER_XF86_VIDEO_R128_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xproto

$(eval $(autotools-package))
