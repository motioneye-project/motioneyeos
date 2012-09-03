#############################################################
#
# conntrack-tools
#
#############################################################

CONNTRACK_TOOLS_VERSION = 1.2.2
CONNTRACK_TOOLS_SOURCE = conntrack-tools-$(CONNTRACK_TOOLS_VERSION).tar.bz2
CONNTRACK_TOOLS_SITE = http://www.netfilter.org/projects/conntrack-tools/files
CONNTRACK_TOOLS_DEPENDENCIES = host-pkg-config \
	libnetfilter_conntrack libnetfilter_cttimeout
CONNTRACK_TOOLS_LICENSE = GPLv2
CONNTRACK_TOOLS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
