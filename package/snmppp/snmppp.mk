################################################################################
#
# snmp++
#
################################################################################

SNMPPP_VERSION = 3.3.0
SNMPPP_SOURCE = snmp++v$(SNMPPP_VERSION).tar.gz
SNMPPP_SITE = http://www.agentpp.com
SNMPPP_DEPENDENCIES = openssl host-pkgconf
SNMPPP_INSTALL_STAGING = YES
# no configure script in tarball
SNMPPP_AUTORECONF = YES
SNMPPP_LICENSE = SNMP++
SNMPPP_LICENSE_FILES = snmp_pp/snmp_pp.cpp

$(eval $(autotools-package))
