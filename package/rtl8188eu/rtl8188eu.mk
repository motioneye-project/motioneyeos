################################################################################
#
# rtl8188eu
#
################################################################################

RTL8188EU_VERSION = 3091828c8f4b4a01cbec6025128bf77e6e7b9f97
RTL8188EU_SITE = $(call github,lwfinger,rtl8188eu,$(RTL8188EU_VERSION))
RTL8188EU_LICENSE = GPLv2, proprietary (rtl8188eufw.bin firmware blob)
RTL8188EU_LICENSE_FILES = COPYING
RTL8188EU_MODULE_MAKE_OPTS = CONFIG_RTL8188EU=m

$(eval $(kernel-module))

define RTL8188EU_INSTALL_FIRMWARE
	$(INSTALL) -D -m 644 $(@D)/rtl8188eufw.bin \
		$(TARGET_DIR)/lib/firmware/rtlwifi/rtl8188eufw.bin
endef
RTL8188EU_POST_INSTALL_TARGET_HOOKS += RTL8188EU_INSTALL_FIRMWARE

$(eval $(generic-package))
