################################################################################
#
# xdriver_xf86-video-savage
#
################################################################################

XDRIVER_XF86_VIDEO_SAVAGE_VERSION = d28cd83c7b0b4a943efbe5ddf257c8ee2646ea73
XDRIVER_XF86_VIDEO_SAVAGE_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-savage
XDRIVER_XF86_VIDEO_SAVAGE_LICENSE = MIT
XDRIVER_XF86_VIDEO_SAVAGE_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_SAVAGE_AUTORECONF = YES
XDRIVER_XF86_VIDEO_SAVAGE_DEPENDENCIES = xserver_xorg-server libdrm xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86driproto xproto_xproto

$(eval $(autotools-package))
