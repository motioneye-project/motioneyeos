################################################################################
#
# snmppp
#
################################################################################

SNMPPP_VERSION = 3.3.11a
SNMPPP_SOURCE = snmp++-$(SNMPPP_VERSION).tar.gz
SNMPPP_SITE = http://www.agentpp.com/download
SNMPPP_DEPENDENCIES = host-pkgconf
SNMPPP_INSTALL_STAGING = YES
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
