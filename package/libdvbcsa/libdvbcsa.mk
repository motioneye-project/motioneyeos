################################################################################
#
# libdvbcsa
#
################################################################################

LIBDVBCSA_VERSION = 1.1.0
LIBDVBCSA_SITE = http://get.videolan.org/libdvbcsa/$(LIBDVBCSA_VERSION)
LIBDVBCSA_LICENSE = GPLv2+
LIBDVBCSA_LICENSE_FILES = COPYING
LIBDVBCSA_INSTALL_STAGING = YES

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
LIBDVBCSA_CONF_OPTS += --enable-mmx
else
LIBDVBCSA_CONF_OPTS += --disable-mmx
endif

ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
LIBDVBCSA_CONF_OPTS += --enable-sse2
else
LIBDVBCSA_CONF_OPTS += --disable-sse2
endif

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
LIBDVBCSA_CONF_OPTS += --enable-altivec
LIBDVBCSA_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -flax-vector-conversions"
else
LIBDVBCSA_CONF_OPTS += --disable-altivec
endif

$(eval $(autotools-package))
