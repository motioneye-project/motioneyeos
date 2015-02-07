################################################################################
#
# xdriver_xf86-video-r128
#
################################################################################

XDRIVER_XF86_VIDEO_R128_VERSION = fcee44e469b22934a04bd3ee19ed101aaa176a54
XDRIVER_XF86_VIDEO_R128_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-r128
XDRIVER_XF86_VIDEO_R128_LICENSE = MIT
XDRIVER_XF86_VIDEO_R128_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_R128_AUTORECONF = YES
XDRIVER_XF86_VIDEO_R128_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xproto

$(eval $(autotools-package))
