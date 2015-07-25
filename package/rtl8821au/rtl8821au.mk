################################################################################
#
# rtl8821au
#
################################################################################

RTL8821AU_VERSION = f58e4a7fb27551bdbb4aee9db6086dd6ad996c8d
RTL8821AU_SITE = $(call github,ulli-kroll,rtl8821au,$(RTL8821AU_VERSION))
RTL8821AU_LICENSE = GPLv2, proprietary (rtl8821au.bin firmware)
RTL8821AU_LICENSE_FILES = COPYING

RTL8821AU_MODULE_MAKE_OPTS = \
	CONFIG_RTL8812AU_8821AU=m \
	KVER=$(LINUX_VERSION_PROBED) \
	USER_EXTRA_CFLAGS=-DCONFIG_$(call qstrip,$(BR2_ENDIAN))_ENDIAN

define RTL8821AU_FIRMWARE_INSTALL
	mkdir -p $(TARGET_DIR)/lib/firmware/rtlwifi/
	$(INSTALL) -D -m 0644 $(@D)/firmware/* $(TARGET_DIR)/lib/firmware/rtlwifi/
endef

RTL8821AU_POST_INSTALL_TARGET_HOOKS += RTL8821AU_FIRMWARE_INSTALL

$(eval $(kernel-module))
$(eval $(generic-package))
