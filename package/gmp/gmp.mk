#############################################################
#
# gmp
#
#############################################################

GMP_VERSION = 5.0.1
GMP_SITE = $(BR2_GNU_MIRROR)/gmp
GMP_SOURCE = gmp-$(GMP_VERSION).tar.bz2
GMP_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package,gmp))
$(eval $(call AUTOTARGETS,package,gmp,host))
