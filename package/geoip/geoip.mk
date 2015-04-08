################################################################################
#
# geoip
#
################################################################################

GEOIP_VERSION = 1.6.5
GEOIP_SOURCE = GeoIP-$(GEOIP_VERSION).tar.gz
GEOIP_SITE = https://github.com/maxmind/geoip-api-c/releases/download/v$(GEOIP_VERSION)
GEOIP_INSTALL_STAGING = YES
GEOIP_LICENSE = LGPLv2.1+
GEOIP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
