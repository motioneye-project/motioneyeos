################################################################################
#
# rtl8723bu
#
################################################################################

RTL8723BU_VERSION = b922079a090dcaad58179d478442ff97f18521c9
RTL8723BU_SITE = $(call github,lwfinger,rtl8723bu,$(RTL8723BU_VERSION))
RTL8723BU_LICENSE = GPL-2.0, proprietary (*.bin firmware blobs)

RTL8723BU_MODULE_MAKE_OPTS = \
	KVER=$(LINUX_VERSION_PROBED) \
	KSRC=$(LINUX_DIR)

define RTL8723BU_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 644 $(@D)/rtl8723b_fw.bin $(TARGET_DIR)/lib/firmware/rtlwifi/rtl8723b_fw.bin
endef

$(eval $(kernel-module))
$(eval $(generic-package))
