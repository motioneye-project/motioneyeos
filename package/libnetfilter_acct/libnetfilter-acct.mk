################################################################################
#
# libnetfilter-acct
#
################################################################################

LIBNETFILTER_ACCT_VERSION = 1.0.2
LIBNETFILTER_ACCT_SOURCE = libnetfilter_acct-$(LIBNETFILTER_ACCT_VERSION).tar.bz2
LIBNETFILTER_ACCT_SITE = http://www.netfilter.org/projects/libnetfilter_acct/files
LIBNETFILTER_ACCT_INSTALL_STAGING = YES
LIBNETFILTER_ACCT_DEPENDENCIES = host-pkgconf libmnl
LIBNETFILTER_ACCT_LICENSE = LGPLv2.1+
LIBNETFILTER_ACCT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
