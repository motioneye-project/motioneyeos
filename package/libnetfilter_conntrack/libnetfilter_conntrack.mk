################################################################################
#
# libnetfilter_conntrack
#
################################################################################

LIBNETFILTER_CONNTRACK_VERSION = 1.0.7
LIBNETFILTER_CONNTRACK_SOURCE = libnetfilter_conntrack-$(LIBNETFILTER_CONNTRACK_VERSION).tar.bz2
LIBNETFILTER_CONNTRACK_SITE = http://www.netfilter.org/projects/libnetfilter_conntrack/files
LIBNETFILTER_CONNTRACK_INSTALL_STAGING = YES
LIBNETFILTER_CONNTRACK_DEPENDENCIES = host-pkgconf libnfnetlink libmnl
LIBNETFILTER_CONNTRACK_LICENSE = GPL-2.0+
LIBNETFILTER_CONNTRACK_LICENSE_FILES = COPYING

$(eval $(autotools-package))
