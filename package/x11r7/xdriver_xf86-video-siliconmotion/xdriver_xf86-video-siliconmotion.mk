################################################################################
#
# xdriver_xf86-video-siliconmotion
#
################################################################################

XDRIVER_XF86_VIDEO_SILICONMOTION_VERSION = c31d7f853d7469085f96f1e37923c260884c611c
XDRIVER_XF86_VIDEO_SILICONMOTION_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-siliconmotion
XDRIVER_XF86_VIDEO_SILICONMOTION_LICENSE = MIT
XDRIVER_XF86_VIDEO_SILICONMOTION_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_SILICONMOTION_AUTORECONF = YES
XDRIVER_XF86_VIDEO_SILICONMOTION_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto

$(eval $(autotools-package))
