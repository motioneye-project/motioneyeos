################################################################################
#
# fftw
#
################################################################################

FFTW_VERSION = 3.3.8
FFTW_SITE = http://www.fftw.org
FFTW_INSTALL_STAGING = YES
FFTW_LICENSE = GPL-2.0+
FFTW_LICENSE_FILES = COPYING

# fortran support only enables generation and installation of fortran sources
ifeq ($(BR2_TOOLCHAIN_HAS_FORTRAN),y)
FFTW_COMMON_CONF_OPTS += --enable-fortran
FFTW_COMMON_CONF_ENV += FLIBS="-lgfortran -lm"
else
FFTW_COMMON_CONF_OPTS += --disable-fortran
endif

FFTW_COMMON_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_PACKAGE_FFTW_FAST),y)
FFTW_COMMON_CFLAGS += -O3 -ffast-math
endif

# Generic optimisations
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
FFTW_COMMON_CONF_OPTS += --enable-threads
FFTW_COMMON_CONF_OPTS += $(if $(BR2_TOOLCHAIN_HAS_OPENMP),--without,--with)-combined-threads
else
FFTW_COMMON_CONF_OPTS += --disable-threads
endif
FFTW_COMMON_CONF_OPTS += $(if $(BR2_TOOLCHAIN_HAS_OPENMP),--enable,--disable)-openmp

include $(sort $(wildcard package/fftw/*/*.mk))
