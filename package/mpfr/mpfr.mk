#############################################################
#
# mpfr
#
#############################################################

MPFR_VERSION = 3.0.0
MPFR_SITE = http://www.mpfr.org/mpfr-$(MPFR_VERSION)
MPFR_SOURCE = mpfr-$(MPFR_VERSION).tar.bz2
MPFR_INSTALL_STAGING = YES
MPFR_DEPENDENCIES = gmp
MPFR_MAKE_OPT = RANLIB=$(TARGET_RANLIB)
HOST_MPFR_DEPENDENCIES = host-gmp

$(eval $(call AUTOTARGETS,package,mpfr))
$(eval $(call AUTOTARGETS,package,mpfr,host))
