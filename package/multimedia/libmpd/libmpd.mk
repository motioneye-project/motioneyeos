#############################################################
#
# libmpd
#
#############################################################
LIBMPD_VERSION = 0.17.0
LIBMPD_SOURCE = libmpd-$(LIBMPD_VERSION).tar.gz
LIBMPD_SITE = http://download.sarine.nl/download/Programs/gmpc/$(LIBMPD_VERSION)/
LIBMPD_INSTALL_STAGING = YES
LIBMPD_LIBTOOL_PATCH = NO
LIBMPD_DEPENDENCIES = libglib2

$(eval $(call AUTOTARGETS,package/multimedia,libmpd))
