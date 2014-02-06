################################################################################
#
# snmp++
#
################################################################################

SNMPPP_VERSION = 3.3.3
SNMPPP_SOURCE = snmp++$(SNMPPP_VERSION).tar.gz
SNMPPP_SITE = http://www.agentpp.com
SNMPPP_DEPENDENCIES = openssl host-pkgconf
SNMPPP_INSTALL_STAGING = YES
# no configure script in tarball
SNMPPP_AUTORECONF = YES
SNMPPP_LICENSE = SNMP++
SNMPPP_LICENSE_FILES = src/v3.cpp

$(eval $(autotools-package))
