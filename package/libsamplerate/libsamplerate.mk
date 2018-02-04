################################################################################
#
# libsamplerate
#
################################################################################

LIBSAMPLERATE_VERSION = 0.1.9
LIBSAMPLERATE_SITE = http://www.mega-nerd.com/SRC
LIBSAMPLERATE_INSTALL_STAGING = YES
LIBSAMPLERATE_DEPENDENCIES = host-pkgconf
LIBSAMPLERATE_CONF_OPTS = --disable-fftw --program-transform-name=''
LIBSAMPLERATE_LICENSE = BSD-2-Clause
LIBSAMPLERATE_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
LIBSAMPLERATE_DEPENDENCIES += alsa-lib
endif

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
LIBSAMPLERATE_DEPENDENCIES += libsndfile
endif

$(eval $(autotools-package))
