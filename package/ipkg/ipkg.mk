################################################################################
#
# ipkg
#
################################################################################

IPKG_VERSION = 0.99.163
IPKG_SITE = http://www.handhelds.org/download/packages/ipkg
IPKG_INSTALL_STAGING = YES

$(eval $(autotools-package))
