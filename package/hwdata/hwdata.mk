################################################################################
#
# hwdata
#
################################################################################

HWDATA_VERSION = 0.230
HWDATA_SOURCE = hwdata_$(HWDATA_VERSION).orig.tar.gz
HWDATA_PATCH = hwdata_$(HWDATA_VERSION)-1.diff.gz
HWDATA_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/h/hwdata
HWDATA_LICENSE = GPLv2+ or XFree86 1.0 license
HWDATA_LICENSE_FILES = COPYING LICENSE

define HWDATA_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 644 $(@D)/pci.ids $(TARGET_DIR)/usr/share/hwdata/pci.ids
	$(INSTALL) -D -m 644 $(@D)/usb.ids $(TARGET_DIR)/usr/share/hwdata/usb.ids
endef

$(eval $(generic-package))
