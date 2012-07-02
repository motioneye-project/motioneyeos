#############################################################
#
# libosip2
#
#############################################################

LIBOSIP2_VERSION = 3.6.0
LIBOSIP2_SITE = $(BR2_GNU_MIRROR)/osip
LIBOSIP2_INSTALL_STAGING = YES

$(eval $(autotools-package))
