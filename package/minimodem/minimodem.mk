################################################################################
#
# minimodem
#
################################################################################

MINIMODEM_VERSION = 0.24
MINIMODEM_SITE = http://www.whence.com/minimodem
MINIMODEM_LICENSE = GPL-3.0+
MINIMODEM_LICENSE_FILES = COPYING

MINIMODEM_DEPENDENCIES = fftw-single host-pkgconf

ifeq ($(BR2_PACKAGE_ALSA_LIB_PCM),y)
MINIMODEM_DEPENDENCIES += alsa-lib
MINIMODEM_CONF_OPTS += --with-alsa
else
MINIMODEM_CONF_OPTS += --without-alsa
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
MINIMODEM_DEPENDENCIES += pulseaudio
MINIMODEM_CONF_OPTS += --with-pulseaudio
else
MINIMODEM_CONF_OPTS += --without-pulseaudio
endif

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
MINIMODEM_DEPENDENCIES += libsndfile
MINIMODEM_CONF_OPTS += --with-sndfile
else
MINIMODEM_CONF_OPTS += --without-sndfile
endif

$(eval $(autotools-package))
