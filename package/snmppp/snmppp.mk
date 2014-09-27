################################################################################
#
# snmppp
#
################################################################################

SNMPPP_VERSION = 3.3.4
SNMPPP_SOURCE = snmp++-$(SNMPPP_VERSION).tar.gz
SNMPPP_SITE = http://www.agentpp.com
SNMPPP_DEPENDENCIES = host-pkgconf
SNMPPP_INSTALL_STAGING = YES
# no configure script in tarball
SNMPPP_AUTORECONF = YES
SNMPPP_CONF_OPTS = $(if $(BR2_PACKAGE_SNMPPP_LOGGING),--enable-logging,--disable-logging)
SNMPPP_LICENSE = SNMP++
SNMPPP_LICENSE_FILES = src/v3.cpp

ifeq ($(BR2_PACKAGE_SNMPPP_SNMPV3),y)
	SNMPPP_CONF_OPTS += --enable-snmpv3
	SNMPPP_DEPENDENCIES += openssl
else
	SNMPPP_CONF_OPTS += --disable-snmpv3
endif

$(eval $(autotools-package))
