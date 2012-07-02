#############################################################
#
# gmp
#
#############################################################

GMP_VERSION = 5.0.5
GMP_SITE = $(BR2_GNU_MIRROR)/gmp
GMP_SOURCE = gmp-$(GMP_VERSION).tar.bz2
GMP_INSTALL_STAGING = YES

# Bad ARM assembly breaks on pure thumb
ifeq ($(ARCH),arm)
GMP_MAKE_OPT += CFLAGS="$(TARGET_CFLAGS) -marm"
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
