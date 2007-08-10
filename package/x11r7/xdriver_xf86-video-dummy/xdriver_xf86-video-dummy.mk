################################################################################
#
# xdriver_xf86-video-dummy -- X.Org driver for dummy cards
#
################################################################################

XDRIVER_XF86_VIDEO_DUMMY_VERSION = 0.2.0
XDRIVER_XF86_VIDEO_DUMMY_SOURCE = xf86-video-dummy-$(XDRIVER_XF86_VIDEO_DUMMY_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_DUMMY_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_DUMMY_AUTORECONF = YES
XDRIVER_XF86_VIDEO_DUMMY_DEPENDANCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xf86dgaproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-dummy))
