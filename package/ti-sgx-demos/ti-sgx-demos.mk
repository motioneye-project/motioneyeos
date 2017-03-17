################################################################################
#
# ti-sgx-demos
#
################################################################################

# This correpsonds to SDK 02.00.00.00
TI_SGX_DEMOS_VERSION = f24650bc8243b25c23d6a0a502ed79fc472ac424
TI_SGX_DEMOS_SITE = git://git.ti.com/graphics/img-pvr-sdk.git
TI_SGX_DEMOS_LICENSE = Imagination Technologies License Agreement
TI_SGX_DEMOS_LICENSE_FILES = LegalNotice.txt

define TI_SGX_DEMOS_INSTALL_TARGET_CMDS
	cp -dpfr $(@D)/targetfs/Examples/Advanced/OGLES* \
		$(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
