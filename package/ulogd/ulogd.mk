################################################################################
#
# ulogd
#
################################################################################

ULOGD_VERSION = 2.0.2
ULOGD_SOURCE = ulogd-$(ULOGD_VERSION).tar.bz2
ULOGD_SITE = http://www.netfilter.org/projects/ulogd/files
ULOGD_CONF_OPT = --with-dbi=no --with-pgsql=no
ULOGD_AUTORECONF = YES
ULOGD_DEPENDENCIES = host-pkgconf \
	libmnl libnetfilter_acct libnetfilter_conntrack libnetfilter_log \
	libnfnetlink $(if $(BR2_PACKAGE_SQLITE),sqlite)
ULOGD_LICENSE = GPLv2
ULOGD_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_MYSQL_CLIENT),y)
ULOGD_CONF_OPT += --with-mysql=$(STAGING_DIR)/usr
ULOGD_DEPENDENCIES += mysql_client
else
ULOGD_CONF_OPT += --with-mysql=no
endif

$(eval $(autotools-package))
