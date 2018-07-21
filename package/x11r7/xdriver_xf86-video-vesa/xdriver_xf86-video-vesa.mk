################################################################################
#
# xdriver_xf86-video-vesa
#
################################################################################

XDRIVER_XF86_VIDEO_VESA_VERSION = 2.4.0
XDRIVER_XF86_VIDEO_VESA_SOURCE = xf86-video-vesa-$(XDRIVER_XF86_VIDEO_VESA_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_VESA_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_VESA_LICENSE = MIT
XDRIVER_XF86_VIDEO_VESA_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_VESA_DEPENDENCIES = xserver_xorg-server xorgproto

$(eval $(autotools-package))
