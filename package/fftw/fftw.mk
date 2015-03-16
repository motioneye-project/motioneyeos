################################################################################
#
# fftw
#
################################################################################

FFTW_VERSION = 3.3.4
FFTW_SITE = http://www.fftw.org
FFTW_INSTALL_STAGING = YES
FFTW_LICENSE = GPLv2+
FFTW_LICENSE_FILES = COPYING

FFTW_CONF_OPTS += $(if $(BR2_PACKAGE_FFTW_PRECISION_SINGLE),--enable,--disable)-single
FFTW_CONF_OPTS += $(if $(BR2_PACKAGE_FFTW_PRECISION_LONG_DOUBLE),--enable,--disable)-long-double
FFTW_CONF_OPTS += $(if $(BR2_PACKAGE_FFTW_PRECISION_QUAD),--enable,--disable)-quad-precision

FFTW_CFLAGS = $(TARGET_CFLAGS)
ifeq ($(BR2_PACKAGE_FFTW_FAST),y)
FFTW_CFLAGS += -Ofast
endif

# x86 optimisations
FFTW_CONF_OPTS += $(if $(BR2_PACKAGE_FFTW_USE_SSE),--enable,--disable)-sse
FFTW_CONF_OPTS += $(if $(BR2_PACKAGE_FFTW_USE_SSE2),--enable,--disable)-sse2

FFTW_CONF_OPTS += CFLAGS="$(FFTW_CFLAGS)"

$(eval $(autotools-package))
