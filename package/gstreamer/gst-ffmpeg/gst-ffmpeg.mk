################################################################################
#
# gst-ffmpeg
#
################################################################################

GST_FFMPEG_VERSION = 0.10.13
GST_FFMPEG_SOURCE = gst-ffmpeg-$(GST_FFMPEG_VERSION).tar.bz2
GST_FFMPEG_SITE = http://gstreamer.freedesktop.org/src/gst-ffmpeg
GST_FFMPEG_INSTALL_STAGING = YES
GST_FFMPEG_DEPENDENCIES = host-pkgconf gstreamer gst-plugins-base

ifeq ($(BR2_PACKAGE_GST_FFMPEG_GPL),y)
GST_FFMPEG_CONF_OPTS += --disable-lgpl
GST_FFMPEG_LICENSE = GPL-2.0+ (gst-ffmpeg), GPL-2.0+/GPL-3.0+ (libav)
GST_FFMPEG_LICENSE_FILES = COPYING gst-libs/ext/libav/COPYING.GPLv2 gst-libs/ext/libav/COPYING.GPLv3
else
GST_FFMPEG_CONF_OPTS += --enable-lgpl
GST_FFMPEG_LICENSE = LGPL-2.0+ (gst-ffmpeg), LGPL-2.1+/LGPL-3.0+ (libav)
GST_FFMPEG_LICENSE_FILES = COPYING.LIB gst-libs/ext/libav/COPYING.LGPLv2.1 gst-libs/ext/libav/COPYING.LGPLv3
endif

GST_FFMPEG_CONF_EXTRA_OPTS = \
	--cross-prefix=$(TARGET_CROSS) \
	--target-os=linux \
	--pkg-config='$(PKG_CONFIG_HOST_BINARY)'

ifeq ($(BR2_PACKAGE_ZLIB),y)
GST_FFMPEG_CONF_EXTRA_OPTS += --enable-zlib
GST_FFMPEG_DEPENDENCIES += zlib
else
GST_FFMPEG_CONF_EXTRA_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
GST_FFMPEG_CONF_EXTRA_OPTS += --enable-bzlib
GST_FFMPEG_DEPENDENCIES += bzip2
else
GST_FFMPEG_CONF_EXTRA_OPTS += --disable-bzlib
endif

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
GST_FFMPEG_CONF_EXTRA_OPTS += --enable-yasm
GST_FFMPEG_DEPENDENCIES += host-yasm
else
GST_FFMPEG_CONF_EXTRA_OPTS += --disable-yasm
GST_FFMPEG_CONF_EXTRA_OPTS += --disable-mmx
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
GST_FFMPEG_CONF_EXTRA_OPTS += --enable-sse
else
GST_FFMPEG_CONF_EXTRA_OPTS += --disable-sse
endif

ifeq ($(BR2_X86_CPU_HAS_SSSE3),y)
GST_FFMPEG_CONF_EXTRA_OPTS += --enable-ssse3
else
GST_FFMPEG_CONF_EXTRA_OPTS += --disable-ssse3
endif

# Explicitly disable everything that doesn't match for ARM
# FFMPEG "autodetects" by compiling an extended instruction via AS
# This works on compilers that aren't built for generic by default
ifeq ($(BR2_ARM_CPU_ARMV4),y)
GST_FFMPEG_CONF_EXTRA_OPTS += --disable-armv5te
endif
ifeq ($(BR2_ARM_CPU_ARMV6)$(BR2_ARM_CPU_ARMV7A),y)
GST_FFMPEG_CONF_EXTRA_OPTS += --enable-armv6
else
GST_FFMPEG_CONF_EXTRA_OPTS += --disable-armv6 --disable-armv6t2
endif
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
GST_FFMPEG_CONF_EXTRA_OPTS += --enable-neon
endif

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
GST_FFMPEG_CONF_EXTRA_OPTS += --enable-altivec
else
GST_FFMPEG_CONF_EXTRA_OPTS += --disable-altivec
endif

# libav configure script misdetects the VIS optimizations as being
# available, so forcefully disable them.
ifeq ($(BR2_sparc_v8)$(BR2_sparc_leon3),y)
GST_FFMPEG_CONF_EXTRA_OPTS += --disable-vis
endif

ifeq ($(BR2_STATIC_LIBS),)
GST_FFMPEG_CONF_EXTRA_OPTS += --enable-pic
endif

GST_FFMPEG_CONF_OPTS += --with-ffmpeg-extra-configure="$(GST_FFMPEG_CONF_EXTRA_OPTS)"

$(eval $(autotools-package))
