################################################################################
#
# ux500-firmware
#
################################################################################

UX500_FIRMWARE_VERSION = 1.1.3-6
UX500_FIRMWARE_SOURCE = ux500-firmware_$(UX500_FIRMWARE_VERSION)linaro1.tar.gz
UX500_FIRMWARE_SITE = https://launchpad.net/~igloocommunity-maintainers/+archive/snowball/+files
UX500_FIRMWARE_LICENSE = Snowball click-wrap license
UX500_FIRMWARE_LICENSE_FILES = license.txt
UX500_FIRMWARE_REDISTRIBUTE = NO

# The CG2900 linux driver has to load firmware named CG29XX_* but the firmware
# filenames contained in this package are CG2900_* hence the code below
define UX500_FIRMWARE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	for f in $(TARGET_DIR)/lib/firmware/CG2900* ; do \
		mv $$f $${f/CG2900/CG29XX}; \
	done
endef

$(eval $(generic-package))
