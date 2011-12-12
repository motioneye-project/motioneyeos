#############################################################
#
# libosip2
#
#############################################################

LIBOSIP2_VERSION = 3.6.0
LIBOSIP2_SOURCE = libosip2-$(LIBOSIP2_VERSION).tar.gz
LIBOSIP2_SITE = $(BR2_GNU_MIRROR)/osip
LIBOSIP2_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS))
