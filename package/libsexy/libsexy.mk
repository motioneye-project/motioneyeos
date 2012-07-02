################################################################################
#
# libsexy
#
################################################################################

LIBSEXY_VERSION = 0.1.11
LIBSEXY_SOURCE = libsexy-$(LIBSEXY_VERSION).tar.gz
LIBSEXY_SITE = http://releases.chipx86.com/libsexy/libsexy/
LIBSEXY_DEPENDENCIES = libgtk2 libxml2
LIBSEXY_INSTALL_STAGING = YES

$(eval $(autotools-package))
