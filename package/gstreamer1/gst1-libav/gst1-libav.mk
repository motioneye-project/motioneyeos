################################################################################
#
# gst1-libav
#
################################################################################

GST1_LIBAV_VERSION = 1.14.4
GST1_LIBAV_SOURCE = gst-libav-$(GST1_LIBAV_VERSION).tar.xz
GST1_LIBAV_SITE = https://gstreamer.freedesktop.org/src/gst-libav
GST1_LIBAV_DEPENDENCIES = \
	host-pkgconf gstreamer1 gst1-plugins-base \
	$(if $(BR2_PACKAGE_BZIP2),bzip2) \
	$(if $(BR2_PACKAGE_XZ),xz)
GST1_LIBAV_LICENSE = GPL-2.0+
GST1_LIBAV_LICENSE_FILES = COPYING
GST1_LIBAV_CONF_EXTRA_OPTS = --cross-prefix=$(TARGET_CROSS) --target-os=linux

# fixes arm/powerpc build: https://bugzilla.gnome.org/show_bug.cgi?id=694416
ifeq ($(BR2_arm)$(BR2_armeb)$(BR2_aarch64)$(BR2_aarch64_be)$(BR2_powerpc)$(BR2_powerpc64)$(BR2_powerpc64le),y)
GST1_LIBAV_CONF_ENV = AS="$(TARGET_CROSS)gcc"
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --enable-zlib
GST1_LIBAV_DEPENDENCIES += zlib
else
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --enable-bzlib
GST1_LIBAV_DEPENDENCIES += bzip2
else
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-bzlib
endif

# Generic CPU setup for bundled ffmpeg
# Default to --cpu=generic for MIPS architecture, in order to avoid a
# build failure on mips64r6.
ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --cpu=generic
else ifneq ($(GCC_TARGET_CPU),)
GST1_LIBAV_CONF_EXTRA_OPTS += --cpu=$(GCC_TARGET_CPU)
else ifneq ($(GCC_TARGET_ARCH),)
GST1_LIBAV_CONF_EXTRA_OPTS += --cpu=$(GCC_TARGET_ARCH)
endif

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --enable-yasm
GST1_LIBAV_DEPENDENCIES += host-yasm
else
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-yasm
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-mmx
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --enable-sse
else
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-sse
endif

ifeq ($(BR2_X86_CPU_HAS_SSSE3),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --enable-ssse3
else
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-ssse3
endif

# Explicitly disable everything that doesn't match for ARM
# FFMPEG "autodetects" by compiling an extended instruction via AS
# This works on compilers that aren't built for generic by default
ifeq ($(BR2_ARM_CPU_ARMV4),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-armv5te
endif
ifeq ($(BR2_ARM_CPU_ARMV6)$(BR2_ARM_CPU_ARMV7A),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --enable-armv6
else
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-armv6 --disable-armv6t2
endif
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --enable-neon
else
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-neon
endif
ifeq ($(BR2_ARM_CPU_HAS_VFPV2),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --enable-vfp
else
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-vfp
endif

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --enable-altivec
else
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-altivec
endif

GST1_LIBAV_CONF_OPTS = \
	--with-libav-extra-configure="$(GST1_LIBAV_CONF_EXTRA_OPTS)"

$(eval $(autotools-package))
