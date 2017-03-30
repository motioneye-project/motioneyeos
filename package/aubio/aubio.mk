################################################################################
#
# aubio
#
################################################################################

AUBIO_VERSION = 0.4.3
AUBIO_SITE = https://aubio.org/pub
AUBIO_SOURCE = aubio-$(AUBIO_VERSION).tar.bz2
AUBIO_LICENSE = GPL-3.0+
AUBIO_LICENSE_FILES = COPYING
AUBIO_INSTALL_STAGING = YES

AUBIO_CONF_OPTS = \
	--disable-docs \
	--disable-atlas

# Add --notests for each build step to avoid running unit tests on the
# build machine.
AUBIO_WAF_OPTS = --notests

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

ifeq ($(BR2_PACKAGE_JACK2),y)
AUBIO_DEPENDENCIES += jack2
AUBIO_CONF_OPTS += --enable-jack
else
AUBIO_CONF_OPTS += --disable-jack
endif

ifeq ($(BR2_PACKAGE_FFTW),y)
AUBIO_DEPENDENCIES += fftw
# fftw3 require double otherwise it will look for fftw3f
ifeq ($(BR2_PACKAGE_FFTW_PRECISION_DOUBLE),y)
AUBIO_CONF_OPTS += --enable-fftw3 --enable-double
else ifeq ($(BR2_PACKAGE_FFTW_PRECISION_SINGLE),y)
AUBIO_CONF_OPTS += --enable-fftw3f --disable-double
endif
else  # !BR2_PACKAGE_FFTW
AUBIO_CONF_OPTS += --disable-fftw3
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AVRESAMPLE),y)
AUBIO_DEPENDENCIES += ffmpeg
AUBIO_CONF_OPTS += --enable-avcodec
else
AUBIO_CONF_OPTS += --disable-avcodec
endif

$(eval $(waf-package))
