################################################################################
#
# uccp420wlan
#
################################################################################

UCCP420WLAN_VERSION = 6.9.1
UCCP420WLAN_SITE = $(call github,CreatorDev,uccp420wlan,v$(UCCP420WLAN_VERSION))
UCCP420WLAN_LICENSE = GPL-2.0 (kernel module), proprietary (firmware blob)
UCCP420WLAN_LICENSE_FILES = COPYING firmware/LICENSE.imagination

define UCCP420WLAN_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware/img/uccp420wlan
	cp $(@D)/firmware/*.ldr $(TARGET_DIR)/lib/firmware/img/uccp420wlan
endef

$(eval $(kernel-module))
$(eval $(generic-package))
