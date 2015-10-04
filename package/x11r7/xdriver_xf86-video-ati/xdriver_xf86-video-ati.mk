################################################################################
#
# xdriver_xf86-video-ati
#
################################################################################

XDRIVER_XF86_VIDEO_ATI_VERSION = 7.5.0
XDRIVER_XF86_VIDEO_ATI_SOURCE = xf86-video-ati-$(XDRIVER_XF86_VIDEO_ATI_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_ATI_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_ATI_LICENSE = MIT
XDRIVER_XF86_VIDEO_ATI_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_ATI_DEPENDENCIES = \
	libdrm \
	xlib_libXcomposite \
	xproto_fontsproto \
	xproto_glproto \
	xproto_randrproto \
	xproto_videoproto \
	xproto_xextproto \
	xproto_xf86driproto \
	xproto_xineramaproto \
	xproto_xproto \
	xserver_xorg-server

ifeq ($(BR2_PACKAGE_LIBEPOXY),y)
XDRIVER_XF86_VIDEO_ATI_CONF_OPTS = --enable-glamor
else
XDRIVER_XF86_VIDEO_ATI_CONF_OPTS = --disable-glamor
endif

$(eval $(autotools-package))
