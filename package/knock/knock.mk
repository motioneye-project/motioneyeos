################################################################################
#
# knock
#
################################################################################

KNOCK_VERSION = 0.7
KNOCK_SITE = http://www.zeroflux.org/proj/knock/files
KNOCK_LICENSE = GPLv2+
KNOCK_LICENSE_FILES = COPYING
KNOCK_DEPENDENCIES = libpcap

ifeq ($(BR2_PREFER_STATIC_LIB),y)
KNOCK_CONF_OPT = LIBS="$(shell $(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs)"
endif

$(eval $(autotools-package))
