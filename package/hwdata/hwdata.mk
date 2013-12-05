################################################################################
#
# hwdata
#
################################################################################

HWDATA_VERSION = 0.230
HWDATA_SOURCE = hwdata_$(HWDATA_VERSION).orig.tar.gz
HWDATA_PATCH = hwdata_$(HWDATA_VERSION)-1.diff.gz
HWDATA_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/h/hwdata/

define HWDATA_INSTALL_TARGET_CMDS
	install -D -m 644 $(@D)/pci.ids $(TARGET_DIR)/usr/share/hwdata/pci.ids
	install -D -m 644 $(@D)/usb.ids $(TARGET_DIR)/usr/share/hwdata/usb.ids
endef

$(eval $(generic-package))
