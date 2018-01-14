################################################################################
#
# armbian-firmware
#
################################################################################

ARMBIAN_FIRMWARE_VERSION = 455d6b6701178dafe7fd0168eb4a4ef78a8d24a3
ARMBIAN_FIRMWARE_SITE = https://github.com/armbian/firmware
ARMBIAN_FIRMWARE_SITE_METHOD = git

# XR819 WiFi firmware
ifeq ($(BR2_PACKAGE_ARMBIAN_FIRMWARE_XR819),y)
ARMBIAN_FIRMWARE_FILES += \
	xr819/boot_xr819.bin \
	xr819/fw_xr819.bin \
	xr819/sdd_xr819.bin
endif

# AP6212 WiFi/BT combo firmware
ifeq ($(BR2_PACKAGE_ARMBIAN_FIRMWARE_AP6212),y)
ARMBIAN_FIRMWARE_DIRS += ap6212
endif

ifneq ($(ARMBIAN_FIRMWARE_FILES),)
define ARMBIAN_FIRMWARE_INSTALL_FILES
	cd $(@D) && \
		$(TAR) cf install.tar $(sort $(ARMBIAN_FIRMWARE_FILES)) && \
		$(TAR) xf install.tar -C $(TARGET_DIR)/lib/firmware
endef
endif

ifneq ($(ARMBIAN_FIRMWARE_DIRS),)
# We need to rm -rf the destination directory to avoid copying
# into it in itself, should we re-install the package.
define ARMBIAN_FIRMWARE_INSTALL_DIRS
	$(foreach d,$(ARMBIAN_FIRMWARE_DIRS), \
		rm -rf $(TARGET_DIR)/lib/firmware/$(d); \
		cp -a $(@D)/$(d) $(TARGET_DIR)/lib/firmware/$(d)$(sep))
endef
endif

ifneq ($(ARMBIAN_FIRMWARE_FILES)$(ARMBIAN_FIRMWARE_DIRS),)
ARMBIAN_FIRMWARE_LICENSE = PROPRIETARY
ARMBIAN_FIRMWARE_REDISTRIBUTE = NO
endif

define ARMBIAN_FIRMWARE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware
	$(ARMBIAN_FIRMWARE_INSTALL_FILES)
	$(ARMBIAN_FIRMWARE_INSTALL_DIRS)
endef

$(eval $(generic-package))
