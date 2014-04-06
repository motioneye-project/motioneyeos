################################################################################
#
# agentpp
#
################################################################################

AGENTPP_VERSION = 4.0.2
AGENTPP_SOURCE = agent++-$(AGENTPP_VERSION).tar.gz
AGENTPP_SITE = http://www.agentpp.com
AGENTPP_LICENSE = Apache-2.0
AGENTPP_LICENSE_FILES = LICENSE-2_0.txt
AGENTPP_INSTALL_STAGING = YES
AGENTPP_DEPENDENCIES = host-pkgconf snmppp
AGENTPP_CONF_OPT += \
	--disable-proxy \
	--disable-forwarder \
	--disable-rpath \
	--disable-dependency-tracking

$(eval $(autotools-package))
