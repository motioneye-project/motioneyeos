################################################################################
#
# xdriver_xf86-video-tga
#
################################################################################

XDRIVER_XF86_VIDEO_TGA_VERSION = 1.2.1
XDRIVER_XF86_VIDEO_TGA_SOURCE = xf86-video-tga-$(XDRIVER_XF86_VIDEO_TGA_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_TGA_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_TGA_LICENSE = MIT
XDRIVER_XF86_VIDEO_TGA_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_TGA_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86dgaproto xproto_xproto

$(eval $(autotools-package))
