################################################################################
#
# gmp
#
################################################################################

GMP_VERSION = 6.1.2
GMP_SITE = $(BR2_GNU_MIRROR)/gmp
GMP_SOURCE = gmp-$(GMP_VERSION).tar.xz
GMP_INSTALL_STAGING = YES
GMP_LICENSE = LGPL-3.0+ or GPL-2.0+
GMP_LICENSE_FILES = COPYING.LESSERv3 COPYINGv2
GMP_DEPENDENCIES = host-m4
HOST_GMP_DEPENDENCIES = host-m4

# GMP doesn't support assembly for coldfire or mips r6 ISA yet
# Disable for ARM v7m since it has different asm constraints
ifeq ($(BR2_m68k_cf)$(BR2_MIPS_CPU_MIPS32R6)$(BR2_MIPS_CPU_MIPS64R6)$(BR2_ARM_CPU_ARMV7M),y)
GMP_CONF_OPTS += --disable-assembly
endif

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
GMP_CONF_OPTS += --enable-cxx
else
GMP_CONF_OPTS += --disable-cxx
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
