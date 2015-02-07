################################################################################
#
# xdriver_xf86-video-mga
#
################################################################################

XDRIVER_XF86_VIDEO_MGA_VERSION = 132dee029e36c9a91a85f178885e94a9f9b5ee37
XDRIVER_XF86_VIDEO_MGA_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-mga
XDRIVER_XF86_VIDEO_MGA_LICENSE = MIT
XDRIVER_XF86_VIDEO_MGA_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_MGA_AUTORECONF = YES
XDRIVER_XF86_VIDEO_MGA_DEPENDENCIES = xserver_xorg-server libdrm xproto_fontsproto xproto_glproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86driproto xproto_xproto

$(eval $(autotools-package))
