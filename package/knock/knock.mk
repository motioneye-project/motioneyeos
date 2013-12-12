################################################################################
#
# knock
#
################################################################################

KNOCK_VERSION = 7666f2e86e18d482eaad5fe1fea46d87d80b0555
KNOCK_SITE = $(call github,jvinet,$(KNOCK_VERSION))
KNOCK_LICENSE = GPLv2+
KNOCK_LICENSE_FILES = COPYING
KNOCK_AUTORECONF = YES
KNOCK_DEPENDENCIES = libpcap

$(eval $(autotools-package))
