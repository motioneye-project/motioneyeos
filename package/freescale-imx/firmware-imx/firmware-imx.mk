################################################################################
#
# firmware-imx
#
################################################################################

FIRMWARE_IMX_VERSION = $(FREESCALE_IMX_VERSION)
FIRMWARE_IMX_SITE = $(FREESCALE_IMX_MIRROR_SITE)
FIRMWARE_IMX_SOURCE = firmware-imx-$(FIRMWARE_IMX_VERSION).bin
FIRMWARE_IMX_LICENSE = Freescale Semiconductor Software License Agreement, \
	Atheros license (ath6k)
FIRMWARE_IMX_LICENSE_FILES = licenses/vpu/EULA licenses/ath6k/AR6102/License.txt
# This is a legal minefield: the EULA specifies that
# the Board Support Package includes software and hardware (sic!)
# for which a separate license is needed...
FIRMWARE_IMX_REDISTRIBUTE = NO

FIRMWARE_IMX_BLOBS = ath6k sdma vpu

# The archive is a shell-self-extractor of a bzipped tar. It happens
# to extract in the correct directory (firmware-imx-x.y.z)
# The --force makes sure it doesn't fail if the source dir already exists.
# The --auto-accept skips the license check - not needed for us
# because we have legal-info.
define FIRMWARE_IMX_EXTRACT_CMDS
	cd $(BUILD_DIR); \
	sh $(DL_DIR)/$(FIRMWARE_IMX_SOURCE) --force --auto-accept
endef


define FIRMWARE_IMX_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware
	for blobdir in $(FIRMWARE_IMX_BLOBS); do \
		cp -r $(@D)/firmware/$${blobdir} $(TARGET_DIR)/lib/firmware; \
	done
endef

$(eval $(generic-package))
