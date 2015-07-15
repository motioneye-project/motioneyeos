################################################################################
#
# xdriver_xf86-video-mach64
#
################################################################################

XDRIVER_XF86_VIDEO_MACH64_VERSION = 6.9.5
XDRIVER_XF86_VIDEO_MACH64_SOURCE = xf86-video-mach64-$(XDRIVER_XF86_VIDEO_MACH64_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_MACH64_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_MACH64_LICENSE = MIT
XDRIVER_XF86_VIDEO_MACH64_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_MACH64_AUTORECONF = YES
XDRIVER_XF86_VIDEO_MACH64_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xproto

$(eval $(autotools-package))
