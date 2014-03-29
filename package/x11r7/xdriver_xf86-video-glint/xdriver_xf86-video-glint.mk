################################################################################
#
# xdriver_xf86-video-glint
#
################################################################################

XDRIVER_XF86_VIDEO_GLINT_VERSION = 1.2.8
XDRIVER_XF86_VIDEO_GLINT_SOURCE = xf86-video-glint-$(XDRIVER_XF86_VIDEO_GLINT_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_GLINT_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_GLINT_LICENSE = MIT
XDRIVER_XF86_VIDEO_GLINT_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_GLINT_AUTORECONF = YES
XDRIVER_XF86_VIDEO_GLINT_DEPENDENCIES = xserver_xorg-server libdrm xproto_fontsproto xproto_glproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86dgaproto xproto_xf86driproto xproto_xproto

$(eval $(autotools-package))
