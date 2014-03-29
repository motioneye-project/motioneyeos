################################################################################
#
# xdriver_xf86-video-ati
#
################################################################################

XDRIVER_XF86_VIDEO_ATI_VERSION = 6.14.6
XDRIVER_XF86_VIDEO_ATI_SOURCE = xf86-video-ati-$(XDRIVER_XF86_VIDEO_ATI_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_ATI_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_ATI_LICENSE = MIT
XDRIVER_XF86_VIDEO_ATI_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_ATI_AUTORECONF = YES
XDRIVER_XF86_VIDEO_ATI_DEPENDENCIES = xserver_xorg-server libdrm xproto_fontsproto xproto_glproto xproto_randrproto xproto_videoproto xproto_xextproto xproto_xf86driproto xproto_xineramaproto xproto_xproto

$(eval $(autotools-package))
