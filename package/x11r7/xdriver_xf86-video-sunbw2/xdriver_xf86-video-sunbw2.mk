################################################################################
#
# xdriver_xf86-video-sunbw2 -- BW2 video driver
#
################################################################################

XDRIVER_XF86_VIDEO_SUNBW2_VERSION = 1.1.0
XDRIVER_XF86_VIDEO_SUNBW2_SOURCE = xf86-video-sunbw2-$(XDRIVER_XF86_VIDEO_SUNBW2_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SUNBW2_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SUNBW2_AUTORECONF = YES
XDRIVER_XF86_VIDEO_SUNBW2_DEPENDANCIES = xserver_xorg-server xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-sunbw2))
