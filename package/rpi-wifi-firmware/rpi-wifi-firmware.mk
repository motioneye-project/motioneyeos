################################################################################
#
# rpi-wifi-firmware
#
################################################################################

RPI_WIFI_FIRMWARE_VERSION = 54bab3d6a6d43239c71d26464e6e10e5067ffea7
# brcmfmac43430-sdio.bin comes from linux-firmware
RPI_WIFI_FIRMWARE_SOURCE = brcmfmac43430-sdio.txt
# git repo contains a lot of unrelated files
RPI_WIFI_FIRMWARE_SITE = https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/$(RPI_WIFI_FIRMWARE_VERSION)/brcm80211/brcm
RPI_WIFI_FIRMWARE_LICENSE = PROPRIETARY

define RPI_WIFI_FIRMWARE_EXTRACT_CMDS
	cp $(DL_DIR)/$($(PKG)_SOURCE) $(@D)/
endef

define RPI_WIFI_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/$(RPI_WIFI_FIRMWARE_SOURCE) \
		$(TARGET_DIR)/lib/firmware/brcm/$(RPI_WIFI_FIRMWARE_SOURCE)
endef

$(eval $(generic-package))
