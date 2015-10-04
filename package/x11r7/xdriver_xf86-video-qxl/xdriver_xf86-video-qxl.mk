################################################################################
#
# xdriver_xf86-video-qxl
#
################################################################################

XDRIVER_XF86_VIDEO_QXL_VERSION = 0.1.4
XDRIVER_XF86_VIDEO_QXL_SOURCE = xf86-video-qxl-$(XDRIVER_XF86_VIDEO_QXL_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_QXL_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_QXL_LICENSE = MIT
XDRIVER_XF86_VIDEO_QXL_LICENSE_FILES = COPYING

XDRIVER_XF86_VIDEO_QXL_CONF_OPTS = \
	--enable-xspice=no

XDRIVER_XF86_VIDEO_QXL_DEPENDENCIES = \
	libpciaccess \
	spice-protocol \
	xproto_fontsproto \
	xproto_xproto \
	xserver_xorg-server

# configure doesn't look for drm headers in the appropiate place, so help it
# libdrm is only useful with udev for KMS
ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
XDRIVER_XF86_VIDEO_QXL_CONF_ENV += REQUIRED_MODULES=libdrm
XDRIVER_XF86_VIDEO_QXL_DEPENDENCIES += libdrm
else
XDRIVER_XF86_VIDEO_QXL_CONF_OPTS += --disable-kms
endif

$(eval $(autotools-package))
