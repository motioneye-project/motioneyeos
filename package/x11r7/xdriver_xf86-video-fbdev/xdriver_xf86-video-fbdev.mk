################################################################################
#
# xdriver_xf86-video-fbdev -- video driver for framebuffer device
#
################################################################################

XDRIVER_XF86_VIDEO_FBDEV_VERSION = 0.3.1
XDRIVER_XF86_VIDEO_FBDEV_SOURCE = xf86-video-fbdev-$(XDRIVER_XF86_VIDEO_FBDEV_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_FBDEV_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_FBDEV_AUTORECONF = YES
XDRIVER_XF86_VIDEO_FBDEV_DEPENDANCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-fbdev))
