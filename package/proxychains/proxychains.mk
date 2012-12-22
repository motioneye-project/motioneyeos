#############################################################
#
# ProxyChains
#
#############################################################
PROXYCHAINS_VERSION = 3.1
PROXYCHAINS_SOURCE = proxychains-$(PROXYCHAINS_VERSION).tar.gz
PROXYCHAINS_SITE = http://downloads.sourceforge.net/project/proxychains/proxychains/version%20$(PROXYCHAINS_VERSION)

$(eval $(autotools-package))
