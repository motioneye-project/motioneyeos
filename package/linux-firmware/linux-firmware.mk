################################################################################
#
# linux-firmware
#
################################################################################

LINUX_FIRMWARE_VERSION = 20200122
LINUX_FIRMWARE_SITE = http://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
LINUX_FIRMWARE_SITE_METHOD = git

# Intel SST DSP
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_INTEL_SST_DSP),y)
LINUX_FIRMWARE_FILES += intel/fw_sst_0f28.bin-48kHz_i2s_master
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.fw_sst_0f28
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_AMDGPU),y)
LINUX_FIRMWARE_DIRS += amdgpu
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENSE.amdgpu
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_I915),y)
LINUX_FIRMWARE_DIRS += i915
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENSE.i915
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RADEON),y)
LINUX_FIRMWARE_DIRS += radeon
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENSE.radeon
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_QCOM_VENUS),y)
LINUX_FIRMWARE_DIRS += qcom/venus-1.8 qcom/venus-4.2
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENSE.qcom qcom/NOTICE.txt
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_QCOM_ADRENO),y)
LINUX_FIRMWARE_FILES += qcom/a*
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENSE.qcom qcom/NOTICE.txt
endif

# Intel Wireless Bluetooth
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IBT),y)
LINUX_FIRMWARE_FILES += intel/ibt-*
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ibt_firmware
endif

# Qualcomm Atheros Rome 6174A Bluetooth
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_QUALCOMM_6174A_BT),y)
LINUX_FIRMWARE_FILES += qca/rampatch_usb_00000302.bin qca/nvm_usb_00000302.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENSE.qcom
endif

# Freescale i.MX SDMA
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IMX_SDMA),y)
LINUX_FIRMWARE_FILES += imx/sdma/sdma-imx6q.bin imx/sdma/sdma-imx7d.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENSE.sdma_firmware
endif

# rt2501/rt61
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RALINK_RT61),y)
LINUX_FIRMWARE_FILES += rt2561.bin rt2561s.bin rt2661.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ralink-firmware.txt
endif

# rt73
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RALINK_RT73),y)
LINUX_FIRMWARE_FILES += rt73.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ralink-firmware.txt
endif

# rt2xx
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RALINK_RT2XX),y)
LINUX_FIRMWARE_FILES += rt2860.bin rt2870.bin rt3071.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ralink-firmware.txt
endif

# rtl81xx
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RTL_81XX),y)
LINUX_FIRMWARE_FILES += \
	rtlwifi/rtl8192cfw.bin rtlwifi/rtl8192cfwU.bin \
	rtlwifi/rtl8192cfwU_B.bin rtlwifi/rtl8192cufw.bin \
	rtlwifi/rtl8192defw.bin rtlwifi/rtl8192sefw.bin \
	rtlwifi/rtl8188efw.bin rtlwifi/rtl8188eufw.bin \
	rtlwifi/rtl8192cufw_A.bin \
	rtlwifi/rtl8192cufw_B.bin rtlwifi/rtl8192cufw_TMSC.bin \
	rtlwifi/rtl8192eefw.bin rtlwifi/rtl8192eu_ap_wowlan.bin \
	rtlwifi/rtl8192eu_nic.bin rtlwifi/rtl8192eu_wowlan.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.rtlwifi_firmware.txt
endif

# rtl87xx
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RTL_87XX),y)
LINUX_FIRMWARE_FILES += \
	rtlwifi/rtl8712u.bin rtlwifi/rtl8723fw.bin \
	rtlwifi/rtl8723fw_B.bin rtlwifi/rtl8723befw.bin \
	rtlwifi/rtl8723aufw_A.bin rtlwifi/rtl8723aufw_B.bin \
	rtlwifi/rtl8723aufw_B_NoBT.bin rtlwifi/rtl8723befw.bin \
	rtlwifi/rtl8723bs_ap_wowlan.bin rtlwifi/rtl8723bs_bt.bin \
	rtlwifi/rtl8723bs_nic.bin rtlwifi/rtl8723bs_wowlan.bin \
	rtlwifi/rtl8723bu_ap_wowlan.bin rtlwifi/rtl8723bu_nic.bin \
	rtlwifi/rtl8723bu_wowlan.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.rtlwifi_firmware.txt
endif

# rtl88xx
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RTL_88XX),y)
LINUX_FIRMWARE_FILES += \
	rtlwifi/rtl8821aefw.bin \
	rtlwifi/rtl8821aefw_wowlan.bin \
	rtlwifi/rtl8821aefw_29.bin rtlwifi/rtl8822befw.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.rtlwifi_firmware.txt
endif

# rtw88
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RTL_RTW88),y)
LINUX_FIRMWARE_FILES += \
	rtw88/rtw8723d_fw.bin \
	rtw88/rtw8822b_fw.bin \
	rtw88/rtw8822c_fw.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.rtlwifi_firmware.txt
endif

# ar3011
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_AR3011),y)
LINUX_FIRMWARE_FILES += ath3k-1.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.atheros_firmware
endif

# ar3012
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_AR3012_USB),y)
LINUX_FIRMWARE_FILES += \
	ar3k/AthrBT_0x01020001.dfu \
	ar3k/ramps_0x01020001_26.dfu \
	ar3k/AthrBT_0x01020200.dfu \
	ar3k/ramps_0x01020200_26.dfu \
	ar3k/ramps_0x01020200_40.dfu \
	ar3k/AthrBT_0x31010000.dfu \
	ar3k/ramps_0x31010000_40.dfu \
	ar3k/AthrBT_0x11020000.dfu \
	ar3k/ramps_0x11020000_40.dfu \
	ar3k/ramps_0x01020201_26.dfu \
	ar3k/ramps_0x01020201_40.dfu \
	ar3k/AthrBT_0x41020000.dfu \
	ar3k/ramps_0x41020000_40.dfu \
	ar3k/AthrBT_0x11020100.dfu \
	ar3k/ramps_0x11020100_40.dfu \
	ar3k/AthrBT_0x31010100.dfu \
	ar3k/ramps_0x31010100_40.dfu \
	ar3k/AthrBT_0x01020201.dfu
LINUX_FIRMWARE_ALL_LICENSE_FILES += \
	LICENCE.atheros_firmware LICENSE.QualcommAtheros_ar3k
endif

# ar6002
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_ATHEROS_6002),y)
LINUX_FIRMWARE_FILES += ath6k/AR6002
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.atheros_firmware
endif

# ar6003
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_ATHEROS_6003),y)
LINUX_FIRMWARE_FILES += ath6k/AR6003
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.atheros_firmware
endif

# ar6004
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_ATHEROS_6004),y)
LINUX_FIRMWARE_FILES += ath6k/AR6004
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.atheros_firmware
endif

# ar7010
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_ATHEROS_7010),y)
LINUX_FIRMWARE_FILES += ar7010.fw ar7010_1_1.fw htc_7010.fw ath9k_htc/htc_7010-1.4.0.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.atheros_firmware
endif

# ar9170
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_ATHEROS_9170),y)
LINUX_FIRMWARE_FILES += ar9170-1.fw ar9170-2.fw carl9170-1.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.atheros_firmware
endif

# ar9271
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_ATHEROS_9271),y)
LINUX_FIRMWARE_FILES += ar9271.fw htc_9271.fw ath9k_htc/htc_9271-1.4.0.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.atheros_firmware
endif

# ath10k
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_ATHEROS_10K_QCA998X),y)
LINUX_FIRMWARE_FILES += ath10k/QCA988X/hw2.0/board.bin \
			ath10k/QCA988X/hw2.0/firmware-4.bin \
			ath10k/QCA988X/hw2.0/firmware-5.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.atheros_firmware
endif

# sd8686 v8
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_LIBERTAS_SD8686_V8),y)
LINUX_FIRMWARE_FILES += libertas/sd8686_v8.bin libertas/sd8686_v8_helper.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# sd8686 v9
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_LIBERTAS_SD8686_V9),y)
LINUX_FIRMWARE_FILES += libertas/sd8686_v9.bin libertas/sd8686_v9_helper.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# sd8688
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_LIBERTAS_SD8688),y)
LINUX_FIRMWARE_FILES += mrvl/sd8688.bin mrvl/sd8688_helper.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# usb8388 v9
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_LIBERTAS_USB8388_V9),y)
LINUX_FIRMWARE_FILES += libertas/usb8388_v9.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# usb8388 olpc
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_LIBERTAS_USB8388_OLPC),y)
LINUX_FIRMWARE_FILES += libertas/usb8388_olpc.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# lbtf usb
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_LIBERTAS_USB_THINFIRM),y)
LINUX_FIRMWARE_FILES += lbtf_usb.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# sd8787
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MWIFIEX_SD8787),y)
LINUX_FIRMWARE_FILES += mrvl/sd8787_uapsta.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# sd8797
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MWIFIEX_SD8797),y)
LINUX_FIRMWARE_FILES += mrvl/sd8797_uapsta.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# usb8797
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MWIFIEX_USB8797),y)
LINUX_FIRMWARE_FILES += mrvl/usb8797_uapsta.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# usb8801
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MWIFIEX_USB8801),y)
LINUX_FIRMWARE_FILES += mrvl/usb8801_uapsta.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# sd8887
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MWIFIEX_SD8887),y)
LINUX_FIRMWARE_FILES += mrvl/sd8887_uapsta.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# sd8897
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MWIFIEX_SD8897),y)
LINUX_FIRMWARE_FILES += mrvl/sd8897_uapsta.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# usb8897
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MWIFIEX_USB8897),y)
LINUX_FIRMWARE_FILES += mrvl/usb8897_uapsta.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# pcie8897
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MWIFIEX_PCIE8897),y)
LINUX_FIRMWARE_FILES += mrvl/pcie8897_uapsta.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# MT7601
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MEDIATEK_MT7601U),y)
LINUX_FIRMWARE_FILES += mt7601u.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ralink_a_mediatek_company_firmware
endif

# MT7650
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MEDIATEK_MT7650),y)
LINUX_FIRMWARE_FILES += mt7650.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ralink_a_mediatek_company_firmware
endif

# MT76x2e
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MEDIATEK_MT76X2E),y)
LINUX_FIRMWARE_FILES += mt7662.bin mt7662_rom_patch.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ralink_a_mediatek_company_firmware
endif

# qca6174
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_QUALCOMM_6174),y)
LINUX_FIRMWARE_FILES += ath10k/QCA6174
LINUX_FIRMWARE_ALL_LICENSE_FILES += \
	LICENSE.QualcommAtheros_ath10k \
	ath10k/QCA6174/hw2.1/notice_ath10k_firmware-5.txt \
	ath10k/QCA6174/hw3.0/notice_ath10k_firmware-4.txt \
	ath10k/QCA6174/hw3.0/notice_ath10k_firmware-6.txt
endif

# CC2560(A)
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_TI_CC2560),y)
LINUX_FIRMWARE_FILES += \
	ti-connectivity/TIInit_6.2.31.bts \
	ti-connectivity/TIInit_6.6.15.bts
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ti-connectivity
endif

# wl127x
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_TI_WL127X),y)
LINUX_FIRMWARE_FILES += \
	ti-connectivity/wl1271-fw-2.bin \
	ti-connectivity/wl1271-fw-ap.bin \
	ti-connectivity/wl1271-fw.bin \
	ti-connectivity/wl127x-fw-3.bin \
	ti-connectivity/wl127x-fw-plt-3.bin \
	ti-connectivity/wl127x-nvs.bin \
	ti-connectivity/wl127x-fw-4-mr.bin \
	ti-connectivity/wl127x-fw-4-plt.bin \
	ti-connectivity/wl127x-fw-4-sr.bin \
	ti-connectivity/wl127x-fw-5-mr.bin \
	ti-connectivity/wl127x-fw-5-plt.bin \
	ti-connectivity/wl127x-fw-5-sr.bin \
	ti-connectivity/TIInit_7.2.31.bts
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ti-connectivity
endif

# wl128x
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_TI_WL128X),y)
LINUX_FIRMWARE_FILES += \
	ti-connectivity/wl128x-fw-3.bin \
	ti-connectivity/wl128x-fw-ap.bin \
	ti-connectivity/wl128x-fw-plt-3.bin \
	ti-connectivity/wl128x-fw.bin \
	ti-connectivity/wl128x-nvs.bin \
	ti-connectivity/wl127x-nvs.bin \
	ti-connectivity/wl128x-fw-4-mr.bin \
	ti-connectivity/wl128x-fw-4-plt.bin \
	ti-connectivity/wl128x-fw-4-sr.bin \
	ti-connectivity/wl128x-fw-5-mr.bin \
	ti-connectivity/wl128x-fw-5-plt.bin \
	ti-connectivity/wl128x-fw-5-sr.bin \
	ti-connectivity/TIInit_7.2.31.bts
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ti-connectivity
endif

# wl18xx
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_TI_WL18XX),y)
LINUX_FIRMWARE_FILES += \
	ti-connectivity/wl18xx-fw.bin \
	ti-connectivity/wl18xx-fw-2.bin \
	ti-connectivity/wl18xx-fw-3.bin \
	ti-connectivity/wl18xx-fw-4.bin \
	ti-connectivity/wl127x-nvs.bin \
	ti-connectivity/TIInit_7.2.31.bts
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ti-connectivity
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_QUALCOMM_WIL6210),y)
LINUX_FIRMWARE_FILES += wil6210.*
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENSE.QualcommAtheros_ath10k
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_3160),y)
LINUX_FIRMWARE_FILES += iwlwifi-3160-*.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_3168),y)
LINUX_FIRMWARE_FILES += iwlwifi-3168-*.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

# iwlwifi 5000. Multiple files are available (iwlwifi-5000-1.ucode,
# iwlwifi-5000-2.ucode, iwlwifi-5000-5.ucode), corresponding to
# different versions of the firmware API. For now, we only install the
# most recent one.
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_5000),y)
LINUX_FIRMWARE_FILES += iwlwifi-5000-5.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_6000G2A),y)
LINUX_FIRMWARE_FILES += iwlwifi-6000g2a-6.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_6000G2B),y)
LINUX_FIRMWARE_FILES += iwlwifi-6000g2b-6.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_7260),y)
LINUX_FIRMWARE_FILES += iwlwifi-7260-*.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_7265),y)
LINUX_FIRMWARE_FILES += iwlwifi-7265-*.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_7265D),y)
LINUX_FIRMWARE_FILES += iwlwifi-7265D-*.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_8000C),y)
LINUX_FIRMWARE_FILES += iwlwifi-8000C-*.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_8265),y)
LINUX_FIRMWARE_FILES += iwlwifi-8265-*.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_9XXX),y)
LINUX_FIRMWARE_FILES += iwlwifi-9???-*.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_BNX2X),y)
LINUX_FIRMWARE_FILES += bnx2x/*
# No license file; the license is in the file WHENCE
# which is installed unconditionally
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_CXGB4_T4),y)
LINUX_FIRMWARE_FILES += cxgb4/t4fw*.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.chelsio_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_CXGB4_T5),y)
LINUX_FIRMWARE_FILES += cxgb4/t5fw*.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.chelsio_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_INTEL_E100),y)
LINUX_FIRMWARE_FILES += e100/*.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.e100
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MICROCHIP_VSC85XX_PHY),y)
LINUX_FIRMWARE_FILES += microchip/mscc_vsc85*.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.microchip
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_QLOGIC_4X),y)
LINUX_FIRMWARE_FILES += \
	qed/qed_init_values_zipped-*.bin
# No license file; the license is in the file WHENCE
# which is installed unconditionally
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RTL_8169),y)
LINUX_FIRMWARE_FILES += \
	rtl_nic/rtl8105e-1.fw \
	rtl_nic/rtl8106e-1.fw \
	rtl_nic/rtl8106e-2.fw \
	rtl_nic/rtl8107e-1.fw \
	rtl_nic/rtl8107e-2.fw \
	rtl_nic/rtl8125a-3.fw \
	rtl_nic/rtl8168d-1.fw \
	rtl_nic/rtl8168d-2.fw \
	rtl_nic/rtl8168e-1.fw \
	rtl_nic/rtl8168e-2.fw \
	rtl_nic/rtl8168e-3.fw \
	rtl_nic/rtl8168f-1.fw \
	rtl_nic/rtl8168f-2.fw \
	rtl_nic/rtl8168fp-3.fw \
	rtl_nic/rtl8168g-2.fw \
	rtl_nic/rtl8168g-3.fw \
	rtl_nic/rtl8168h-1.fw \
	rtl_nic/rtl8168h-2.fw \
	rtl_nic/rtl8402-1.fw \
	rtl_nic/rtl8411-1.fw \
	rtl_nic/rtl8411-2.fw
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_XCx000),y)
LINUX_FIRMWARE_FILES += \
	dvb-fe-xc4000-1.4.1.fw \
	dvb-fe-xc5000-1.6.114.fw \
	dvb-fe-xc5000c-4.1.30.7.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += \
	LICENCE.xc4000 \
	LICENCE.xc5000 \
	LICENCE.xc5000c
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_AS102),y)
LINUX_FIRMWARE_FILES += as102_data1_st.hex as102_data2_st.hex
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Abilis
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_DIB0700),y)
LINUX_FIRMWARE_FILES += dvb-usb-dib0700-1.20.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENSE.dib0700
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_ITETECH_IT9135),y)
LINUX_FIRMWARE_FILES += dvb-usb-it9135-01.fw dvb-usb-it9135-02.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.it913x
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_H5_DRXK),y)
LINUX_FIRMWARE_FILES += dvb-usb-terratec-h5-drxk.fw
# No license file; the license is in the file WHENCE
# which is installed unconditionally
endif

# brcm43xx
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_BRCM_BCM43XX),y)
LINUX_FIRMWARE_FILES += \
	brcm/bcm43xx-0.fw brcm/bcm43xx_hdr-0.fw \
	brcm/bcm4329-fullmac-4.bin brcm/brcmfmac4329-sdio.bin \
	brcm/brcmfmac4330-sdio.bin brcm/brcmfmac4334-sdio.bin \
	brcm/brcmfmac4335-sdio.bin brcm/brcmfmac4339-sdio.bin \
	brcm/brcmfmac4350-pcie.bin brcm/brcmfmac4354-sdio.bin \
	brcm/brcmfmac4356-pcie.bin brcm/brcmfmac4371-pcie.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.broadcom_bcm43xx
endif

# brcm43xxx
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_BRCM_BCM43XXX),y)
LINUX_FIRMWARE_FILES += \
	brcm/brcmfmac43143.bin brcm/brcmfmac43143-sdio.bin \
	brcm/brcmfmac43236b.bin brcm/brcmfmac43241b0-sdio.bin \
	brcm/brcmfmac43241b4-sdio.bin brcm/brcmfmac43241b5-sdio.bin \
	brcm/brcmfmac43242a.bin brcm/brcmfmac43340-sdio.bin \
	brcm/brcmfmac43362-sdio.bin brcm/brcmfmac43430-sdio.bin \
	brcm/brcmfmac43430a0-sdio.bin brcm/brcmfmac43455-sdio.bin \
	brcm/brcmfmac43569.bin brcm/brcmfmac43570-pcie.bin \
	brcm/brcmfmac43602-pcie.ap.bin brcm/brcmfmac43602-pcie.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.broadcom_bcm43xx
endif

# ql2xxx
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_QLOGIC_2XXX),y)
LINUX_FIRMWARE_FILES += \
	ql2100_fw.bin ql2200_fw.bin ql2300_fw.bin ql2322_fw.bin \
	ql2400_fw.bin ql2500_fw.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.qla2xxx
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_REDPINE_RS9113),y)
LINUX_FIRMWARE_FILES += \
	rsi/rs9113_ap_bt_dual_mode.rps \
	rsi/rs9113_wlan_bt_dual_mode.rps \
	rsi/rs9113_wlan_qspi.rps
# No license file; the license is in the file WHENCE
# which is installed unconditionally
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_QAT_DH895XCC),y)
LINUX_FIRMWARE_FILES += qat_895xcc.bin qat_895xcc_mmp.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.qat_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_QAT_C3XXX),y)
LINUX_FIRMWARE_FILES += qat_c3xxx.bin qat_c3xxx_mmp.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.qat_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_QAT_C62X),y)
LINUX_FIRMWARE_FILES += qat_c62x.bin qat_c62x_mmp.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.qat_firmware
endif

ifneq ($(LINUX_FIRMWARE_FILES),)
define LINUX_FIRMWARE_INSTALL_FILES
	cd $(@D) && \
		$(TAR) cf install.tar $(sort $(LINUX_FIRMWARE_FILES)) && \
		$(TAR) xf install.tar -C $(TARGET_DIR)/lib/firmware
endef
endif

ifneq ($(LINUX_FIRMWARE_DIRS),)
# We need to rm-rf the destination directory to avoid copying
# into it in itself, should we re-install the package.
define LINUX_FIRMWARE_INSTALL_DIRS
	$(foreach d,$(LINUX_FIRMWARE_DIRS), \
		rm -rf $(TARGET_DIR)/lib/firmware/$(d); \
		mkdir -p $(dir $(TARGET_DIR)/lib/firmware/$(d)); \
		cp -a $(@D)/$(d) $(TARGET_DIR)/lib/firmware/$(d)$(sep))
endef
endif

ifneq ($(LINUX_FIRMWARE_FILES)$(LINUX_FIRMWARE_DIRS),)

# Most firmware files are under a proprietary license, so no need to
# repeat it for every selections above. Those firmwares that have more
# lax licensing terms may still add them on a per-case basis.
LINUX_FIRMWARE_LICENSE += Proprietary

# This file contains some licensing information about all the firmware
# files found in the linux-firmware package, so we always add it, even
# for firmwares that have their own licensing terms.
LINUX_FIRMWARE_ALL_LICENSE_FILES += WHENCE

# Some license files may be listed more than once, so we have to remove
# duplicates
LINUX_FIRMWARE_LICENSE_FILES = $(sort $(LINUX_FIRMWARE_ALL_LICENSE_FILES))

endif

# Some firmware are distributed as a symlink, for drivers to load them using a
# defined name other than the real one. Since 9cfefbd7fbda ("Remove duplicate
# symlinks") those symlink aren't distributed in linux-firmware but are created
# automatically by its copy-firmware.sh script during the installation, which
# parses the WHENCE file where symlinks are described. We follow the same logic
# here, adding symlink only for firmwares installed in the target directory.
#
# For testing the presence of firmwares in the target directory we first make
# sure we canonicalize the pointed-to file, to cover the symlinks of the form
# a/foo -> ../b/foo  where a/ (the directory where to put the symlink) does
# not yet exist.
define LINUX_FIRMWARE_CREATE_SYMLINKS
	cd $(TARGET_DIR)/lib/firmware/ ; \
	sed -r -e '/^Link: (.+) -> (.+)$$/!d; s//\1 \2/' $(@D)/WHENCE | \
	while read f d; do \
		if test -f $$(readlink -m $$(dirname $$f)/$$d); then \
			mkdir -p $$(dirname $$f) || exit 1; \
			ln -sf $$d $$f || exit 1; \
		fi ; \
	done
endef

define LINUX_FIRMWARE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware
	$(LINUX_FIRMWARE_INSTALL_FILES)
	$(LINUX_FIRMWARE_INSTALL_DIRS)
	$(LINUX_FIRMWARE_CREATE_SYMLINKS)
endef

$(eval $(generic-package))
