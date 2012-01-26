#############################################################
#
# linux-firmware
#
#############################################################
LINUX_FIRMWARE_VERSION = a2995d38c234e3d767df7223d84a0f33a1a24997
LINUX_FIRMWARE_SITE = git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
LINUX_FIRMWARE_SITE_METHOD = git

# rt2501/rt61
LINUX_FIRMWARE_FILES_$(BR2_PACKAGE_LINUX_FIRMWARE_RALINK_RT61) += \
	rt2561.bin rt2561s.bin rt2661.bin LICENCE.ralink-firmware.txt


# rt73
LINUX_FIRMWARE_FILES_$(BR2_PACKAGE_LINUX_FIRMWARE_RALINK_RT73) += \
	rt73.bin LICENCE.ralink-firmware.txt

# rt2xx
LINUX_FIRMWARE_FILES_$(BR2_PACKAGE_LINUX_FIRMWARE_RALINK_RT2XX) += \
	rt2860.bin rt2870.bin rt3070.bin rt3071.bin rt3090.bin 	\
	LICENCE.ralink-firmware.txt

# wl127x
LINUX_FIRMWARE_FILES_$(BR2_PACKAGE_LINUX_FIRMWARE_TI_WL127X) += \
	ti-connectivity/wl1271-fw-2.bin				\
	ti-connectivity/wl1271-fw-ap.bin			\
	ti-connectivity/wl1271-fw.bin				\
	ti-connectivity/wl1271-nvs.bin				\
	ti-connectivity/wl127x-fw-3.bin				\
	ti-connectivity/wl127x-fw-plt-3.bin			\
	ti-connectivity/wl127x-nvs.bin				\
	ti-connectivity/TIInit_7.2.31.bts 			\
	LICENCE.ti-connectivity

# wl128x
LINUX_FIRMWARE_FILES_$(BR2_PACKAGE_LINUX_FIRMWARE_TI_WL128X) += \
	ti-connectivity/wl128x-fw-3.bin				\
	ti-connectivity/wl128x-fw-ap.bin			\
	ti-connectivity/wl128x-fw-plt-3.bin			\
	ti-connectivity/wl128x-fw.bin				\
	ti-connectivity/wl1271-nvs.bin				\
	ti-connectivity/wl128x-nvs.bin				\
	ti-connectivity/wl12xx-nvs.bin				\
	ti-connectivity/TIInit_7.2.31.bts 			\
	LICENCE.ti-connectivity


ifneq ($(LINUX_FIRMWARE_FILES_y),)

define LINUX_FIRMWARE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware
	$(TAR) c -C $(@D) $(LINUX_FIRMWARE_FILES_y) | \
		$(TAR) x -C $(TARGET_DIR)/lib/firmware
endef

endif

$(eval $(call GENTARGETS))
