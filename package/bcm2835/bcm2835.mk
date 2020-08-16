################################################################################
#
# bcm2835
#
################################################################################

BCM2835_VERSION = 1.63
BCM2835_SITE = http://www.airspayce.com/mikem/bcm2835
BCM2835_LICENSE = GPL-3.0
BCM2835_LICENSE_FILES = COPYING
BCM2835_INSTALL_STAGING = YES

$(eval $(autotools-package))
