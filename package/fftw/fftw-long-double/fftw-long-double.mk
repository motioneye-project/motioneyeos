################################################################################
#
# fftw-long-double
#
################################################################################

FFTW_LONG_DOUBLE_VERSION = $(FFTW_VERSION)
FFTW_LONG_DOUBLE_SOURCE = fftw-$(FFTW_VERSION).tar.gz
FFTW_LONG_DOUBLE_SITE = $(FFTW_SITE)
FFTW_LONG_DOUBLE_DL_SUBDIR = fftw
FFTW_LONG_DOUBLE_INSTALL_STAGING = $(FFTW_INSTALL_STAGING)
FFTW_LONG_DOUBLE_LICENSE = $(FFTW_LICENSE)
FFTW_LONG_DOUBLE_LICENSE_FILES = $(FFTW_LICENSE_FILES)

FFTW_LONG_DOUBLE_CONF_ENV = $(FFTW_COMMON_CONF_ENV)

FFTW_LONG_DOUBLE_CONF_OPTS = \
	$(FFTW_COMMON_CONF_OPTS) \
	CFLAGS="$(FFTW_COMMON_CFLAGS)" \
	--enable-long-double

$(eval $(autotools-package))
