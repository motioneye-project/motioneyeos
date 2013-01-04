#############################################################
#
# gmp
#
#############################################################

GMP_VERSION = 5.1.0
GMP_SITE = ftp://ftp.gmplib.org/pub/gmp-$(GMP_VERSION)
GMP_SOURCE = gmp-$(GMP_VERSION).tar.bz2
GMP_INSTALL_STAGING = YES
GMP_LICENSE = LGPLv3+
GMP_LICENSE_FILES = COPYING.LIB

# Bad ARM assembly breaks on pure thumb
ifeq ($(ARCH),arm)
GMP_MAKE_OPT += CFLAGS="$(TARGET_CFLAGS) -marm"
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
