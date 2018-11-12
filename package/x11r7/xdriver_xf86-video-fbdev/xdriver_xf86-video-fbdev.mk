################################################################################
#
# xdriver_xf86-video-fbdev
#
################################################################################

XDRIVER_XF86_VIDEO_FBDEV_VERSION = 0.4.4
XDRIVER_XF86_VIDEO_FBDEV_SOURCE = xf86-video-fbdev-$(XDRIVER_XF86_VIDEO_FBDEV_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_FBDEV_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_FBDEV_LICENSE = MIT
XDRIVER_XF86_VIDEO_FBDEV_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_FBDEV_DEPENDENCIES = xserver_xorg-server xorgproto

$(eval $(autotools-package))
