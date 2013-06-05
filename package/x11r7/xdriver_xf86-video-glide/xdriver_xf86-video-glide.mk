################################################################################
#
# xdriver_xf86-video-glide
#
################################################################################

XDRIVER_XF86_VIDEO_GLIDE_VERSION = 1.2.0
XDRIVER_XF86_VIDEO_GLIDE_SOURCE = xf86-video-glide-$(XDRIVER_XF86_VIDEO_GLIDE_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_GLIDE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_GLIDE_LICENSE = MIT
XDRIVER_XF86_VIDEO_GLIDE_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_GLIDE_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xproto

$(eval $(autotools-package))
