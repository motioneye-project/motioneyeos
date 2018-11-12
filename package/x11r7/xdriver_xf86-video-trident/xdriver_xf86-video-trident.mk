################################################################################
#
# xdriver_xf86-video-trident
#
################################################################################

XDRIVER_XF86_VIDEO_TRIDENT_VERSION = 1.3.8
XDRIVER_XF86_VIDEO_TRIDENT_SOURCE = xf86-video-trident-$(XDRIVER_XF86_VIDEO_TRIDENT_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_TRIDENT_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_TRIDENT_LICENSE = MIT
XDRIVER_XF86_VIDEO_TRIDENT_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_TRIDENT_DEPENDENCIES = xserver_xorg-server xorgproto

$(eval $(autotools-package))
