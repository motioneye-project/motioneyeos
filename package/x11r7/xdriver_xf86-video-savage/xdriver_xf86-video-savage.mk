################################################################################
#
# xdriver_xf86-video-savage
#
################################################################################

XDRIVER_XF86_VIDEO_SAVAGE_VERSION = 2.3.9
XDRIVER_XF86_VIDEO_SAVAGE_SOURCE = xf86-video-savage-$(XDRIVER_XF86_VIDEO_SAVAGE_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SAVAGE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SAVAGE_LICENSE = MIT
XDRIVER_XF86_VIDEO_SAVAGE_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_SAVAGE_AUTORECONF = YES
XDRIVER_XF86_VIDEO_SAVAGE_DEPENDENCIES = xserver_xorg-server libdrm xorgproto

ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),)
XDRIVER_XF86_VIDEO_SAVAGE_CONF_OPTS = --disable-dri
endif

$(eval $(autotools-package))
