################################################################################
#
# rtl8723bs
#
################################################################################

RTL8723BS_VERSION = 11ab92d8ccd71c80f0102828366b14ef6b676fb2
RTL8723BS_SITE = $(call github,hadess,rtl8723bs,$(RTL8723BS_VERSION))
RTL8723BS_LICENSE = GPL-2.0, proprietary (*.bin firmware blobs)

RTL8723BS_MODULE_MAKE_OPTS = \
	CONFIG_RTL8723BS=m \
	KVER=$(LINUX_VERSION_PROBED) \
	KSRC=$(LINUX_DIR)

RTL8723BS_BINS = rtl8723bs_ap_wowlan.bin rtl8723bs_wowlan.bin \
	rtl8723bs_bt.bin rtl8723bs_nic.bin

define RTL8723BS_INSTALL_FIRMWARE
	$(foreach bin, $(RTL8723BS_BINS), \
		$(INSTALL) -D -m 644 $(@D)/$(bin) $(TARGET_DIR)/lib/firmware/rtlwifi/$(bin)
	)
endef
RTL8723BS_POST_INSTALL_TARGET_HOOKS += RTL8723BS_INSTALL_FIRMWARE

$(eval $(kernel-module))
$(eval $(generic-package))
