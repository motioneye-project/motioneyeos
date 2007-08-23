################################################################################
#
# xdriver_xf86-video-ark -- X.Org driver for ark cards
#
################################################################################

XDRIVER_XF86_VIDEO_ARK_VERSION = 0.6.0
XDRIVER_XF86_VIDEO_ARK_SOURCE = xf86-video-ark-$(XDRIVER_XF86_VIDEO_ARK_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_ARK_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_ARK_AUTORECONF = YES
XDRIVER_XF86_VIDEO_ARK_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-ark))
