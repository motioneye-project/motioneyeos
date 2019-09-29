################################################################################
#
# xdriver_xf86-video-mga
#
################################################################################

XDRIVER_XF86_VIDEO_MGA_VERSION = 2.0.0
XDRIVER_XF86_VIDEO_MGA_SOURCE = xf86-video-mga-$(XDRIVER_XF86_VIDEO_MGA_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_MGA_SITE = http://xorg.freedesktop.org/archive/individual/driver
XDRIVER_XF86_VIDEO_MGA_LICENSE = MIT
XDRIVER_XF86_VIDEO_MGA_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_MGA_AUTORECONF = YES
XDRIVER_XF86_VIDEO_MGA_DEPENDENCIES = xserver_xorg-server libdrm xorgproto

ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),)
XDRIVER_XF86_VIDEO_MGA_CONF_OPTS = --disable-dri
endif

$(eval $(autotools-package))
