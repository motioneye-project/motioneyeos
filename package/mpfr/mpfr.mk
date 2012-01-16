#############################################################
#
# mpfr
#
#############################################################

MPFR_VERSION = 3.0.1
MPFR_SITE = http://www.mpfr.org/mpfr-$(MPFR_VERSION)
MPFR_SOURCE = mpfr-$(MPFR_VERSION).tar.bz2
MPFR_INSTALL_STAGING = YES
MPFR_DEPENDENCIES = gmp
MPFR_MAKE_OPT = RANLIB=$(TARGET_RANLIB)

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
