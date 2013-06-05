################################################################################
#
# xdriver_xf86-video-dummy
#
################################################################################

XDRIVER_XF86_VIDEO_DUMMY_VERSION = 0.3.5
XDRIVER_XF86_VIDEO_DUMMY_SOURCE = xf86-video-dummy-$(XDRIVER_XF86_VIDEO_DUMMY_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_DUMMY_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_DUMMY_LICENSE = MIT
XDRIVER_XF86_VIDEO_DUMMY_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_DUMMY_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xf86dgaproto xproto_xproto

$(eval $(autotools-package))
