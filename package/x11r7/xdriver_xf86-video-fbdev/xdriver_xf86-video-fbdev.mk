################################################################################
#
# xdriver_xf86-video-fbdev -- video driver for framebuffer device
#
################################################################################

XDRIVER_XF86_VIDEO_FBDEV_VERSION = 0.4.0
XDRIVER_XF86_VIDEO_FBDEV_SOURCE = xf86-video-fbdev-$(XDRIVER_XF86_VIDEO_FBDEV_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_FBDEV_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_FBDEV_AUTORECONF = NO
XDRIVER_XF86_VIDEO_FBDEV_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xproto
XDRIVER_XF86_VIDEO_FBDEV_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-fbdev))
