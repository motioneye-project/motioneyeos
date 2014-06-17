################################################################################
#
# geoip
#
################################################################################

GEOIP_VERSION = 1.6.0
GEOIP_SOURCE = GeoIP-$(GEOIP_VERSION).tar.gz
GEOIP_SITE = $(call github,maxmind,geoip-api-c,v$(GEOIP_VERSION))
GEOIP_AUTORECONF = YES
GEOIP_INSTALL_STAGING = YES
GEOIP_LICENSE = LGPLv2.1+
GEOIP_LICENSE_FILES = LICENSE COPYING

$(eval $(autotools-package))
