################################################################################
#
# xdriver_xf86-video-tdfx
#
################################################################################

XDRIVER_XF86_VIDEO_TDFX_VERSION = 1.4.6
XDRIVER_XF86_VIDEO_TDFX_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_TDFX_SOURCE = xf86-video-tdfx-$(XDRIVER_XF86_VIDEO_TDFX_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_TDFX_LICENSE = MIT
XDRIVER_XF86_VIDEO_TDFX_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_TDFX_AUTORECONF = YES
XDRIVER_XF86_VIDEO_TDFX_DEPENDENCIES = xserver_xorg-server libdrm xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86driproto xproto_xproto

$(eval $(autotools-package))
