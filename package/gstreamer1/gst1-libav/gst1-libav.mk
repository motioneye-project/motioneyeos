################################################################################
#
# gst1-libav
#
################################################################################

GST1_LIBAV_VERSION = 1.2.2
GST1_LIBAV_SOURCE = gst-libav-$(GST1_LIBAV_VERSION).tar.xz
GST1_LIBAV_SITE = http://gstreamer.freedesktop.org/src/gst-libav

GST1_LIBAV_DEPENDENCIES = host-pkgconf gstreamer1 gst1-plugins-base

GST1_LIBAV_CONF_EXTRA_OPT = \
	--cross-prefix=$(TARGET_CROSS) \
	--target-os=linux \
	$(if $(BR2_ENABLE_DEBUG),--enable-debug,--disable-debug)

ifeq ($(BR2_PACKAGE_ZLIB),y)
GST1_LIBAV_CONF_EXTRA_OPT += --enable-zlib
GST1_LIBAV_DEPENDENCIES += zlib
else
GST1_LIBAV_CONF_EXTRA_OPT += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
GST1_LIBAV_CONF_EXTRA_OPT += --enable-bzlib
GST1_LIBAV_DEPENDENCIES += bzip2
else
GST1_LIBAV_CONF_EXTRA_OPT += --disable-bzlib
endif

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
GST1_LIBAV_CONF_EXTRA_OPT += --enable-yasm
GST1_LIBAV_DEPENDENCIES += host-yasm
else
GST1_LIBAV_CONF_EXTRA_OPT += --disable-yasm
GST1_LIBAV_CONF_EXTRA_OPT += --disable-mmx
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
GST1_LIBAV_CONF_EXTRA_OPT += --enable-sse
else
GST1_LIBAV_CONF_EXTRA_OPT += --disable-sse
endif

ifeq ($(BR2_X86_CPU_HAS_SSSE3),y)
GST1_LIBAV_CONF_EXTRA_OPT += --enable-ssse3
else
GST1_LIBAV_CONF_EXTRA_OPT += --disable-ssse3
endif

# Explicitly disable everything that doesn't match for ARM
# FFMPEG "autodetects" by compiling an extended instruction via AS
# This works on compilers that aren't built for generic by default
ifeq ($(BR2_arm7tdmi)$(BR2_arm720t)$(BR2_arm920t)$(BR2_arm922t)$(BR2_strongarm)$(BR2_fa526),y)
GST1_LIBAV_CONF_EXTRA_OPT += --disable-armv5te
endif
ifeq ($(BR2_arm1136jf_s)$(BR2_arm1176jz_s)$(BR2_arm1176jzf_s),y)
GST1_LIBAV_CONF_EXTRA_OPT += --enable-armv6
else
GST1_LIBAV_CONF_EXTRA_OPT += --disable-armv6 --disable-armv6t2
endif
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
GST1_LIBAV_CONF_EXTRA_OPT += --enable-neon
else
GST1_LIBAV_CONF_EXTRA_OPT += --disable-neon
endif
ifeq ($(BR2_ARM_CPU_HAS_VFPV2),y)
GST1_LIBAV_CONF_EXTRA_OPT += --enable-vfp
else
GST1_LIBAV_CONF_EXTRA_OPT += --disable-vfp
endif

# Set powerpc altivec appropriately
ifeq ($(BR2_powerpc),y)
ifeq ($(BR2_powerpc_7400)$(BR2_powerpc_7450)$(BR2_powerpc_970),y)
GST1_LIBAV_CONF_EXTRA_OPT += --enable-altivec
else
GST1_LIBAV_CONF_EXTRA_OPT += --disable-altivec
endif
endif

GST1_LIBAV_CONF_OPT = \
	--with-libav-extra-configure="$(GST1_LIBAV_CONF_EXTRA_OPT)"

GST1_LIBAV_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_xtensa),y)
GST1_LIBAV_CFLAGS += -mtext-section-literals
endif

GST1_LIBAV_CONF_ENV += CFLAGS="$(GST1_LIBAV_CFLAGS)"

$(eval $(autotools-package))
