################################################################################
#
# hwdata
#
################################################################################

HWDATA_VERSION = 0.326
HWDATA_SITE = $(call github,vcrhonek,hwdata,v$(HWDATA_VERSION))
HWDATA_LICENSE = GPL-2.0+, BSD-3-Clause, XFree86 1.0
HWDATA_LICENSE_FILES = COPYING LICENSE

HWDATA_FILES = \
	$(if $(BR2_PACKAGE_HWDATA_IAB_OUI_TXT),iab.txt oui.txt) \
	$(if $(BR2_PACKAGE_HWDATA_PCI_IDS),pci.ids) \
	$(if $(BR2_PACKAGE_HWDATA_PNP_IDS),pnp.ids) \
	$(if $(BR2_PACKAGE_HWDATA_USB_IDS),usb.ids)

ifneq ($(strip $(HWDATA_FILES)),)
define HWDATA_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/share/hwdata
	$(INSTALL) -m 644 -t $(TARGET_DIR)/usr/share/hwdata \
		$(addprefix $(@D)/,$(HWDATA_FILES))
endef
endif

$(eval $(generic-package))
