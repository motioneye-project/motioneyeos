################################################################################
#
# zd1211-firmware
#
################################################################################

ZD1211_FIRMWARE_VERSION = 1.4
ZD1211_FIRMWARE_SITE = http://downloads.sourceforge.net/project/zd1211/zd1211-firmware/$(ZD1211_FIRMWARE_VERSION)
ZD1211_FIRMWARE_SOURCE = zd1211-firmware-$(ZD1211_FIRMWARE_VERSION).tar.bz2
ZD1211_FIRMWARE_LICENSE = GPLv2
ZD1211_FIRMWARE_LICENSE_FILES = COPYING

# Not all of the firmware files are used
define ZD1211_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/lib/firmware/zd1211/
	cp -dpf $(@D)/zd1211*{ub,uphr,ur} $(TARGET_DIR)/lib/firmware/zd1211
endef

$(eval $(generic-package))
