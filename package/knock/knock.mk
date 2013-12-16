################################################################################
#
# knock
#
################################################################################

KNOCK_VERSION = 7ce33cd553800f48f16b3bb70b9cd0f1310d2c18
KNOCK_SITE = $(call github,jvinet,knock,$(KNOCK_VERSION))
KNOCK_LICENSE = GPLv2+
KNOCK_LICENSE_FILES = COPYING
KNOCK_AUTORECONF = YES
KNOCK_DEPENDENCIES = libpcap

$(eval $(autotools-package))
