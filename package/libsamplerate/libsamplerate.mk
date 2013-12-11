################################################################################
#
# libsamplerate
#
################################################################################

LIBSAMPLERATE_VERSION = 0.1.8
LIBSAMPLERATE_SITE = http://www.mega-nerd.com/SRC
LIBSAMPLERATE_INSTALL_STAGING = YES
LIBSAMPLERATE_DEPENDENCIES = host-pkgconf
LIBSAMPLERATE_CONF_OPT = --disable-fftw --program-transform-name=''
LIBSAMPLERATE_LICENSE = Dual GPLv2+ / libsamplerate commercial use license
LIBSAMPLERATE_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
LIBSAMPLERATE_DEPENDENCIES += libsndfile
endif

$(eval $(autotools-package))
