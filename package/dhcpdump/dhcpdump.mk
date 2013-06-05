################################################################################
#
# dhcpdump
#
################################################################################

DHCPDUMP_VERSION = 1.8
DHCPDUMP_SITE    = http://www.mavetju.org/download/
DHCPDUMP_SOURCE  = dhcpdump-$(DHCPDUMP_VERSION).tar.gz

DHCPDUMP_DEPENDENCIES = libpcap

define DHCPDUMP_BUILD_CMDS
	$(MAKE) -C $(@D) CC="$(TARGET_CC) $(TARGET_CFLAGS)"
endef

define DHCPDUMP_INSTALL_TARGET_CMDS
	install -m 0755 -D $(@D)/dhcpdump $(TARGET_DIR)/usr/bin/dhcpdump
endef

$(eval $(generic-package))
