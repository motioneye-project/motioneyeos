#############################################################
#
# ffmpeg
#
#############################################################
FFMPEG_VERSION := 0.5.2
FFMPEG_SOURCE := ffmpeg-$(FFMPEG_VERSION).tar.bz2
FFMPEG_SITE := http://ffmpeg.org/releases
FFMPEG_INSTALL_STAGING = YES
FFMPEG_INSTALL_TARGET = YES

FFMPEG_CONF_OPT = \
	--prefix=/usr		\
	--enable-shared 	\
	--disable-avfilter	\
	--disable-vhook		\

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
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_BSFS)),--enable-bsf=$(x))
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

# MMX on is default for x86, disable it for lowly x86-type processors
ifeq ($(BR2_x86_i386)$(BR2_x86_i486)$(BR2_x86_i586)$(BR2_x86_i686)$(BR2_x86_pentiumpro)$(BR2_x86_geode),y)
FFMPEG_CONF_OPT += --disable-mmx
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
		--extra-cflags=-fPIC \
		$(DISABLE_IPV6) \
		$(FFMPEG_CONF_OPT) \
	)
endef

$(eval $(call AUTOTARGETS,package/multimedia,ffmpeg))
