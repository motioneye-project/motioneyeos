################################################################################
#
# fftw-double
#
################################################################################

FFTW_DOUBLE_VERSION = $(FFTW_VERSION)
FFTW_DOUBLE_SOURCE = fftw-$(FFTW_VERSION).tar.gz
FFTW_DOUBLE_SITE = $(FFTW_SITE)
FFTW_DOUBLE_DL_SUBDIR = fftw
FFTW_DOUBLE_INSTALL_STAGING = $(FFTW_INSTALL_STAGING)
FFTW_DOUBLE_LICENSE = $(FFTW_LICENSE)
FFTW_DOUBLE_LICENSE_FILES = $(FFTW_LICENSE_FILES)

FFTW_DOUBLE_CONF_ENV = $(FFTW_COMMON_CONF_ENV)

FFTW_DOUBLE_CONF_OPTS = \
	$(FFTW_COMMON_CONF_OPTS) \
	CFLAGS="$(FFTW_COMMON_CFLAGS)" \
	$(if $(BR2_X86_CPU_HAS_SSE2),--enable,--disable)-sse2

$(eval $(autotools-package))
