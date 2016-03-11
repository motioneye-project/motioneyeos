################################################################################
#
# mplayer
#
################################################################################

MPLAYER_VERSION = 1.2
MPLAYER_SOURCE = MPlayer-$(MPLAYER_VERSION).tar.xz
MPLAYER_SITE = http://www.mplayerhq.hu/MPlayer/releases
MPLAYER_DEPENDENCIES = host-pkgconf
MPLAYER_LICENSE = GPLv2
MPLAYER_LICENSE_FILES = LICENSE Copyright
MPLAYER_CFLAGS = $(TARGET_CFLAGS)
MPLAYER_LDFLAGS = $(TARGET_LDFLAGS)

# mplayer needs pcm+mixer support, but configure fails to check for it
ifeq ($(BR2_PACKAGE_ALSA_LIB)$(BR2_PACKAGE_ALSA_LIB_MIXER)$(BR2_PACKAGE_ALSA_LIB_PCM),yyy)
MPLAYER_DEPENDENCIES += alsa-lib
MPLAYER_CONF_OPTS += --enable-alsa
else
MPLAYER_CONF_OPTS += --disable-alsa
endif

ifeq ($(BR2_ENDIAN),"BIG")
MPLAYER_CONF_OPTS += --enable-big-endian
else
MPLAYER_CONF_OPTS += --disable-big-endian
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
MPLAYER_DEPENDENCIES += zlib
MPLAYER_CONF_OPTS += \
	--enable-decoder=apng \
	--enable-encoder=apng \
	--enable-decoder=tdsc
else
MPLAYER_CONF_OPTS += \
	--disable-decoder=apng \
	--disable-encoder=apng \
	--disable-decoder=tdsc
endif

ifeq ($(BR2_PACKAGE_SDL),y)
MPLAYER_CONF_OPTS += \
	--enable-sdl \
	--with-sdl-config=$(STAGING_DIR)/usr/bin/sdl-config
MPLAYER_DEPENDENCIES += sdl
else
MPLAYER_CONF_OPTS += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
MPLAYER_CONF_OPTS +=  \
	--enable-freetype \
	--with-freetype-config=$(STAGING_DIR)/usr/bin/freetype-config
MPLAYER_DEPENDENCIES += freetype
else
MPLAYER_CONF_OPTS += --disable-freetype
endif

# We intentionally don't pass --enable-fontconfig, to let the
# autodetection find which library to link with.
ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
MPLAYER_DEPENDENCIES += fontconfig
else
MPLAYER_CONF_OPTS += --disable-fontconfig
endif

ifeq ($(BR2_PACKAGE_LIBENCA),y)
MPLAYER_CONF_OPTS += --enable-enca
MPLAYER_DEPENDENCIES += libenca
else
MPLAYER_CONF_OPTS += --disable-enca
endif

# We intentionally don't pass --enable-fribidi, to let the
# autodetection find which library to link with.
ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
MPLAYER_DEPENDENCIES += libfribidi
else
MPLAYER_CONF_OPTS += --disable-fribidi
endif

# We intentionally don't pass --enable-libiconv, to let the
# autodetection find which library to link with.
ifeq ($(BR2_PACKAGE_LIBICONV),y)
MPLAYER_DEPENDENCIES += libiconv
else
MPLAYER_CONF_OPTS += --disable-iconv
endif

# We intentionally don't pass --enable-termcap, in order to let the
# autodetection find with which library to link with. Otherwise, we
# would have to pass it manually.
ifeq ($(BR2_PACKAGE_NCURSES),y)
MPLAYER_DEPENDENCIES += ncurses
else
MPLAYER_CONF_OPTS += --disable-termcap
endif

# mplayer doesn't pick up libsmbclient cflags
ifeq ($(BR2_PACKAGE_SAMBA4),y)
MPLAYER_CFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags smbclient`
MPLAYER_CONF_OPTS += --enable-smb
MPLAYER_DEPENDENCIES += samba4
else
MPLAYER_CONF_OPTS += --disable-smb
endif

ifeq ($(BR2_PACKAGE_LIBBLURAY),y)
MPLAYER_CONF_OPTS += --enable-bluray
MPLAYER_DEPENDENCIES += libbluray
else
MPLAYER_CONF_OPTS += --disable-bluray
endif

# cdio support is broken in buildroot atm due to missing libcdio-paranoia
# package and this patch
# https://github.com/pld-linux/mplayer/blob/master/mplayer-libcdio.patch
MPLAYER_CONF_OPTS += --disable-libcdio

# We intentionally don't pass --enable-dvdread, to let the
# autodetection find which library to link with.
ifeq ($(BR2_PACKAGE_LIBDVDREAD),y)
MPLAYER_CONF_OPTS +=  \
	--with-dvdread-config=$(STAGING_DIR)/usr/bin/dvdread-config
MPLAYER_DEPENDENCIES += libdvdread
endif

# We intentionally don't pass --enable-dvdnav to let the autodetection
# find which library to link with.
ifeq ($(BR2_PACKAGE_LIBDVDNAV),y)
MPLAYER_CONF_OPTS +=  \
	--with-dvdnav-config=$(STAGING_DIR)/usr/bin/dvdnav-config
MPLAYER_DEPENDENCIES += libdvdnav
endif

ifeq ($(BR2_PACKAGE_MPLAYER_MPLAYER),y)
MPLAYER_CONF_OPTS += --enable-mplayer
else
MPLAYER_CONF_OPTS += --disable-mplayer
endif

ifeq ($(BR2_PACKAGE_MPLAYER_MENCODER),y)
MPLAYER_CONF_OPTS += --enable-mencoder
else
MPLAYER_CONF_OPTS += --disable-mencoder
endif

ifeq ($(BR2_PACKAGE_FAAD2),y)
MPLAYER_DEPENDENCIES += faad2
MPLAYER_CONF_OPTS += --enable-faad
else
MPLAYER_CONF_OPTS += --disable-faad
endif

ifeq ($(BR2_PACKAGE_LAME),y)
MPLAYER_DEPENDENCIES += lame
MPLAYER_CONF_OPTS += --enable-mp3lame
else
MPLAYER_CONF_OPTS += --disable-mp3lame
endif

# We intentionally don't pass --disable-ass-internal --enable-ass and
# let autodetection find which library to link with.
ifeq ($(BR2_PACKAGE_LIBASS),y)
MPLAYER_DEPENDENCIES += libass
endif

# We intentionally don't pass --enable-libmpeg2 and let autodetection
# find which library to link with.
ifeq ($(BR2_PACKAGE_LIBMPEG2),y)
MPLAYER_DEPENDENCIES += libmpeg2
MPLAYER_CONF_OPTS += --disable-libmpeg2-internal
endif

ifeq ($(BR2_PACKAGE_TREMOR),y)
MPLAYER_DEPENDENCIES += tremor
MPLAYER_CONF_OPTS += --enable-tremor
endif

# We intentionally don't pass --enable-libvorbis, to let the
# autodetection find which library to link with.
ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
MPLAYER_DEPENDENCIES += libvorbis
endif

ifeq ($(BR2_PACKAGE_LIBMAD),y)
MPLAYER_DEPENDENCIES += libmad
MPLAYER_CONF_OPTS += --enable-mad
else
MPLAYER_CONF_OPTS += --disable-mad
endif

ifeq ($(BR2_PACKAGE_LIVE555),y)
MPLAYER_DEPENDENCIES += live555
MPLAYER_CONF_OPTS += --enable-live
MPLAYER_LIVE555 = liveMedia groupsock UsageEnvironment BasicUsageEnvironment
MPLAYER_CFLAGS += \
	$(addprefix -I$(STAGING_DIR)/usr/include/,$(MPLAYER_LIVE555))
MPLAYER_LDFLAGS += $(addprefix -l,$(MPLAYER_LIVE555)) -lstdc++
else
MPLAYER_CONF_OPTS += --disable-live
endif

ifeq ($(BR2_PACKAGE_GIFLIB),y)
MPLAYER_DEPENDENCIES += giflib
MPLAYER_CONF_OPTS += --enable-gif
else
MPLAYER_CONF_OPTS += --disable-gif
endif

# We intentionally don't pass --enable-librtmp to let autodetection
# find which library to link with.
ifeq ($(BR2_PACKAGE_RTMPDUMP),y)
MPLAYER_DEPENDENCIES += rtmpdump
else
MPLAYER_CONF_OPTS += --disable-librtmp
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
MPLAYER_DEPENDENCIES += speex
MPLAYER_CONF_OPTS += --enable-speex
else
MPLAYER_CONF_OPTS += --disable-speex
endif

ifeq ($(BR2_PACKAGE_LZO),y)
MPLAYER_DEPENDENCIES += lzo
MPLAYER_CONF_OPTS += --enable-liblzo
else
MPLAYER_CONF_OPTS += --disable-liblzo
endif

MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_BZIP2),bzip2)
MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_HAS_LIBGL),libgl)
MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBTHEORA),libtheora)
MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBPNG),libpng)
MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBVPX),libvpx)
MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_JPEG),jpeg)
MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_OPUS),opus)
MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_XLIB_LIBX11),xlib_libX11)
MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_XLIB_LIBXEXT),xlib_libXext)
MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_XLIB_LIBXINERAMA),xlib_libXinerama)
MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_XLIB_LIBXV),xlib_libXv)
MPLAYER_DEPENDENCIES += $(if $(BR2_PACKAGE_XLIB_LIBXXF86VM),xlib_libXxf86vm)

# ARM optimizations
ifeq ($(BR2_ARM_CPU_ARMV5),y)
MPLAYER_CONF_OPTS += --enable-armv5te
endif

ifeq ($(BR2_ARM_CPU_ARMV6)$(BR2_ARM_CPU_ARMV7A),y)
MPLAYER_CONF_OPTS += --enable-armv6
endif

ifeq ($(BR2_ARM_SOFT_FLOAT),)
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
MPLAYER_CONF_OPTS += --enable-neon
MPLAYER_CFLAGS += -mfpu=neon
endif
endif

ifeq ($(BR2_i386),y)
# inline asm breaks with "can't find a register in class 'GENERAL_REGS'"
# inless we free up ebp
MPLAYER_CFLAGS += -fomit-frame-pointer
endif

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
MPLAYER_CONF_OPTS += --yasm=$(HOST_DIR)/usr/bin/yasm
MPLAYER_DEPENDENCIES += host-yasm
else
MPLAYER_CONF_OPTS += --yasm=''
endif

define MPLAYER_CONFIGURE_CMDS
	(cd $(@D); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--prefix=/usr \
		--confdir=/etc \
		--target=$(GNU_TARGET_NAME) \
		--host-cc="$(HOSTCC)" \
		--cc="$(TARGET_CC)" \
		--as="$(TARGET_AS)" \
		--charset=UTF-8 \
		--extra-cflags="$(MPLAYER_CFLAGS)" \
		--extra-ldflags="$(MPLAYER_LDFLAGS)" \
		--enable-fbdev \
		$(MPLAYER_CONF_OPTS) \
		--enable-cross-compile \
		--disable-ivtv \
		--enable-dynamic-plugins \
		--enable-inet6 \
	)
endef

define MPLAYER_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define MPLAYER_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
