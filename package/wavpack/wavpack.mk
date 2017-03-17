################################################################################
#
# wavpack
#
################################################################################

WAVPACK_VERSION = 5.1.0
WAVPACK_SITE = http://www.wavpack.com
WAVPACK_SOURCE = wavpack-$(WAVPACK_VERSION).tar.bz2
WAVPACK_INSTALL_STAGING = YES
WAVPACK_DEPENDENCIES = $(if $(BR2_ENABLE_LOCALE),,libiconv)
WAVPACK_LICENSE = BSD-3c
WAVPACK_LICENSE_FILES = COPYING

# Fetch patch from upstream to remove wchar dependency
WAVPACK_PATCH = https://github.com/dbry/WavPack/commit/876fc3f3907e871d0938ac6c8c5252f5f31abd1f.patch

ifeq ($(BR2_PACKAGE_LIBICONV),y)
WAVPACK_CONF_OPTS += LIBS=-liconv
endif

# WavPack "autodetects" CPU type to enable ASM code. However, the assembly code
# for ARM is written for ARMv7 only and building WavPack for an ARM-non-v7
# architecture will fail. We explicitly enable ASM for the supported
# architectures x86, x64 and ARMv7 and disable it for all others.
ifeq ($(BR2_i386)$(BR2_x86_64)$(BR2_ARM_CPU_ARMV7A),y)
WAVPACK_CONF_OPTS += --enable-asm
else
WAVPACK_CONF_OPTS += --disable-asm
endif

$(eval $(autotools-package))
