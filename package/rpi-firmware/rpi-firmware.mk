################################################################################
#
# rpi-firmware
#
################################################################################

RPI_FIRMWARE_VERSION = 2ef3800b1b71c0e30c2a61ecad6e007ae96ea342
RPI_FIRMWARE_SITE = $(call github,raspberrypi,firmware,$(RPI_FIRMWARE_VERSION))
RPI_FIRMWARE_LICENSE = BSD-3-Clause
RPI_FIRMWARE_LICENSE_FILES = boot/LICENCE.broadcom
RPI_FIRMWARE_INSTALL_IMAGES = YES

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_DTBS),y)
define RPI_FIRMWARE_INSTALL_DTB
	$(foreach dtb,$(wildcard $(@D)/boot/*.dtb), \
		$(INSTALL) -D -m 0644 $(dtb) $(BINARIES_DIR)/rpi-firmware/$(notdir $(dtb))
	)
endef
endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_DTB_OVERLAYS),y)
define RPI_FIRMWARE_INSTALL_DTB_OVERLAYS
	for ovldtb in  $(@D)/boot/overlays/*.dtbo; do \
		$(INSTALL) -D -m 0644 $${ovldtb} $(BINARIES_DIR)/rpi-firmware/overlays/$${ovldtb##*/} || exit 1; \
	done
endef
else
# Still create the directory, so a genimage.cfg can include it independently of
# whether _INSTALL_DTB_OVERLAYS is selected or not.
define RPI_FIRMWARE_INSTALL_DTB_OVERLAYS
	$(INSTALL) -d $(BINARIES_DIR)/rpi-firmware/overlays
endef
endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_VCDBG),y)
define RPI_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0700 $(@D)/$(if BR2_ARM_EABIHF,hardfp/)opt/vc/bin/vcdbg \
		$(TARGET_DIR)/usr/sbin/vcdbg
	$(INSTALL) -D -m 0644 $(@D)/$(if BR2_ARM_EABIHF,hardfp/)opt/vc/lib/libelftoolchain.so \
		$(TARGET_DIR)/usr/lib/libelftoolchain.so
endef
endif # INSTALL_VCDBG

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_VARIANT_PI),y)
# bootcode.bin is not used on rpi4, because it has been replaced by boot code in the onboard EEPROM
define RPI_FIRMWARE_INSTALL_BOOTCODE_BIN
	$(INSTALL) -D -m 0644 $(@D)/boot/bootcode.bin $(BINARIES_DIR)/rpi-firmware/bootcode.bin
endef
endif

define RPI_FIRMWARE_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 package/rpi-firmware/config.txt $(BINARIES_DIR)/rpi-firmware/config.txt
	$(INSTALL) -D -m 0644 package/rpi-firmware/cmdline.txt $(BINARIES_DIR)/rpi-firmware/cmdline.txt
	$(INSTALL) -D -m 0644 $(@D)/boot/start$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).elf $(BINARIES_DIR)/rpi-firmware/start.elf
	$(INSTALL) -D -m 0644 $(@D)/boot/fixup$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).dat $(BINARIES_DIR)/rpi-firmware/fixup.dat
	$(RPI_FIRMWARE_INSTALL_BOOTCODE_BIN)
	$(RPI_FIRMWARE_INSTALL_DTB)
	$(RPI_FIRMWARE_INSTALL_DTB_OVERLAYS)
endef

$(eval $(generic-package))
