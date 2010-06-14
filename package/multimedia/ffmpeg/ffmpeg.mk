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
	--disable-postproc	\
	--disable-swscale	\
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

ifeq ($(BR2_PTHREADS_NONE),y)
FFMPEG_CONF_OPT += --disable-pthreads
else
FFMPEG_CONF_OPT += --enable-pthreads
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
FFMPEG_CONF_OPT += --enable-zlib
FFMPEG_DEPENDENCIES += zlib
else
FFMPEG_CONF_OPT += --disable-zlib
endif

# Override FFMPEG_CONFIGURE_CMDS: FFmpeg does not support --target and others
define FFMPEG_CONFIGURE_CMDS
	(cd $(FFMPEG_SRCDIR) && rm -rf config.cache && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	$(TARGET_CONFIGURE_ENV) \
	$(FFMPEG_CONF_ENV) \
	./configure \
		--enable-cross-compile	\
		--cross-prefix=$(TARGET_CROSS) \
		--sysroot=$(STAGING_DIR) \
		--host-cc=$(HOSTCC) \
		--arch=$(BR2_ARCH) \
		--extra-cflags=-fPIC \
		$(DISABLE_IPV6) \
		$(FFMPEG_CONF_OPT) \
	)
endef

# Override FFMPEG_INSTALL_TARGET_OPT: FFmpeg does not support install-strip
FFMPEG_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/multimedia,ffmpeg))
