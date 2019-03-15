################################################################################
#
# ulogd
#
################################################################################

ULOGD_VERSION = 2.0.7
ULOGD_SOURCE = ulogd-$(ULOGD_VERSION).tar.bz2
ULOGD_SITE = http://www.netfilter.org/projects/ulogd/files
ULOGD_CONF_OPTS = --without-dbi
ULOGD_DEPENDENCIES = host-pkgconf \
	libmnl libnetfilter_acct libnetfilter_conntrack libnetfilter_log \
	libnfnetlink
ULOGD_LICENSE = GPL-2.0
ULOGD_LICENSE_FILES = COPYING

# DB backends need threads
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
ifeq ($(BR2_PACKAGE_MYSQL),y)
ULOGD_CONF_OPTS += --with-mysql=$(STAGING_DIR)/usr
ULOGD_DEPENDENCIES += mysql
else
ULOGD_CONF_OPTS += --without-mysql
endif
ifeq ($(BR2_PACKAGE_POSTGRESQL),y)
ULOGD_CONF_OPTS += --with-pgsql
ULOGD_DEPENDENCIES += postgresql
else
ULOGD_CONF_OPTS += --without-pgsql
endif
ifeq ($(BR2_PACKAGE_SQLITE),y)
ULOGD_CONF_OPTS += --with-sqlite
ULOGD_DEPENDENCIES += sqlite
else
ULOGD_CONF_OPTS += --without-sqlite
endif
else
ULOGD_CONF_OPTS += --without-mysql --without-pgsql --without-sqlite
endif

ifeq ($(BR2_PACKAGE_LIBPCAP),y)
ULOGD_CONF_OPTS += --with-pcap
ULOGD_DEPENDENCIES += libpcap
else
ULOGD_CONF_OPTS += --without-pcap
endif

ifeq ($(BR2_PACKAGE_JANSSON),y)
ULOGD_CONF_OPTS += --with-jansson
ULOGD_DEPENDENCIES += jansson
else
ULOGD_CONF_OPTS += --without-jansson
endif

$(eval $(autotools-package))
