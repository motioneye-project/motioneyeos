################################################################################
#
# ipset
#
################################################################################

IPSET_VERSION = 6.30
IPSET_SOURCE = ipset-$(IPSET_VERSION).tar.bz2
IPSET_SITE = http://ipset.netfilter.org
IPSET_DEPENDENCIES = libmnl host-pkgconf
IPSET_CONF_OPTS = --with-kmod=no
IPSET_LICENSE = GPLv2
IPSET_LICENSE_FILES = COPYING
IPSET_INSTALL_STAGING = YES

$(eval $(autotools-package))
