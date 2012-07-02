#############################################################
#
# libev
#
#############################################################
LIBEV_VERSION = 4.11
LIBEV_SOURCE = libev-$(LIBEV_VERSION).tar.gz
LIBEV_SITE = http://dist.schmorp.de/libev/
LIBEV_INSTALL_STAGING = YES

$(eval $(autotools-package))
