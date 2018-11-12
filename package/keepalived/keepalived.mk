################################################################################
#
# keepalived
#
################################################################################

KEEPALIVED_VERSION = 1.4.2
KEEPALIVED_SITE = http://www.keepalived.org/software
KEEPALIVED_DEPENDENCIES = host-pkgconf openssl popt
KEEPALIVED_LICENSE = GPL-2.0+
KEEPALIVED_LICENSE_FILES = COPYING
# 0001-configure.ac-do-not-force-PIE.patch
KEEPALIVED_AUTORECONF = YES
KEEPALIVED_CONF_OPTS += --disable-dbus

ifeq ($(BR2_PACKAGE_LIBNL)$(BR2_PACKAGE_LIBNFNETLINK),yy)
KEEPALIVED_DEPENDENCIES += libnl libnfnetlink
KEEPALIVED_CONF_OPTS += --enable-libnl
else
KEEPALIVED_CONF_OPTS += --disable-libnl
endif

ifeq ($(BR2_PACKAGE_IPSET),y)
KEEPALIVED_DEPENDENCIES += ipset
KEEPALIVED_CONF_OPTS += --enable-libipset
else
KEEPALIVED_CONF_OPTS += --disable-libipset
endif

ifeq ($(BR2_PACKAGE_IPTABLES),y)
KEEPALIVED_DEPENDENCIES += iptables
KEEPALIVED_CONF_OPTS += --enable-libiptc
else
KEEPALIVED_CONF_OPTS += --disable-libiptc
endif

$(eval $(autotools-package))
