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
# For 0001-Do-not-pass-Werror-when-enable-debug-is-used.patch
IPSET_AUTORECONF = YES
IPSET_LICENSE = GPLv2
IPSET_LICENSE_FILES = COPYING

$(eval $(autotools-package))
