################################################################################
#
# liquid-dsp
#
################################################################################

LIQUID_DSP_VERSION = 1191179b786703b3af20abf7e1404d91099b335d
LIQUID_DSP_SITE = $(call github,jgaeddert,liquid-dsp,$(LIQUID_DSP_VERSION))
LIQUID_DSP_LICENSE = MIT
LIQUID_DSP_LICENSE_FILES = LICENSE
LIQUID_DSP_INSTALL_STAGING = YES
LIQUID_DSP_AUTORECONF = YES

LIQUID_DSP_CONF_ENV = \
	ax_cv_have_mmx_ext=$(if $(BR2_X86_CPU_HAS_MMX),yes,no) \
	ax_cv_have_sse_ext=$(if $(BR2_X86_CPU_HAS_SSE),yes,no) \
	ax_cv_have_sse2_ext=$(if $(BR2_X86_CPU_HAS_SSE2),yes,no) \
	ax_cv_have_sse3_ext=$(if $(BR2_X86_CPU_HAS_SSE3),yes,no) \
	ax_cv_have_ssse3_ext=$(if $(BR2_X86_CPU_HAS_SSSE3),yes,no) \
	ax_cv_have_sse41_ext=$(if $(BR2_X86_CPU_HAS_SSE4),yes,no) \
	ax_cv_have_sse42_ext=$(if $(BR2_X86_CPU_HAS_SSE42),yes,no) \
	ax_cv_have_avx_ext=$(if $(BR2_X86_CPU_HAS_AVX),yes,no)

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

# disable altivec, it has build issues
ifeq ($(BR2_powerpc)$(BR2_powerpc64),y)
LIQUID_DSP_CONF_OPTS += --enable-simdoverride
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
