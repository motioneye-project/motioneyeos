################################################################################
#
# vexpress-firmware
#
################################################################################

VEXPRESS_FIRMWARE_VERSION = 901f81977c3b367a2e0bf3d6444be302822d97a3
VEXPRESS_FIRMWARE_SITE = https://git.linaro.org/arm/vexpress-firmware.git
VEXPRESS_FIRMWARE_SITE_METHOD = git
# The only available license files are in PDF and RTF formats, and we
# support only plain text.
VEXPRESS_FIRMWARE_LICENSE = ARM EULA

VEXPRESS_FIRMWARE_INSTALL_IMAGES = YES

define VEXPRESS_FIRMWARE_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/SOFTWARE/bl30.bin $(BINARIES_DIR)/scp-fw.bin
endef

$(eval $(generic-package))
