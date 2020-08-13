################################################################################
#
# xdriver_xf86-video-amdgpu
#
################################################################################

XDRIVER_XF86_VIDEO_AMDGPU_VERSION = 19.1.0
XDRIVER_XF86_VIDEO_AMDGPU_SOURCE = xf86-video-amdgpu-$(XDRIVER_XF86_VIDEO_AMDGPU_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_AMDGPU_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_AMDGPU_LICENSE = MIT
XDRIVER_XF86_VIDEO_AMDGPU_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_AMDGPU_DEPENDENCIES = \
	libdrm \
	xlib_libXcomposite \
	xorgproto \
	xserver_xorg-server

# xdriver_xf86-video-amdgpu requires O_CLOEXEC
XDRIVER_XF86_VIDEO_AMDGPU_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

$(eval $(autotools-package))
