################################################################################
#
# xdriver_xf86-video-sunffb -- SUNFFB video driver
#
################################################################################

XDRIVER_XF86_VIDEO_SUNFFB_VERSION = 1.2.1
XDRIVER_XF86_VIDEO_SUNFFB_SOURCE = xf86-video-sunffb-$(XDRIVER_XF86_VIDEO_SUNFFB_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SUNFFB_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SUNFFB_DEPENDENCIES = xserver_xorg-server libdrm xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xf86driproto xproto_xproto

$(eval $(autotools-package))
