#############################################################
#
# ipset
#
#############################################################

IPSET_VERSION = 6.8
IPSET_SOURCE = ipset-$(IPSET_VERSION).tar.bz2
IPSET_SITE = http://ipset.netfilter.org
IPSET_AUTORECONF = YES
IPSET_DEPENDENCIES = libmnl host-pkg-config

$(eval $(call AUTOTARGETS,package,ipset))
