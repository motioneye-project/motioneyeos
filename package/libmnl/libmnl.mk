################################################################################
#
# libmnl
#
################################################################################

LIBMNL_VERSION = 1.0.4
LIBMNL_SOURCE = libmnl-$(LIBMNL_VERSION).tar.bz2
LIBMNL_SITE = http://netfilter.org/projects/libmnl/files
LIBMNL_INSTALL_STAGING = YES
LIBMNL_LICENSE = LGPLv2.1+
LIBMNL_LICENSE_FILES = COPYING

$(eval $(autotools-package))
