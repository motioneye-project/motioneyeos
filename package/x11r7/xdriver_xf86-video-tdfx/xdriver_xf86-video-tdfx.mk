################################################################################
#
# xdriver_xf86-video-tdfx
#
################################################################################

XDRIVER_XF86_VIDEO_TDFX_VERSION = 2f71b05e29ae13a0fb6fbc74f4f76c78b6ddb0d7
XDRIVER_XF86_VIDEO_TDFX_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-tdfx
XDRIVER_XF86_VIDEO_TDFX_LICENSE = MIT
XDRIVER_XF86_VIDEO_TDFX_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_TDFX_AUTORECONF = YES
XDRIVER_XF86_VIDEO_TDFX_DEPENDENCIES = xserver_xorg-server libdrm xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86driproto xproto_xproto

$(eval $(autotools-package))
