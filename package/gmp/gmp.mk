#############################################################
#
# gmp
#
#############################################################

GMP_VERSION = 5.0.2
GMP_SITE = $(BR2_GNU_MIRROR)/gmp
GMP_SOURCE = gmp-$(GMP_VERSION).tar.bz2
GMP_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
