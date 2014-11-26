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

NFTABLES_LIBS = -lncurses
ifeq ($(BR2_PREFER_STATIC_LIB)$(BR2_PACKAGE_LIBNFTNL_JSON),yy)
NFTABLES_LIBS += -ljansson -lm
endif
ifeq ($(BR2_PREFER_STATIC_LIB)$(BR2_PACKAGE_LIBNFTNL_XML),yy)
NFTABLES_LIBS += -lmxml -lpthread
endif

NFTABLES_CONF_ENV = \
	ac_cv_prog_CONFIG_PDF=no \
	LIBS="$(NFTABLES_LIBS)"

$(eval $(autotools-package))
