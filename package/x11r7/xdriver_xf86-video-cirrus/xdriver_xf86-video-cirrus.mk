################################################################################
#
# xdriver_xf86-video-cirrus
#
################################################################################

XDRIVER_XF86_VIDEO_CIRRUS_VERSION = 1.5.3
XDRIVER_XF86_VIDEO_CIRRUS_SOURCE = xf86-video-cirrus-$(XDRIVER_XF86_VIDEO_CIRRUS_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_CIRRUS_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_CIRRUS_LICENSE = MIT
XDRIVER_XF86_VIDEO_CIRRUS_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_CIRRUS_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto

$(eval $(autotools-package))
