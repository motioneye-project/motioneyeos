################################################################################
#
# linux-firmware
#
################################################################################

LINUX_FIRMWARE_VERSION = 52d77db9f133afe4d2b26aeccfd603745f45fda1
LINUX_FIRMWARE_SITE = http://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
LINUX_FIRMWARE_SITE_METHOD = git

# rt2501/rt61
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RALINK_RT61),y)
LINUX_FIRMWARE_FILES_ += rt2561.bin rt2561s.bin rt2661.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ralink-firmware.txt
endif

# rt73
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RALINK_RT73),y)
LINUX_FIRMWARE_FILES += rt73.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ralink-firmware.txt
endif

# rt2xx
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RALINK_RT2XX),y)
LINUX_FIRMWARE_FILES += rt2860.bin rt2870.bin rt3070.bin rt3071.bin rt3090.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ralink-firmware.txt
endif

# rtl81xx
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RTL_81XX),y)
LINUX_FIRMWARE_FILES += \
	rtlwifi/rtl8192cfw.bin rtlwifi/rtl8192cfwU.bin 		\
	rtlwifi/rtl8192cfwU_B.bin rtlwifi/rtl8192cufw.bin	\
	rtlwifi/rtl8192defw.bin rtlwifi/rtl8192sefw.bin		\
	rtlwifi/rtl8188efw.bin rtlwifi/rtl8192cufw_A.bin	\
	rtlwifi/rtl8192cufw_B.bin rtlwifi/rtl8192cufw_TMSC.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.rtlwifi_firmware.txt
endif

# rtl87xx
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_RTL_87XX),y)
LINUX_FIRMWARE_FILES += rtlwifi/rtl8712u.bin rtlwifi/rtl8723fw.bin	\
	rtlwifi/rtl8723fw_B.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.rtlwifi_firmware.txt
endif

# ar7010
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_ATHEROS_7010),y)
LINUX_FIRMWARE_FILES += ar7010.fw ar7010_1_1.fw htc_7010.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.atheros_firmware
endif

# ar9170
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_ATHEROS_9170),y)
LINUX_FIRMWARE_FILES += ar9170-1.fw ar9170-2.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.atheros_firmware
endif

# ar9271
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_ATHEROS_9271),y)
LINUX_FIRMWARE_FILES += ar9271.fw htc_9271.fw
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
LINUX_FIRMWARE_FILES += libertas/sd8688.bin libertas/sd8688_helper.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# sd8787
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_MWIFIEX_SD8787),y)
LINUX_FIRMWARE_FILES += mrvl/sd8787_uapsta.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.Marvell
endif

# wl127x
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_TI_WL127X),y)
LINUX_FIRMWARE_FILES += \
	ti-connectivity/wl1271-fw-2.bin				\
	ti-connectivity/wl1271-fw-ap.bin			\
	ti-connectivity/wl1271-fw.bin				\
	ti-connectivity/wl1271-nvs.bin				\
	ti-connectivity/wl127x-fw-3.bin				\
	ti-connectivity/wl127x-fw-plt-3.bin			\
	ti-connectivity/wl127x-nvs.bin				\
	ti-connectivity/wl127x-fw-4-mr.bin			\
	ti-connectivity/wl127x-fw-4-plt.bin			\
	ti-connectivity/wl127x-fw-4-sr.bin			\
	ti-connectivity/wl127x-fw-5-mr.bin			\
	ti-connectivity/wl127x-fw-5-plt.bin			\
	ti-connectivity/wl127x-fw-5-sr.bin			\
	ti-connectivity/TIInit_7.2.31.bts
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ti-connectivity
endif

# wl128x
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_TI_WL128X),y)
LINUX_FIRMWARE_FILES += \
	ti-connectivity/wl128x-fw-3.bin				\
	ti-connectivity/wl128x-fw-ap.bin			\
	ti-connectivity/wl128x-fw-plt-3.bin			\
	ti-connectivity/wl128x-fw.bin				\
	ti-connectivity/wl1271-nvs.bin				\
	ti-connectivity/wl128x-nvs.bin				\
	ti-connectivity/wl12xx-nvs.bin				\
	ti-connectivity/wl128x-fw-4-mr.bin			\
	ti-connectivity/wl128x-fw-4-plt.bin			\
	ti-connectivity/wl128x-fw-4-sr.bin			\
	ti-connectivity/wl128x-fw-5-mr.bin			\
	ti-connectivity/wl128x-fw-5-plt.bin			\
	ti-connectivity/wl128x-fw-5-sr.bin			\
	ti-connectivity/TIInit_7.2.31.bts
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.ti-connectivity
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_3160),y)
LINUX_FIRMWARE_FILES += iwlwifi-3160-7.ucode
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

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_IWLWIFI_7260),y)
LINUX_FIRMWARE_FILES += iwlwifi-7260-7.ucode
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.iwlwifi_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_BNX2X),y)
LINUX_FIRMWARE_FILES += \
	bnx2x/bnx2x-e1-7.8.17.0.fw \
	bnx2x/bnx2x-e1h-7.8.17.0.fw \
	bnx2x/bnx2x-e2-7.8.17.0.fw
# No license file; the license is in the file WHENCE
# which is installed unconditionally
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_CXGB4),y)
LINUX_FIRMWARE_FILES += \
	cxgb4/t4fw-1.9.23.0.bin \
	cxbg4/t4fw.bin
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.chelsio_firmware
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_XC5000),y)
LINUX_FIRMWARE_FILES += dvb-fe-xc5000-1.6.114.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.xc5000
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_DIB0700),y)
LINUX_FIRMWARE_FILES += dvb-usb-dib0700-1.20.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENSE.dib0700
endif

ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_H5_DRXK),y)
LINUX_FIRMWARE_FILES += dvb-usb-terratec-h5-drxk.fw
# No license file; the license is in the file WHENCE
# which is installed unconditionally
endif

# brcm
ifeq ($(BR2_PACKAGE_LINUX_FIRMWARE_BRCM_BCM43XX),y)
LINUX_FIRMWARE_FILES += brcm/bcm43xx-0.fw brcm/bcm43xx_hdr-0.fw
LINUX_FIRMWARE_ALL_LICENSE_FILES += LICENCE.broadcom_bcm43xx
endif

ifneq ($(LINUX_FIRMWARE_FILES),)

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

define LINUX_FIRMWARE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware
	$(TAR) c -C $(@D) $(LINUX_FIRMWARE_FILES) | \
		$(TAR) x -C $(TARGET_DIR)/lib/firmware
endef

endif

$(eval $(generic-package))
