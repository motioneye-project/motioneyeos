################################################################################
#
# xdriver_xf86-video-mga
#
################################################################################

XDRIVER_XF86_VIDEO_MGA_VERSION = 1.6.4
XDRIVER_XF86_VIDEO_MGA_SOURCE = xf86-video-mga-$(XDRIVER_XF86_VIDEO_MGA_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_MGA_SITE = http://xorg.freedesktop.org/archive/individual/driver
XDRIVER_XF86_VIDEO_MGA_LICENSE = MIT
XDRIVER_XF86_VIDEO_MGA_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_MGA_AUTORECONF = YES
XDRIVER_XF86_VIDEO_MGA_DEPENDENCIES = xserver_xorg-server libdrm xproto_fontsproto xproto_glproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86driproto xproto_xproto

$(eval $(autotools-package))
