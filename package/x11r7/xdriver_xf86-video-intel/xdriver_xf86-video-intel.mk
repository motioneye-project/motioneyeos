################################################################################
#
# xdriver_xf86-video-intel
#
################################################################################

XDRIVER_XF86_VIDEO_INTEL_VERSION = 82293901da23d79fd074e5255fda5c95405d52de
XDRIVER_XF86_VIDEO_INTEL_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-intel
XDRIVER_XF86_VIDEO_INTEL_LICENSE = MIT
XDRIVER_XF86_VIDEO_INTEL_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_INTEL_AUTORECONF = YES

# this fixes a getline-related compilation error in src/sna/kgem.c
XDRIVER_XF86_VIDEO_INTEL_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

XDRIVER_XF86_VIDEO_INTEL_CONF_OPTS = \
	--disable-xvmc \
	--enable-sna \
	--disable-glamor \
	--disable-xaa \
	--disable-dga \
	--disable-async-swap

XDRIVER_XF86_VIDEO_INTEL_DEPENDENCIES = \
	libdrm \
	libpciaccess \
	xlib_libXrandr \
	xproto_fontsproto \
	xproto_xproto \
	xserver_xorg-server

# X.org server support for DRI depends on a Mesa3D DRI driver
ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),y)
XDRIVER_XF86_VIDEO_INTEL_CONF_OPTS += --enable-dri --enable-dri1
# quote from configure.ac: "UXA doesn't build without DRI2 headers"
ifeq ($(BR2_PACKAGE_XPROTO_DRI2PROTO),y)
XDRIVER_XF86_VIDEO_INTEL_CONF_OPTS += --enable-dri2 --enable-uxa
else
XDRIVER_XF86_VIDEO_INTEL_CONF_OPTS += --disable-dri2 --disable-uxa
endif
ifeq ($(BR2_PACKAGE_XPROTO_DRI3PROTO),y)
XDRIVER_XF86_VIDEO_INTEL_CONF_OPTS += --enable-dri3
else
XDRIVER_XF86_VIDEO_INTEL_CONF_OPTS += --disable-dri3
endif
else
XDRIVER_XF86_VIDEO_INTEL_CONF_OPTS += --disable-dri
endif

$(eval $(autotools-package))
