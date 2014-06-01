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

GST_FFMPEG_CONF_EXTRA_OPT = \
		--cross-prefix=$(TARGET_CROSS) \
		--target-os=linux

ifeq ($(BR2_PACKAGE_ZLIB),y)
GST_FFMPEG_CONF_EXTRA_OPT += --enable-zlib
GST_FFMPEG_DEPENDENCIES += zlib
else
GST_FFMPEG_CONF_EXTRA_OPT += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
GST_FFMPEG_CONF_EXTRA_OPT += --enable-bzlib
GST_FFMPEG_DEPENDENCIES += bzip2
else
GST_FFMPEG_CONF_EXTRA_OPT += --disable-bzlib
endif

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
GST_FFMPEG_CONF_EXTRA_OPT += --enable-yasm
GST_FFMPEG_DEPENDENCIES += host-yasm
else
GST_FFMPEG_CONF_EXTRA_OPT += --disable-yasm
GST_FFMPEG_CONF_EXTRA_OPT += --disable-mmx
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
GST_FFMPEG_CONF_EXTRA_OPT += --enable-sse
else
GST_FFMPEG_CONF_EXTRA_OPT += --disable-sse
endif

ifeq ($(BR2_X86_CPU_HAS_SSSE3),y)
GST_FFMPEG_CONF_EXTRA_OPT += --enable-ssse3
else
GST_FFMPEG_CONF_EXTRA_OPT += --disable-ssse3
endif

# Explicitly disable everything that doesn't match for ARM
# FFMPEG "autodetects" by compiling an extended instruction via AS
# This works on compilers that aren't built for generic by default
ifeq ($(BR2_arm920t)$(BR2_arm922t)$(BR2_strongarm)$(BR2_fa526),y)
GST_FFMPEG_CONF_EXTRA_OPT += --disable-armv5te
endif
ifeq ($(BR2_arm1136jf_s)$(BR2_arm1176jz_s)$(BR2_arm1176jzf_s),y)
GST_FFMPEG_CONF_EXTRA_OPT += --enable-armv6
else
GST_FFMPEG_CONF_EXTRA_OPT += --disable-armv6 --disable-armv6t2
endif
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
GST_FFMPEG_CONF_EXTRA_OPT += --enable-neon
endif

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
GST_FFMPEG_CONF_EXTRA_OPT += --enable-altivec
else
GST_FFMPEG_CONF_EXTRA_OPT += --disable-altivec
endif

ifeq ($(BR2_PREFER_STATIC_LIB),)
GST_FFMPEG_CONF_EXTRA_OPT += --enable-pic
endif

GST_FFMPEG_CONF_OPT = --with-ffmpeg-extra-configure="$(GST_FFMPEG_CONF_EXTRA_OPT)"

$(eval $(autotools-package))
