################################################################################
#
# xdriver_xf86-video-chips -- Chips and Technologies video driver
#
################################################################################

XDRIVER_XF86_VIDEO_CHIPS_VERSION = 1.1.1
XDRIVER_XF86_VIDEO_CHIPS_SOURCE = xf86-video-chips-$(XDRIVER_XF86_VIDEO_CHIPS_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_CHIPS_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_CHIPS_AUTORECONF = NO
XDRIVER_XF86_VIDEO_CHIPS_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-chips))
