################################################################################
#
# bustle
#
################################################################################

BUSTLE_VERSION = 0.4.3
BUSTLE_SITE = http://www.willthompson.co.uk/bustle/releases/$(BUSTLE_VERSION)/
BUSTLE_LICENSE = LGPLv2.1+
BUSTLE_LICENSE_FILES = LICENSE
BUSTLE_DEPENDENCIES = libglib2 libpcap host-pkgconf

define BUSTLE_BUILD_CMDS
	PATH=$(TARGET_PATH) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		PCAP_FLAGS='-lpcap' -C $(@D) dist/build/bustle-pcap
endef

define BUSTLE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/dist/build/bustle-pcap \
		$(TARGET_DIR)/usr/bin/bustle-pcap
endef

$(eval $(generic-package))
