################################################################################
#
# libpjsip
#
################################################################################

LIBPJSIP_VERSION = 2.7.1
LIBPJSIP_SOURCE = pjproject-$(LIBPJSIP_VERSION).tar.bz2
LIBPJSIP_SITE = http://www.pjsip.org/release/$(LIBPJSIP_VERSION)
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
	--disable-sound \
	--disable-gsm-codec \
	--disable-speex-codec \
	--disable-speex-aec \
	--disable-resample \
	--disable-video \
	--disable-opencore-amr \
	--disable-g7221-codec \
	--disable-ilbc-codec \
	--disable-libwebrtc \
	--disable-opus \
	--disable-oss \
	--disable-ext-sound \
	--disable-small-filter \
	--disable-large-filter \
	--disable-g711-codec \
	--disable-l16-codec \
	--disable-g722-codec \
	--disable-libsamplerate \
	--disable-sdl \
	--disable-ffmpeg \
	--disable-v4l2 \
	--disable-openh264 \
	--disable-libyuv \
	--disable-ipp \
	--disable-silk \
	--with-external-srtp

# Note: aconfigure.ac is broken: --enable-epoll or --disable-epoll will
# both enable it. But that's OK, epoll is better than the alternative,
# so we want to use it.
LIBPJSIP_CONF_OPTS += --enable-epoll

ifeq ($(BR2_PACKAGE_LIBOPENSSL),y)
LIBPJSIP_DEPENDENCIES += libopenssl
LIBPJSIP_CONF_OPTS += --with-ssl=$(STAGING_DIR)/usr
else
LIBPJSIP_CONF_OPTS += --disable-ssl
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
LIBPJSIP_DEPENDENCIES += util-linux
endif

$(eval $(autotools-package))
