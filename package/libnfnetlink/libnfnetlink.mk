#############################################################
#
# libnfnetlink
#
#############################################################

LIBNFNETLINK_VERSION = 1.0.0
LIBNFNETLINK_SOURCE = libnfnetlink-$(LIBNFNETLINK_VERSION).tar.bz2
LIBNFNETLINK_SITE = http://www.netfilter.org/projects/libnfnetlink/files
LIBNFNETLINK_INSTALL_STAGING = YES

$(eval $(autotools-package))
