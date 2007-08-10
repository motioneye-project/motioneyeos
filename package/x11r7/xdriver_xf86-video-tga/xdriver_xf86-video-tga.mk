################################################################################
#
# xdriver_xf86-video-tga -- X.Org driver for tga cards
#
################################################################################

XDRIVER_XF86_VIDEO_TGA_VERSION = 1.1.0
XDRIVER_XF86_VIDEO_TGA_SOURCE = xf86-video-tga-$(XDRIVER_XF86_VIDEO_TGA_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_TGA_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_TGA_AUTORECONF = YES
XDRIVER_XF86_VIDEO_TGA_DEPENDANCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86dgaproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-tga))
