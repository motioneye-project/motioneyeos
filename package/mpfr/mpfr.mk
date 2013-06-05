################################################################################
#
# mpfr
#
################################################################################

MPFR_VERSION = 3.1.2
MPFR_SITE = http://www.mpfr.org/mpfr-$(MPFR_VERSION)
MPFR_SOURCE = mpfr-$(MPFR_VERSION).tar.bz2
MPFR_LICENSE = LGPLv3+
MPFR_LICENSE_FILES = COPYING.LESSER
MPFR_INSTALL_STAGING = YES
MPFR_DEPENDENCIES = gmp
MPFR_MAKE_OPT = RANLIB=$(TARGET_RANLIB)

$(eval $(autotools-package))
$(eval $(host-autotools-package))
