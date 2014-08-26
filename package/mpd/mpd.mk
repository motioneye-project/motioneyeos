################################################################################
#
# mpd
#
################################################################################

MPD_VERSION_MAJOR = 0.18
MPD_VERSION = $(MPD_VERSION_MAJOR).12
MPD_SOURCE = mpd-$(MPD_VERSION).tar.xz
MPD_SITE = http://www.musicpd.org/download/mpd/$(MPD_VERSION_MAJOR)
MPD_DEPENDENCIES = host-pkgconf libglib2
MPD_LICENSE = GPLv2+
MPD_LICENSE_FILES = COPYING

# Some options need an explicit --disable or --enable
ifeq ($(BR2_PACKAGE_AVAHI_DAEMON),y)
MPD_DEPENDENCIES += avahi
else
MPD_CONF_OPT += --with-zeroconf=no
endif

ifeq ($(BR2_PACKAGE_MPD_ALSA),y)
MPD_DEPENDENCIES += alsa-lib
MPD_CONF_OPT += --enable-alsa
else
MPD_CONF_OPT += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_MPD_AO),y)
MPD_DEPENDENCIES += libao
MPD_CONF_OPT += --enable-ao
else
MPD_CONF_OPT += --disable-ao
endif

ifeq ($(BR2_PACKAGE_MPD_AUDIOFILE),y)
MPD_DEPENDENCIES += audiofile
MPD_CONF_OPT += --enable-audiofile
else
MPD_CONF_OPT += --disable-audiofile
endif

ifeq ($(BR2_PACKAGE_MPD_PULSEAUDIO),y)
MPD_DEPENDENCIES += pulseaudio
MPD_CONF_OPT += --enable-pulse
else
MPD_CONF_OPT += --disable-pulse
endif

ifeq ($(BR2_PACKAGE_MPD_BZIP2),y)
MPD_DEPENDENCIES += bzip2
MPD_CONF_OPT += --enable-bzip2
else
MPD_CONF_OPT += --disable-bzip2
endif

ifeq ($(BR2_PACKAGE_MPD_FAAD2),y)
MPD_DEPENDENCIES += faad2
MPD_CONF_OPT += --enable-aac
else
MPD_CONF_OPT += --disable-aac
endif

ifeq ($(BR2_PACKAGE_MPD_FLAC),y)
MPD_DEPENDENCIES += flac
MPD_CONF_OPT += --enable-flac
else
MPD_CONF_OPT += --disable-flac
endif

ifeq ($(BR2_PACKAGE_MPD_CURL),y)
MPD_DEPENDENCIES += libcurl
MPD_CONF_OPT += --enable-curl
else
MPD_CONF_OPT += --disable-curl
endif

ifeq ($(BR2_PACKAGE_MPD_LAME),y)
MPD_DEPENDENCIES += lame
MPD_CONF_OPT += --enable-lame-encoder
else
MPD_CONF_OPT += --disable-lame-encoder
endif

ifeq ($(BR2_PACKAGE_MPD_LIBSAMPLERATE),y)
MPD_DEPENDENCIES += libsamplerate
MPD_CONF_OPT += --enable-lsr
else
MPD_CONF_OPT += --disable-lsr
endif

ifeq ($(BR2_PACKAGE_MPD_LIBSNDFILE),y)
MPD_DEPENDENCIES += libsndfile
MPD_CONF_OPT += --enable-sndfile
else
MPD_CONF_OPT += --disable-sndfile
endif

ifeq ($(BR2_PACKAGE_MPD_OPUS),y)
MPD_DEPENDENCIES += opus libogg
MPD_CONF_OPT += --enable-opus
else
MPD_CONF_OPT += --disable-opus
endif

ifeq ($(BR2_PACKAGE_MPD_VORBIS),y)
MPD_DEPENDENCIES += libvorbis
MPD_CONF_OPT += --enable-vorbis --enable-vorbis-encoder
else
MPD_CONF_OPT += --disable-vorbis --disable-vorbis-encoder
endif

ifeq ($(BR2_PACKAGE_MPD_MAD),y)
MPD_DEPENDENCIES += libid3tag libmad
MPD_CONF_OPT += --enable-mad
else
MPD_CONF_OPT += --disable-mad
endif

ifeq ($(BR2_PACKAGE_MPD_MPG123),y)
MPD_DEPENDENCIES += libid3tag mpg123
MPD_CONF_OPT += --enable-mpg123
else
MPD_CONF_OPT += --disable-mpg123
endif

ifeq ($(BR2_PACKAGE_MPD_MUSEPACK),y)
MPD_DEPENDENCIES += musepack
MPD_CONF_OPT += --enable-mpc
else
MPD_CONF_OPT += --disable-mpc
endif

ifeq ($(BR2_PACKAGE_MPD_SOUNDCLOUD),y)
MPD_DEPENDENCIES += yajl
MPD_CONF_OPT += --enable-soundcloud
else
MPD_CONF_OPT += --disable-soundcloud
endif

ifeq ($(BR2_PACKAGE_MPD_SQLITE),y)
MPD_DEPENDENCIES += sqlite
MPD_CONF_OPT += --enable-sqlite
else
MPD_CONF_OPT += --disable-sqlite
endif

ifneq ($(BR2_PACKAGE_MPD_TCP),y)
MPD_CONF_OPT += --disable-tcp
endif

ifeq ($(BR2_PACKAGE_MPD_TREMOR),y)
MPD_DEPENDENCIES += tremor
MPD_CONF_OPT += --with-tremor
endif

ifeq ($(BR2_PACKAGE_MPD_TWOLAME),y)
MPD_DEPENDENCIES += twolame
MPD_CONF_OPT += --enable-twolame-encoder
else
MPD_CONF_OPT += --disable-twolame-encoder
endif

ifeq ($(BR2_PACKAGE_MPD_WAVPACK),y)
MPD_DEPENDENCIES += wavpack
MPD_CONF_OPT += --enable-wavpack
else
MPD_CONF_OPT += --disable-wavpack
endif

ifeq ($(BR2_PACKAGE_MPD_FFMPEG),y)
MPD_DEPENDENCIES += ffmpeg
MPD_CONF_OPT += --enable-ffmpeg
else
MPD_CONF_OPT += --disable-ffmpeg
endif

define MPD_INSTALL_EXTRA_FILES
	@if [ ! -f $(TARGET_DIR)/etc/mpd.conf ]; then \
		$(INSTALL) -D package/mpd/mpd.conf \
			$(TARGET_DIR)/etc/mpd.conf; \
	fi
	$(INSTALL) -m 0755 -D package/mpd/S95mpd \
		$(TARGET_DIR)/etc/init.d/S95mpd
endef

MPD_POST_INSTALL_TARGET_HOOKS += MPD_INSTALL_EXTRA_FILES

$(eval $(autotools-package))
