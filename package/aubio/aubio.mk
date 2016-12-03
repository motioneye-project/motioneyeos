################################################################################
#
# aubio
#
################################################################################

AUBIO_VERSION = 0.4.3
AUBIO_SITE = https://aubio.org/pub
AUBIO_SOURCE = aubio-$(AUBIO_VERSION).tar.bz2
AUBIO_LICENSE = GPLv3+
AUBIO_LICENSE_FILES = COPYING
AUBIO_INSTALL_STAGING = YES

AUBIO_CONF_OPTS = \
	--disable-docs \
	--disable-atlas \
	--disable-avcodec \
	--disable-jack \
	--disable-fftw3 \
	--disable-fftw3f

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
AUBIO_DEPENDENCIES += libsndfile
AUBIO_CONF_OPTS += --enable-sndfile
else
AUBIO_CONF_OPTS += --disable-sndfile
endif

ifeq ($(BR2_PACKAGE_LIBSAMPLERATE),y)
AUBIO_DEPENDENCIES += libsamplerate
AUBIO_CONF_OPTS += --enable-samplerate
else
AUBIO_CONF_OPTS += --disable-samplerate
endif

$(eval $(waf-package))
