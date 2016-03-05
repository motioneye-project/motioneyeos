################################################################################
#
# mpd
#
################################################################################

MPD_VERSION_MAJOR = 0.19
MPD_VERSION = $(MPD_VERSION_MAJOR).12
MPD_SOURCE = mpd-$(MPD_VERSION).tar.xz
MPD_SITE = http://www.musicpd.org/download/mpd/$(MPD_VERSION_MAJOR)
MPD_DEPENDENCIES = host-pkgconf boost libglib2
MPD_LICENSE = GPLv2+
MPD_LICENSE_FILES = COPYING
MPD_AUTORECONF = YES

# Some options need an explicit --disable or --enable

# Zeroconf support depends on libdns_sd from avahi.
ifeq ($(BR2_PACKAGE_MPD_AVAHI_SUPPORT),y)
MPD_DEPENDENCIES += avahi
MPD_CONF_OPTS += --with-zeroconf=avahi
else
MPD_CONF_OPTS += --with-zeroconf=no
endif

# MPD prefers libicu for utf8 collation instead of libglib2.
ifeq ($(BR2_PACKAGE_ICU),y)
MPD_DEPENDENCIES += icu
MPD_CONF_OPTS += --enable-icu
else
MPD_CONF_OPTS += --disable-icu
endif

ifeq ($(BR2_PACKAGE_MPD_ALSA),y)
MPD_DEPENDENCIES += alsa-lib
MPD_CONF_OPTS += --enable-alsa
else
MPD_CONF_OPTS += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_MPD_AO),y)
MPD_DEPENDENCIES += libao
MPD_CONF_OPTS += --enable-ao
else
MPD_CONF_OPTS += --disable-ao
endif

ifeq ($(BR2_PACKAGE_MPD_AUDIOFILE),y)
MPD_DEPENDENCIES += audiofile
MPD_CONF_OPTS += --enable-audiofile
else
MPD_CONF_OPTS += --disable-audiofile
endif

ifeq ($(BR2_PACKAGE_MPD_BZIP2),y)
MPD_DEPENDENCIES += bzip2
MPD_CONF_OPTS += --enable-bzip2
else
MPD_CONF_OPTS += --disable-bzip2
endif

ifeq ($(BR2_PACKAGE_MPD_CURL),y)
MPD_DEPENDENCIES += libcurl
MPD_CONF_OPTS += --enable-curl
else
MPD_CONF_OPTS += --disable-curl
endif

ifeq ($(BR2_PACKAGE_MPD_DSD),y)
MPD_CONF_OPTS += --enable-dsd
else
MPD_CONF_OPTS += --disable-dsd
endif

ifeq ($(BR2_PACKAGE_MPD_FAAD2),y)
MPD_DEPENDENCIES += faad2
MPD_CONF_OPTS += --enable-aac
else
MPD_CONF_OPTS += --disable-aac
endif

ifeq ($(BR2_PACKAGE_MPD_FFMPEG),y)
MPD_DEPENDENCIES += ffmpeg
MPD_CONF_OPTS += --enable-ffmpeg
else
MPD_CONF_OPTS += --disable-ffmpeg
endif

ifeq ($(BR2_PACKAGE_MPD_FLAC),y)
MPD_DEPENDENCIES += flac
MPD_CONF_OPTS += --enable-flac
else
MPD_CONF_OPTS += --disable-flac
endif

ifeq ($(BR2_PACKAGE_MPD_HTTPD_OUTPUT),y)
MPD_CONF_OPTS += --enable-httpd-output
else
MPD_CONF_OPTS += --disable-httpd-output
endif

ifeq ($(BR2_PACKAGE_MPD_JACK2),y)
MPD_DEPENDENCIES += jack2
MPD_CONF_OPTS += --enable-jack
else
MPD_CONF_OPTS += --disable-jack
endif

ifeq ($(BR2_PACKAGE_MPD_LAME),y)
MPD_DEPENDENCIES += lame
MPD_CONF_OPTS += --enable-lame-encoder
else
MPD_CONF_OPTS += --disable-lame-encoder
endif

ifeq ($(BR2_PACKAGE_MPD_LIBNFS),y)
MPD_DEPENDENCIES += libnfs
MPD_CONF_OPTS += --enable-nfs
else
MPD_CONF_OPTS += --disable-nfs
endif

ifeq ($(BR2_PACKAGE_MPD_LIBSMBCLIENT),y)
MPD_DEPENDENCIES += samba4
MPD_CONF_OPTS += --enable-smbclient
else
MPD_CONF_OPTS += --disable-smbclient
endif

ifeq ($(BR2_PACKAGE_MPD_LIBSAMPLERATE),y)
MPD_DEPENDENCIES += libsamplerate
MPD_CONF_OPTS += --enable-lsr
else
MPD_CONF_OPTS += --disable-lsr
endif

ifeq ($(BR2_PACKAGE_MPD_LIBSNDFILE),y)
MPD_DEPENDENCIES += libsndfile
MPD_CONF_OPTS += --enable-sndfile
else
MPD_CONF_OPTS += --disable-sndfile
endif

ifeq ($(BR2_PACKAGE_MPD_LIBSOXR),y)
MPD_DEPENDENCIES += libsoxr
MPD_CONF_OPTS += --enable-soxr
else
MPD_CONF_OPTS += --disable-soxr
endif

ifeq ($(BR2_PACKAGE_MPD_MAD),y)
MPD_DEPENDENCIES += libid3tag libmad
MPD_CONF_OPTS += --enable-mad
else
MPD_CONF_OPTS += --disable-mad
endif

ifeq ($(BR2_PACKAGE_MPD_MPG123),y)
MPD_DEPENDENCIES += libid3tag mpg123
MPD_CONF_OPTS += --enable-mpg123
else
MPD_CONF_OPTS += --disable-mpg123
endif

ifeq ($(BR2_PACKAGE_MPD_MUSEPACK),y)
MPD_DEPENDENCIES += musepack
MPD_CONF_OPTS += --enable-mpc
else
MPD_CONF_OPTS += --disable-mpc
endif

ifeq ($(BR2_PACKAGE_MPD_NEIGHBOR_DISCOVERY_SUPPORT),y)
MPD_CONF_OPTS += --enable-neighbor-plugins
else
MPD_CONF_OPTS += --disable-neighbor-plugins
endif

ifeq ($(BR2_PACKAGE_MPD_OPUS),y)
MPD_DEPENDENCIES += opus libogg
MPD_CONF_OPTS += --enable-opus
else
MPD_CONF_OPTS += --disable-opus
endif

ifeq ($(BR2_PACKAGE_MPD_OSS),y)
MPD_CONF_OPTS += --enable-oss
else
MPD_CONF_OPTS += --disable-oss
endif

ifeq ($(BR2_PACKAGE_MPD_PULSEAUDIO),y)
MPD_DEPENDENCIES += pulseaudio
MPD_CONF_OPTS += --enable-pulse
else
MPD_CONF_OPTS += --disable-pulse
endif

ifeq ($(BR2_PACKAGE_MPD_SOUNDCLOUD),y)
MPD_DEPENDENCIES += yajl
MPD_CONF_OPTS += --enable-soundcloud
else
MPD_CONF_OPTS += --disable-soundcloud
endif

ifeq ($(BR2_PACKAGE_MPD_SQLITE),y)
MPD_DEPENDENCIES += sqlite
MPD_CONF_OPTS += --enable-sqlite
else
MPD_CONF_OPTS += --disable-sqlite
endif

ifneq ($(BR2_PACKAGE_MPD_TCP),y)
MPD_CONF_OPTS += --disable-tcp
endif

ifeq ($(BR2_PACKAGE_MPD_TREMOR),y)
MPD_DEPENDENCIES += tremor
MPD_CONF_OPTS += --with-tremor
endif

ifeq ($(BR2_PACKAGE_MPD_TWOLAME),y)
MPD_DEPENDENCIES += twolame
MPD_CONF_OPTS += --enable-twolame-encoder
else
MPD_CONF_OPTS += --disable-twolame-encoder
endif

ifeq ($(BR2_PACKAGE_MPD_UPNP),y)
MPD_DEPENDENCIES += expat libupnp
MPD_CONF_OPTS += --enable-upnp
else
MPD_CONF_OPTS += --disable-upnp
endif

ifeq ($(BR2_PACKAGE_MPD_VORBIS),y)
MPD_DEPENDENCIES += libvorbis
MPD_CONF_OPTS += --enable-vorbis --enable-vorbis-encoder
else
MPD_CONF_OPTS += --disable-vorbis --disable-vorbis-encoder
endif

ifeq ($(BR2_PACKAGE_MPD_WAVPACK),y)
MPD_DEPENDENCIES += wavpack
MPD_CONF_OPTS += --enable-wavpack
else
MPD_CONF_OPTS += --disable-wavpack
endif

define MPD_INSTALL_EXTRA_FILES
	$(INSTALL) -m 0644 -D package/mpd/mpd.conf $(TARGET_DIR)/etc/mpd.conf
endef

MPD_POST_INSTALL_TARGET_HOOKS += MPD_INSTALL_EXTRA_FILES

define MPD_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/mpd/S95mpd \
		$(TARGET_DIR)/etc/init.d/S95mpd
endef

$(eval $(autotools-package))
