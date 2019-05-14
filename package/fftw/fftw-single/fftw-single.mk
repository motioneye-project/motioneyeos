################################################################################
#
# fftw-single
#
################################################################################

FFTW_SINGLE_VERSION = $(FFTW_VERSION)
FFTW_SINGLE_SOURCE = fftw-$(FFTW_VERSION).tar.gz
FFTW_SINGLE_SITE = $(FFTW_SITE)
FFTW_SINGLE_DL_SUBDIR = fftw
FFTW_SINGLE_INSTALL_STAGING = $(FFTW_INSTALL_STAGING)
FFTW_SINGLE_LICENSE = $(FFTW_LICENSE)
FFTW_SINGLE_LICENSE_FILES = $(FFTW_LICENSE_FILES)

FFTW_SINGLE_CONF_ENV = $(FFTW_COMMON_CONF_ENV)

FFTW_SINGLE_CONF_OPTS = \
	$(FFTW_COMMON_CONF_OPTS) \
	CFLAGS="$(FFTW_SINGLE_CFLAGS)" \
	--enable-single

FFTW_SINGLE_CFLAGS = $(FFTW_COMMON_CFLAGS)

# x86 optimisations
FFTW_SINGLE_CONF_OPTS += \
	$(if $(BR2_X86_CPU_HAS_SSE),--enable,--disable)-sse \
	$(if $(BR2_X86_CPU_HAS_SSE2),--enable,--disable)-sse2

# ARM optimisations
ifeq ($(BR2_ARM_CPU_HAS_NEON):$(BR2_ARM_SOFT_FLOAT),y:)
FFTW_SINGLE_CONF_OPTS += --enable-neon
FFTW_SINGLE_CFLAGS += -mfpu=neon
else
FFTW_SINGLE_CONF_OPTS += --disable-neon
endif

$(eval $(autotools-package))
