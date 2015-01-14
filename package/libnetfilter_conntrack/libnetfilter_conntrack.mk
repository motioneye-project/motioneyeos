################################################################################
#
# libnetfilter_conntrack
#
################################################################################

LIBNETFILTER_CONNTRACK_VERSION = 1.0.4
LIBNETFILTER_CONNTRACK_SOURCE = libnetfilter_conntrack-$(LIBNETFILTER_CONNTRACK_VERSION).tar.bz2
LIBNETFILTER_CONNTRACK_SITE = http://www.netfilter.org/projects/libnetfilter_conntrack/files
LIBNETFILTER_CONNTRACK_INSTALL_STAGING = YES
LIBNETFILTER_CONNTRACK_DEPENDENCIES = host-pkgconf libnfnetlink libmnl
# For 0001-uclinux.patch & 0002-src-Makefile.am-drop-hardcoded-ldl.patch
LIBNETFILTER_CONNTRACK_AUTORECONF = YES
LIBNETFILTER_CONNTRACK_LICENSE = GPLv2+
LIBNETFILTER_CONNTRACK_LICENSE_FILES = COPYING

$(eval $(autotools-package))
