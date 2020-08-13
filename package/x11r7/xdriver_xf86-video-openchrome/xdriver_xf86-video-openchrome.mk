################################################################################
#
# xdriver_xf86-video-openchrome
#
################################################################################

XDRIVER_XF86_VIDEO_OPENCHROME_VERSION = 0.6.0
XDRIVER_XF86_VIDEO_OPENCHROME_SOURCE = xf86-video-openchrome-$(XDRIVER_XF86_VIDEO_OPENCHROME_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_OPENCHROME_SITE = http://xorg.freedesktop.org/archive/individual/driver
XDRIVER_XF86_VIDEO_OPENCHROME_LICENSE = MIT
XDRIVER_XF86_VIDEO_OPENCHROME_LICENSE_FILES = COPYING

XDRIVER_XF86_VIDEO_OPENCHROME_DEPENDENCIES = \
	xserver_xorg-server \
	libdrm \
	xlib_libX11 \
	xlib_libXcomposite \
	xlib_libXvMC \
	xorgproto

$(eval $(autotools-package))
