################################################################################
#
# nftables
#
################################################################################

NFTABLES_VERSION = 0.8.1
NFTABLES_SOURCE = nftables-$(NFTABLES_VERSION).tar.bz2
NFTABLES_SITE = http://www.netfilter.org/projects/nftables/files
NFTABLES_DEPENDENCIES = gmp libmnl libnftnl host-bison host-flex \
	host-pkgconf $(TARGET_NLS_DEPENDENCIES)
NFTABLES_LICENSE = GPL-2.0
NFTABLES_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_READLINE),y)
NFTABLES_DEPENDENCIES += readline
NFTABLES_LIBS += -lncurses
else
NFTABLES_CONF_OPTS += --without-cli
endif

ifeq ($(BR2_STATIC_LIBS)$(BR2_PACKAGE_LIBNFTNL_JSON),yy)
NFTABLES_LIBS += -ljansson -lm
endif

NFTABLES_CONF_ENV = \
	ac_cv_prog_CONFIG_PDF=no \
	LIBS="$(NFTABLES_LIBS)" \
	DBLATEX=no \
	DOCBOOK2X_MAN=no \
	DOCBOOK2MAN=no \
	DB2X_DOCBOOK2MAN=no

$(eval $(autotools-package))
