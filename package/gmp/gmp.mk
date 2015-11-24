################################################################################
#
# gmp
#
################################################################################

GMP_VERSION = 6.0.0a
GMP_SITE = $(BR2_GNU_MIRROR)/gmp
GMP_SOURCE = gmp-$(GMP_VERSION).tar.xz
GMP_INSTALL_STAGING = YES
GMP_LICENSE = LGPLv3+
GMP_LICENSE_FILES = COPYING.LESSERv3
GMP_DEPENDENCIES = host-m4

# GMP doesn't support assembly for r6 ISA yet
ifeq ($(BR2_mips_32r6)$(BR2_mips_64r6),y)
GMP_CONF_OPTS += --disable-assembly
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
