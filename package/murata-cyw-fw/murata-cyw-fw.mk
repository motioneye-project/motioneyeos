################################################################################
#
# murata-cyw-fw
#
################################################################################

MURATA_CYW_FW_VERSION = 8d87950bfad28c65926695b7357bd8995b60016a
MURATA_CYW_FW_VERSION_NVRAM = d27f1bf105fa1e5b828e355793b88d4b66188411
MURATA_CYW_FW_VERSION_BT_PATCH = 748462f0b02ec4aeb500bedd60780ac51c37be31
MURATA_CYW_FW_SITE = $(call github,murata-wireless,cyw-fmac-fw,$(MURATA_CYW_FW_VERSION))
MURATA_CYW_FW_EXTRA_DOWNLOADS = \
	$(call github,murata-wireless,cyw-fmac-nvram,$(MURATA_CYW_FW_VERSION_NVRAM))/cyw-fmac-nvram-$(MURATA_CYW_FW_VERSION_NVRAM).tar.gz \
	$(call github,murata-wireless,cyw-bt-patch,$(MURATA_CYW_FW_VERSION_BT_PATCH))/cyw-bt-patch-$(MURATA_CYW_FW_VERSION_BT_PATCH).tar.gz
MURATA_CYW_FW_LICENSE = PROPRIETARY
MURATA_CYW_FW_LICENSE_FILES = LICENCE.cypress
MURATA_CYW_FW_REDISTRIBUTE = NO

define MURATA_CYW_FW_EXTRACT_NVRAM_PATCH
	$(foreach tar,$(notdir $(MURATA_CYW_FW_EXTRA_DOWNLOADS)), \
		$(call suitable-extractor,$(tar)) $(MURATA_CYW_FW_DL_DIR)/$(tar) | \
		$(TAR) --strip-components=1 -C $(@D) $(TAR_OPTIONS) -
	)
endef
MURATA_CYW_FW_POST_EXTRACT_HOOKS += MURATA_CYW_FW_EXTRACT_NVRAM_PATCH

MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW43012) += \
	brcmfmac43012-sdio.bin \
	brcmfmac43012-sdio.1LV.clm_blob \
	brcmfmac43012-sdio.1LV.txt \
	CYW43012C0.1LV.hcd
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW43340) += \
	brcmfmac43340-sdio.bin \
	brcmfmac43340-sdio.1BW.txt \
	CYW43341B0.1BW.hcd
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW43362) += \
	brcmfmac43362-sdio.bin \
	brcmfmac43362-sdio.SN8000.txt
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW4339) += \
	brcmfmac4339-sdio.bin
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW4339_1CK) += \
	brcmfmac4339-sdio.1CK.txt
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW4339_ZP) += \
	brcmfmac4339-sdio.ZP.txt \
	CYW4335C0.ZP.hcd
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW43430) += \
	brcmfmac43430-sdio.bin
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW43430_1DX) += \
	brcmfmac43430-sdio.1DX.clm_blob \
	brcmfmac43430-sdio.1DX.txt \
	CYW43430A1.1DX.hcd
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW43430_1FX) += \
	brcmfmac43430-sdio.1FX.clm_blob \
	brcmfmac43430-sdio.1FX.txt
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW43430_1LN) += \
	brcmfmac43430-sdio.1LN.clm_blob \
	brcmfmac43430-sdio.1LN.txt
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW43455) += \
	brcmfmac43455-sdio.bin
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW43455_1HK) += \
	brcmfmac43455-sdio.1HK.clm_blob \
	brcmfmac43455-sdio.1HK.txt
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW43455_1LC) += \
	brcmfmac43455-sdio.1LC.clm_blob \
	brcmfmac43455-sdio.1LC.txt
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW43455_1MW) += \
	brcmfmac43455-sdio.1MW.clm_blob \
	brcmfmac43455-sdio.1MW.txt \
	CYW4345C0.1MW.hcd
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW4354) += \
	brcmfmac4354-sdio.bin \
	brcmfmac4354-sdio.1BB.clm_blob \
	brcmfmac4354-sdio.1BB.txt \
	CYW4350C0.1BB.hcd
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW4356) += \
	brcmfmac4356-pcie.bin \
	brcmfmac4356-pcie.1CX.clm_blob \
	brcmfmac4356-pcie.1CX.txt \
	CYW4354A2.1CX.hcd
MURATA_CYW_FW_FILES_$(BR2_PACKAGE_MURATA_CYW_FW_CYW4359) += \
	brcmfmac4359-pcie.bin \
	brcmfmac4359-pcie.1FD.clm_blob

# Helper that assumes filename with model has two dots (CHIP.MODEL.EXT),
# but filename without model has only single dot (CHIP.EXT).
murata-cyw-fw-strip-model = $(shell echo -n $(1) | sed 's/\..*\./\./')

# Helper that strips model name and renames Bluetooth patch files to the ones
# expected by Linux kernel.
murata-cyw-fw-file-rename = $(call murata-cyw-fw-strip-model,$(patsubst CYW%,BCM%,$(f)))

define MURATA_CYW_FW_INSTALL_TARGET_CMDS
	$(foreach f,$(MURATA_CYW_FW_FILES_y), \
		$(INSTALL) -m 0644 -D $(@D)/$(f) \
			$(TARGET_DIR)/lib/firmware/brcm/$(call murata-cyw-fw-file-rename,$(f))
	)
endef

$(eval $(generic-package))
