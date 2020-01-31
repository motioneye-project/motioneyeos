################################################################################
#
# arp-scan
#
################################################################################

ARP_SCAN_VERSION = 1.9.7
ARP_SCAN_SITE = $(call github,royhills,arp-scan,$(ARP_SCAN_VERSION))
ARP_SCAN_LICENSE = GPL-3.0+
ARP_SCAN_LICENSE_FILES = COPYING
ARP_SCAN_DEPENDENCIES = libpcap
ARP_SCAN_AUTORECONF = YES

ifeq ($(BR2_STATIC_LIBS),y)
ARP_SCAN_CONF_OPTS = LIBS="`$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`"
endif

ARP_SCAN_CONF_ENV = pgac_cv_snprintf_long_long_int_format='%lld'

$(eval $(autotools-package))
