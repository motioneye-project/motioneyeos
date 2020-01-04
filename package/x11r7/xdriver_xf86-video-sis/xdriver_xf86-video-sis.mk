################################################################################
#
# xdriver_xf86-video-sis
#
################################################################################

XDRIVER_XF86_VIDEO_SIS_VERSION = 0.12.0
XDRIVER_XF86_VIDEO_SIS_SOURCE = xf86-video-sis-$(XDRIVER_XF86_VIDEO_SIS_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SIS_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SIS_LICENSE = MIT
XDRIVER_XF86_VIDEO_SIS_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_SIS_DEPENDENCIES = xserver_xorg-server libdrm xorgproto

ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),)
XDRIVER_XF86_VIDEO_SIS_CONF_OPTS += --disable-dri
endif

$(eval $(autotools-package))
