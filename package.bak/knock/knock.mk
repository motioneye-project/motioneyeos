################################################################################
#
# knock
#
################################################################################

KNOCK_VERSION = 258a27e5a47809f97c2b9f2751a88c2f94aae891
KNOCK_SITE = $(call github,jvinet,knock,$(KNOCK_VERSION))
KNOCK_AUTORECONF = YES
KNOCK_LICENSE = GPLv2+
KNOCK_LICENSE_FILES = COPYING
KNOCK_DEPENDENCIES = libpcap

ifeq ($(BR2_STATIC_LIBS),y)
KNOCK_CONF_OPTS = LIBS="`$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`"
endif

$(eval $(autotools-package))
