################################################################################
#
# nftables
#
################################################################################

NFTABLES_VERSION = 0.3
NFTABLES_SOURCE = nftables-$(NFTABLES_VERSION).tar.bz2
NFTABLES_SITE = http://www.netfilter.org/projects/nftables/files
NFTABLES_DEPENDENCIES = gmp libmnl libnftnl readline host-bison host-flex \
	host-pkgconf $(if $(BR2_NEEDS_GETTEXT),gettext)
NFTABLES_LICENSE = GPLv2
NFTABLES_LICENSE_FILES = COPYING

NFTABLES_CONF_ENV = \
	ac_cv_prog_CONFIG_PDF=no \
	LIBS="-lncurses"

$(eval $(autotools-package))
