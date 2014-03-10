################################################################################
#
# ipset
#
################################################################################

IPSET_VERSION = 6.21.1
IPSET_SOURCE = ipset-$(IPSET_VERSION).tar.bz2
IPSET_SITE = http://ipset.netfilter.org
IPSET_DEPENDENCIES = libmnl host-pkgconf
IPSET_CONF_OPT = --with-kmod=no
IPSET_AUTORECONF = YES
IPSET_LICENSE = GPLv2
IPSET_LICENSE_FILES = COPYING

$(eval $(autotools-package))
