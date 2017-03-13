################################################################################
#
# wilink-bt-firmware
#
################################################################################

WILINK_BT_FIRMWARE_VERSION = 169b2df5b968f0ede32ea9044859942fc220c435
WILINK_BT_FIRMWARE_SITE = $(call github,TI-ECS,bt-firmware,$(WILINK_BT_FIRMWARE_VERSION))
WILINK_BT_FIRMWARE_LICENSE = PROPRIETARY
WILINK_BT_FIRMWARE_LICENSE_FILES = LICENCE

define WILINK_BT_FIRMWARE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware/ti-connectivity
	cp $(@D)/TIInit_*.bts $(TARGET_DIR)/lib/firmware/ti-connectivity
endef

$(eval $(generic-package))
