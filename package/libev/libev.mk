#############################################################
#
# libev
#
#############################################################
LIBEV_VERSION = 4.04
LIBEV_SOURCE = libev-$(LIBEV_VERSION).tar.gz
LIBEV_SITE = http://dist.schmorp.de/libev/
LIBEV_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package,libev))
