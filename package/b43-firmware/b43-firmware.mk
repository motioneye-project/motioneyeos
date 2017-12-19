################################################################################
#
# b43-firmware
#
################################################################################

ifeq ($(BR2_PACKAGE_B43_FIRMWARE_KERNEL_AFTER_3_2),y)
B43_FIRMWARE_VERSION = 5.100.138
B43_FIRMWARE_SITE = http://www.lwfinger.com/b43-firmware
B43_FIRMWARE_SOURCE = broadcom-wl-$(B43_FIRMWARE_VERSION).tar.bz2
B43_FIRMWARE_DRIVER_FILE = linux/wl_apsta.o
else ifeq ($(BR2_PACKAGE_B43_FIRMWARE_KERNEL_BEFORE_3_2),y)
B43_FIRMWARE_VERSION = 5.10.56.27.3
B43_FIRMWARE_SITE = http://mirror2.openwrt.org/sources
B43_FIRMWARE_SOURCE = broadcom-wl-$(B43_FIRMWARE_VERSION)_mipsel.tar.bz2
B43_FIRMWARE_DRIVER_FILE = driver/wl_apsta/wl_prebuilt.o
endif

B43_FIRMWARE_LICENSE = PROPRIETARY
B43_FIRMWARE_REDISTRIBUTE = NO

B43_FIRMWARE_DEPENDENCIES = host-b43-fwcutter

define B43_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/lib/firmware/
	$(HOST_DIR)/bin/b43-fwcutter -w $(TARGET_DIR)/lib/firmware/ $(@D)/$(B43_FIRMWARE_DRIVER_FILE)
endef

$(eval $(generic-package))
