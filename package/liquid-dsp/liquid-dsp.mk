################################################################################
#
# liquid-dsp
#
################################################################################

LIQUID_DSP_VERSION = df5a459fa05dba4199c1299555891104cc1fdca7
LIQUID_DSP_SITE = $(call github,jgaeddert,liquid-dsp,$(LIQUID_DSP_VERSION))
LIQUID_DSP_LICENSE = MIT
LIQUID_DSP_LICENSE_FILES = COPYING
LIQUID_DSP_INSTALL_STAGING = YES
LIQUID_DSP_AUTORECONF = YES

LIQUID_DSP_CFLAGS = $(TARGET_CFLAGS)
LIQUID_DSP_LDFLAGS = $(TARGET_LDFLAGS)

# Speed over accuracy trade off
ifeq ($(BR2_PACKAGE_LIQUID_DSP_FAST),y)
LIQUID_DSP_CFLAGS += -ffast-math
endif

# use FFTW instead of built-in FFT
ifeq ($(BR2_PACKAGE_FFTW_PRECISION_SINGLE),y)
LIQUID_DSP_LDFLAGS += -lfftw3f
endif

ifeq ($(BR2_PACKAGE_FFTW_PRECISION_DOUBLE),y)
LIQUID_DSP_LDFLAGS += -lfftw3
endif

ifeq ($(BR2_PACKAGE_FFTW_PRECISION_LONG_DOUBLE),y)
LIQUID_DSP_LDFLAGS += -lfftw3l
endif

LIQUID_DSP_CONF_OPTS += \
	CFLAGS="$(LIQUID_DSP_CFLAGS)" \
	LDFLAGS="$(LIQUID_DSP_LDFLAGS)"

$(eval $(autotools-package))
