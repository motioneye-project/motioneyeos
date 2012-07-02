#############################################################
#
# libmnl
#
#############################################################

LIBMNL_VERSION = 1.0.3
LIBMNL_SOURCE = libmnl-$(LIBMNL_VERSION).tar.bz2
LIBMNL_SITE = http://netfilter.org/projects/libmnl/files
LIBMNL_INSTALL_STAGING = YES

$(eval $(autotools-package))
