################################################################################
#
# xdriver_xf86-video-mach64
#
################################################################################

XDRIVER_XF86_VIDEO_MACH64_VERSION = 6.9.6
XDRIVER_XF86_VIDEO_MACH64_SOURCE = xf86-video-mach64-$(XDRIVER_XF86_VIDEO_MACH64_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_MACH64_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_MACH64_LICENSE = MIT
XDRIVER_XF86_VIDEO_MACH64_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_MACH64_AUTORECONF = YES
XDRIVER_XF86_VIDEO_MACH64_DEPENDENCIES = xserver_xorg-server xorgproto

ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),)
XDRIVER_XF86_VIDEO_MACH64_CONF_OPTS = --disable-dri
endif

$(eval $(autotools-package))
