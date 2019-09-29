################################################################################
#
# fftw-quad
#
################################################################################

FFTW_QUAD_VERSION = $(FFTW_VERSION)
FFTW_QUAD_SOURCE = fftw-$(FFTW_VERSION).tar.gz
FFTW_QUAD_SITE = $(FFTW_SITE)
FFTW_QUAD_DL_SUBDIR = fftw
FFTW_QUAD_INSTALL_STAGING = $(FFTW_INSTALL_STAGING)
FFTW_QUAD_LICENSE = $(FFTW_LICENSE)
FFTW_QUAD_LICENSE_FILES = $(FFTW_LICENSE_FILES)

FFTW_QUAD_CONF_ENV = $(FFTW_COMMON_CONF_ENV)

FFTW_QUAD_CONF_OPTS = \
	$(FFTW_COMMON_CONF_OPTS) \
	CFLAGS="$(FFTW_COMMON_CFLAGS)" \
	--enable-quad-precision

$(eval $(autotools-package))
