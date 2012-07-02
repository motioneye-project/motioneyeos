#############################################################
#
# libnetfilter-conntrack
#
#############################################################

LIBNETFILTER_CONNTRACK_VERSION = 1.0.1
LIBNETFILTER_CONNTRACK_SOURCE = libnetfilter_conntrack-$(LIBNETFILTER_CONNTRACK_VERSION).tar.bz2
LIBNETFILTER_CONNTRACK_SITE = http://www.netfilter.org/projects/libnetfilter_conntrack/files
LIBNETFILTER_CONNTRACK_INSTALL_STAGING = YES
LIBNETFILTER_CONNTRACK_DEPENDENCIES = host-pkg-config libnfnetlink

$(eval $(autotools-package))
