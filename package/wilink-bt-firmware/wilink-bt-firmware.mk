################################################################################
#
# wilink-bt-firmware
#
################################################################################

WILINK_BT_FIRMWARE_VERSION = 43fca73c6a98c63fcb98f82af5bf83761778e005
WILINK_BT_FIRMWARE_SITE = git://git.ti.com/ti-bt/service-packs.git
WILINK_BT_FIRMWARE_SITE_METHOD = git
WILINK_BT_FIRMWARE_LICENSE = PROPRIETARY
WILINK_BT_FIRMWARE_LICENSE_FILES = LICENSE

define WILINK_BT_FIRMWARE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware/ti-connectivity
	cp $(@D)/initscripts/TIInit_*.bts $(TARGET_DIR)/lib/firmware/ti-connectivity
endef

$(eval $(generic-package))
