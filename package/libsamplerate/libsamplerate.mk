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

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
LIBSAMPLERATE_DEPENDENCIES += libsndfile
endif

$(eval $(autotools-package))
