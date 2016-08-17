################################################################################
#
# xdriver_xf86-video-intel
#
################################################################################

XDRIVER_XF86_VIDEO_INTEL_VERSION = 6988b873b041130d88dd0aae70c10f86550ee2b3
XDRIVER_XF86_VIDEO_INTEL_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-intel
XDRIVER_XF86_VIDEO_INTEL_LICENSE = MIT
XDRIVER_XF86_VIDEO_INTEL_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_INTEL_AUTORECONF = YES

# -D_GNU_SOURCE fixes a getline-related compile error in src/sna/kgem.c
# We force -O2 regardless of the optimization level chosen by the user,
# as compiling this package is known to be broken with -Os.
XDRIVER_XF86_VIDEO_INTEL_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE -O2"

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
