################################################################################
#
# xdriver_xf86-video-cirrus
#
################################################################################

XDRIVER_XF86_VIDEO_CIRRUS_VERSION = df389885adf71ed3b045c2fde9fd3ba4329e1a58
XDRIVER_XF86_VIDEO_CIRRUS_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-cirrus
XDRIVER_XF86_VIDEO_CIRRUS_LICENSE = MIT
XDRIVER_XF86_VIDEO_CIRRUS_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_CIRRUS_AUTORECONF = YES
XDRIVER_XF86_VIDEO_CIRRUS_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto

$(eval $(autotools-package))
