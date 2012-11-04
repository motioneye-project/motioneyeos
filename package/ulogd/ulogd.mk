#############################################################
#
# ulogd
#
#############################################################

ULOGD_VERSION = 2.0.1
ULOGD_SOURCE = ulogd-$(ULOGD_VERSION).tar.bz2
ULOGD_SITE = http://www.netfilter.org/projects/ulogd/files
ULOGD_CONF_OPT = --with-dbi=no --with-mysql=no --with-pgsql=no
ULOGD_AUTORECONF = YES
ULOGD_DEPENDENCIES = host-pkgconf \
	libmnl libnetfilter_acct libnetfilter_conntrack libnetfilter_log \
	libnfnetlink $(if $(BR2_PACKAGE_SQLITE),sqlite)
ULOGD_LICENSE = GPLv2
ULOGD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
