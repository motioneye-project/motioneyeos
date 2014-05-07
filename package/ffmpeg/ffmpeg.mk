################################################################################
#
# ffmpeg
#
################################################################################

FFMPEG_VERSION = 1.2.5
FFMPEG_SOURCE = ffmpeg-$(FFMPEG_VERSION).tar.bz2
FFMPEG_SITE = http://ffmpeg.org/releases
FFMPEG_INSTALL_STAGING = YES

FFMPEG_LICENSE = LGPLv2.1+, libjpeg license
FFMPEG_LICENSE_FILES = LICENSE COPYING.LGPLv2.1
ifeq ($(BR2_PACKAGE_FFMPEG_GPL),y)
FFMPEG_LICENSE += and GPLv2+
FFMPEG_LICENSE_FILES += COPYING.GPLv2
endif

FFMPEG_CONF_OPT = \
	--prefix=/usr		\
	--enable-avfilter \
	--disable-debug \
	--disable-version3 \
	--enable-logging \
	--disable-pic \
	--enable-optimizations \
	--disable-extra-warnings \
	--disable-ffprobe \
	--enable-avdevice \
	--enable-avcodec \
	--enable-avformat \
	--enable-swscale \
	--enable-postproc \
	--disable-x11grab \
	--enable-network \
	--disable-gray \
	--enable-swscale-alpha \
	--disable-small \
	--enable-dct \
	--enable-fft \
	--enable-mdct \
	--enable-rdft \
	--disable-crystalhd \
	--disable-vaapi \
	--disable-vdpau \
	--disable-dxva2 \
	--enable-runtime-cpudetect \
	--disable-hardcoded-tables \
	--disable-memalign-hack \
	--enable-hwaccels \
	--disable-avisynth \
	--disable-frei0r \
	--disable-libopencore-amrnb \
	--disable-libopencore-amrwb \
	--disable-libopencv \
	--disable-libdc1394 \
	--disable-libfaac \
	--disable-libfreetype \
	--disable-libgsm \
	--disable-libmp3lame \
	--disable-libnut \
	--disable-libopenjpeg \
	--disable-librtmp \
	--disable-libschroedinger \
	--disable-libspeex \
	--disable-libtheora \
	--disable-libvo-aacenc \
	--disable-libvo-amrwbenc \
	--disable-vis \
	--disable-sram \
	--disable-symver \
	--disable-doc

FFMPEG_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_FFMPEG_GPL),y)
FFMPEG_CONF_OPT += --enable-gpl
else
FFMPEG_CONF_OPT += --disable-gpl
endif

ifeq ($(BR2_PACKAGE_FFMPEG_NONFREE),y)
FFMPEG_CONF_OPT += --enable-nonfree
else
FFMPEG_CONF_OPT += --disable-nonfree
endif

ifeq ($(BR2_PACKAGE_FFMPEG_FFMPEG),y)
FFMPEG_CONF_OPT += --enable-ffmpeg
else
FFMPEG_CONF_OPT += --disable-ffmpeg
endif

ifeq ($(BR2_PACKAGE_FFMPEG_FFPLAY),y)
FFMPEG_DEPENDENCIES += sdl
FFMPEG_CONF_OPT += --enable-ffplay
FFMPEG_CONF_ENV += SDL_CONFIG=$(STAGING_DIR)/usr/bin/sdl-config
else
FFMPEG_CONF_OPT += --disable-ffplay
endif

ifeq ($(BR2_PACKAGE_FFMPEG_FFSERVER),y)
FFMPEG_CONF_OPT += --enable-ffserver
else
FFMPEG_CONF_OPT += --disable-ffserver
endif

ifeq ($(BR2_PACKAGE_FFMPEG_POSTPROC),y)
FFMPEG_CONF_OPT += --enable-postproc
else
FFMPEG_CONF_OPT += --disable-postproc
endif

ifeq ($(BR2_PACKAGE_FFMPEG_SWSCALE),y)
FFMPEG_CONF_OPT += --enable-swscale
else
FFMPEG_CONF_OPT += --disable-swscale
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_ENCODERS)),all)
FFMPEG_CONF_OPT += --disable-encoders \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_ENCODERS)),--enable-encoder=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_DECODERS)),all)
FFMPEG_CONF_OPT += --disable-decoders \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_DECODERS)),--enable-decoder=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_MUXERS)),all)
FFMPEG_CONF_OPT += --disable-muxers \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_MUXERS)),--enable-muxer=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_DEMUXERS)),all)
FFMPEG_CONF_OPT += --disable-demuxers \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_DEMUXERS)),--enable-demuxer=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_PARSERS)),all)
FFMPEG_CONF_OPT += --disable-parsers \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_PARSERS)),--enable-parser=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_BSFS)),all)
FFMPEG_CONF_OPT += --disable-bsfs \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_BSFS)),--enable-bsfs=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_PROTOCOLS)),all)
FFMPEG_CONF_OPT += --disable-protocols \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_PROTOCOLS)),--enable-protocol=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_FILTERS)),all)
FFMPEG_CONF_OPT += --disable-filters \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_FILTERS)),--enable-filter=$(x))
endif

ifeq ($(BR2_PACKAGE_FFMPEG_INDEVS),y)
FFMPEG_CONF_OPT += --enable-indevs
else
FFMPEG_CONF_OPT += --disable-indevs
endif

ifeq ($(BR2_PACKAGE_FFMPEG_OUTDEVS),y)
FFMPEG_CONF_OPT += --enable-outdevs
else
FFMPEG_CONF_OPT += --disable-outdevs
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
FFMPEG_CONF_OPT += --enable-pthreads
else
FFMPEG_CONF_OPT += --disable-pthreads
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
FFMPEG_CONF_OPT += --enable-zlib
FFMPEG_DEPENDENCIES += zlib
else
FFMPEG_CONF_OPT += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
FFMPEG_CONF_OPT += --enable-bzlib
FFMPEG_DEPENDENCIES += bzip2
else
FFMPEG_CONF_OPT += --disable-bzlib
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
# openssl isn't license compatible with GPL
ifeq ($(BR2_PACKAGE_FFMPEG_GPL)x$(BR2_PACKAGE_FFMPEG_NONFREE),yx)
FFMPEG_CONF_OPT += --disable-openssl
else
FFMPEG_CONF_OPT += --enable-openssl
FFMPEG_DEPENDENCIES += openssl
endif
else
FFMPEG_CONF_OPT += --disable-openssl
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
FFMPEG_DEPENDENCIES += libvorbis
FFMPEG_CONF_OPT += \
	--enable-libvorbis \
	--enable-muxer=ogg \
	--enable-encoder=libvorbis
endif

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
FFMPEG_CONF_OPT += --enable-yasm
FFMPEG_DEPENDENCIES += host-yasm
else
FFMPEG_CONF_OPT += --disable-yasm
FFMPEG_CONF_OPT += --disable-mmx
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
FFMPEG_CONF_OPT += --enable-sse
else
FFMPEG_CONF_OPT += --disable-sse
endif

ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
FFMPEG_CONF_OPT += --enable-sse2
else
FFMPEG_CONF_OPT += --disable-sse2
endif

ifeq ($(BR2_X86_CPU_HAS_SSE3),y)
FFMPEG_CONF_OPT += --enable-sse3
else
FFMPEG_CONF_OPT += --disable-sse3
endif

ifeq ($(BR2_X86_CPU_HAS_SSSE3),y)
FFMPEG_CONF_OPT += --enable-ssse3
else
FFMPEG_CONF_OPT += --disable-ssse3
endif

ifeq ($(BR2_X86_CPU_HAS_SSE4),y)
FFMPEG_CONF_OPT += --enable-sse4
else
FFMPEG_CONF_OPT += --disable-sse4
endif

ifeq ($(BR2_X86_CPU_HAS_SSE42),y)
FFMPEG_CONF_OPT += --enable-sse42
else
FFMPEG_CONF_OPT += --disable-sse42
endif

# Explicitly disable everything that doesn't match for ARM
# FFMPEG "autodetects" by compiling an extended instruction via AS
# This works on compilers that aren't built for generic by default
ifeq ($(BR2_arm920t)$(BR2_arm922t)$(BR2_strongarm)$(BR2_fa526),y)
FFMPEG_CONF_OPT += --disable-armv5te
endif
ifeq ($(BR2_arm1136jf_s)$(BR2_arm1176jz_s)$(BR2_arm1176jzf_s),y)
FFMPEG_CONF_OPT += --enable-armv6
else
FFMPEG_CONF_OPT += --disable-armv6 --disable-armv6t2
endif
ifeq ($(BR2_arm10)$(BR2_arm1136jf_s)$(BR2_arm1176jz_s)$(BR2_arm1176jzf_s)$(BR2_cortex_a5)$(BR2_cortex_a8)$(BR2_cortex_a9)$(BR2_cortex_a15),y)
FFMPEG_CONF_OPT += --enable-vfp
else
FFMPEG_CONF_OPT += --disable-vfp
endif
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
FFMPEG_CONF_OPT += --enable-neon
endif

ifeq ($(BR2_MIPS_SOFT_FLOAT),y)
FFMPEG_CONF_OPT += \
	--disable-mipsfpu
else
FFMPEG_CONF_OPT += \
	--enable-mipsfpu
endif

ifeq ($(BR2_mips_32r2),y)
FFMPEG_CONF_OPT += \
	--enable-mips32r2
else
FFMPEG_CONF_OPT += \
	--disable-mips32r2
endif

ifeq ($(BR2_mips_64r2),y)
FFMPEG_CONF_OPT += \
	--enable-mipsdspr1 \
	--enable-mipsdspr2
else
FFMPEG_CONF_OPT += \
	--disable-mipsdspr1 \
	--disable-mipsdspr2
endif

# Set powerpc altivec appropriately
ifeq ($(BR2_powerpc),y)
ifeq ($(BR2_powerpc_7400)$(BR2_powerpc_7450)$(BR2_powerpc_970),y)
FFMPEG_CONF_OPT += --enable-altivec
else
FFMPEG_CONF_OPT += --disable-altivec
endif
endif

ifeq ($(BR2_PREFER_STATIC_LIB),)
FFMPEG_CONF_OPT += --enable-pic
endif

FFMPEG_CONF_OPT += $(call qstrip,$(BR2_PACKAGE_FFMPEG_EXTRACONF))

# Override FFMPEG_CONFIGURE_CMDS: FFmpeg does not support --target and others
define FFMPEG_CONFIGURE_CMDS
	(cd $(FFMPEG_SRCDIR) && rm -rf config.cache && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	$(FFMPEG_CONF_ENV) \
	./configure \
		--enable-cross-compile	\
		--cross-prefix=$(TARGET_CROSS) \
		--sysroot=$(STAGING_DIR) \
		--host-cc="$(HOSTCC)" \
		--arch=$(BR2_ARCH) \
		--target-os="linux" \
		$(if $(BR2_GCC_TARGET_TUNE),--cpu=$(BR2_GCC_TARGET_TUNE)) \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(FFMPEG_CONF_OPT) \
	)
endef

$(eval $(autotools-package))
