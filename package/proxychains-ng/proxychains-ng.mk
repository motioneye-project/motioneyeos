#############################################################
#
# proxychains-ng
#
#############################################################
PROXYCHAINS_NG_VERSION = 4.4
PROXYCHAINS_NG_SOURCE = proxychains-$(PROXYCHAINS_NG_VERSION).tar.bz2
PROXYCHAINS_NG_SITE = http://downloads.sourceforge.net/project/proxychains-ng

$(eval $(autotools-package))
