################################################################################
#
# xdriver_xf86-video-voodoo
#
################################################################################

XDRIVER_XF86_VIDEO_VOODOO_VERSION = 1.2.5
XDRIVER_XF86_VIDEO_VOODOO_SOURCE = xf86-video-voodoo-$(XDRIVER_XF86_VIDEO_VOODOO_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_VOODOO_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_VOODOO_LICENSE = MIT
XDRIVER_XF86_VIDEO_VOODOO_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_VOODOO_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xf86dgaproto xproto_xproto

$(eval $(autotools-package))
