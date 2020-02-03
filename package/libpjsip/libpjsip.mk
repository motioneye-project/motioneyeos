################################################################################
#
# libpjsip
#
################################################################################

LIBPJSIP_VERSION = 2.9
LIBPJSIP_SOURCE = pjproject-$(LIBPJSIP_VERSION).tar.bz2
LIBPJSIP_SITE = https://www.pjsip.org/release/$(LIBPJSIP_VERSION)
LIBPJSIP_DEPENDENCIES = libsrtp
LIBPJSIP_LICENSE = GPL-2.0+
LIBPJSIP_LICENSE_FILES = COPYING
LIBPJSIP_INSTALL_STAGING = YES
LIBPJSIP_MAKE = $(MAKE1)

LIBPJSIP_CFLAGS = $(TARGET_CFLAGS) -DPJ_HAS_IPV6=1

# relocation truncated to fit: R_68K_GOT16O
ifeq ($(BR2_m68k_cf),y)
LIBPJSIP_CFLAGS += -mxgot
endif

LIBPJSIP_CONF_ENV = \
	LD="$(TARGET_CC)" \
	CFLAGS="$(LIBPJSIP_CFLAGS)"

LIBPJSIP_CONF_OPTS = \
	--disable-resample \
	--disable-g7221-codec \
	--disable-ilbc-codec \
	--disable-libwebrtc \
	--disable-ext-sound \
	--disable-g711-codec \
	--disable-l16-codec \
	--disable-g722-codec \
	--disable-ipp \
	--disable-silk \
	--with-external-srtp

# Note: aconfigure.ac is broken: --enable-epoll or --disable-epoll will
# both enable it. But that's OK, epoll is better than the alternative,
# so we want to use it.
LIBPJSIP_CONF_OPTS += --enable-epoll

ifeq ($(BR2_PACKAGE_ALSA_LIB_MIXER),y)
LIBPJSIP_DEPENDENCIES += alsa-lib
LIBPJSIP_CONF_OPTS += --enable-sound
else
LIBPJSIP_CONF_OPTS += --disable-sound
endif

ifeq ($(BR2_PACKAGE_BCG729),y)
LIBPJSIP_DEPENDENCIES += bcg729
LIBPJSIP_CONF_OPTS += --with-bcg729=$(STAGING_DIR)/usr
else
LIBPJSIP_CONF_OPTS += --disable-bcg729
endif

ifeq ($(BR2_PACKAGE_FFMPEG),y)
LIBPJSIP_DEPENDENCIES += ffmpeg
LIBPJSIP_CONF_OPTS += --with-ffmpeg=$(STAGING_DIR)/usr
else
LIBPJSIP_CONF_OPTS += --disable-ffmpeg
endif

ifeq ($(BR2_PACKAGE_LIBGSM),y)
LIBPJSIP_CONF_OPTS += \
	--enable-gsm-codec \
	--with-external-gsm
LIBPJSIP_DEPENDENCIES += libgsm
else
LIBPJSIP_CONF_OPTS += \
	--disable-gsm-codec
endif

ifeq ($(BR2_PACKAGE_LIBOPENH264),y)
LIBPJSIP_DEPENDENCIES += libopenh264
LIBPJSIP_CONF_OPTS += --with-openh264=$(STAGING_DIR)/usr
else
LIBPJSIP_CONF_OPTS += --disable-openh264
endif

ifeq ($(BR2_PACKAGE_LIBOPENSSL),y)
LIBPJSIP_DEPENDENCIES += libopenssl
LIBPJSIP_CONF_OPTS += --with-ssl=$(STAGING_DIR)/usr
else ifeq ($(BR2_PACKAGE_GNUTLS),y)
LIBPJSIP_DEPENDENCIES += gnutls
LIBPJSIP_CONF_OPTS += --with-gnutls=$(STAGING_DIR)/usr
else
LIBPJSIP_CONF_OPTS += --disable-ssl
endif

ifeq ($(BR2_PACKAGE_LIBSAMPLERATE),y)
LIBPJSIP_DEPENDENCIES += libsamplerate
LIBPJSIP_CONF_OPTS += --enable-libsamplerate
else
LIBPJSIP_CONF_OPTS += --disable-libsamplerate
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
# --enable-v4l2 is broken (check for libv4l2 will be omitted)
LIBPJSIP_DEPENDENCIES += libv4l
else
LIBPJSIP_CONF_OPTS += --disable-v4l2
endif

ifeq ($(BR2_PACKAGE_LIBYUV),y)
LIBPJSIP_DEPENDENCIES += libyuv
LIBPJSIP_CONF_OPTS += \
	--enable-libyuv \
	--with-external-yuv
else
LIBPJSIP_CONF_OPTS += --disable-libyuv
endif

ifeq ($(BR2_PACKAGE_OPENCORE_AMR),y)
LIBPJSIP_DEPENDENCIES += opencore-amr
LIBPJSIP_CONF_OPTS += --with-opencore-amr=$(STAGING_DIR)/usr
else
LIBPJSIP_CONF_OPTS += --disable-opencore-amr
endif

ifeq ($(BR2_PACKAGE_OPUS),y)
LIBPJSIP_DEPENDENCIES += opus
LIBPJSIP_CONF_OPTS += --with-opus=$(STAGING_DIR)/usr
else
LIBPJSIP_CONF_OPTS += --disable-opus
endif

ifeq ($(BR2_PACKAGE_PORTAUDIO),y)
LIBPJSIP_DEPENDENCIES += portaudio
LIBPJSIP_CONF_OPTS += --with-external-pa
else
LIBPJSIP_CONF_OPTS += --without-external-pa
endif

ifeq ($(BR2_PACKAGE_SDL2),y)
LIBPJSIP_DEPENDENCIES += sdl2
LIBPJSIP_CONF_OPTS += --with-sdl=$(STAGING_DIR)/usr
else
LIBPJSIP_CONF_OPTS += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_SPEEX)$(BR2_PACKAGE_SPEEXDSP),yy)
LIBPJSIP_CONF_OPTS += \
	--enable-speex-aec \
	--enable-speex-codec \
	--with-external-speex
LIBPJSIP_DEPENDENCIES += speex speexdsp
else
LIBPJSIP_CONF_OPTS += \
	--disable-speex-aec \
	--disable-speex-codec
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
LIBPJSIP_DEPENDENCIES += util-linux
endif

# disable build of test binaries
LIBPJSIP_MAKE_OPTS = lib

$(eval $(autotools-package))
