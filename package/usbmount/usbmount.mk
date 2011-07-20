#############################################################
#
# usbmount
#
#############################################################
USBMOUNT_VERSION = 0.0.21
USBMOUNT_SOURCE = usbmount_$(USBMOUNT_VERSION).tar.gz
USBMOUNT_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/u/usbmount
USBMOUNT_DEPENDENCIES = udev lockfile-progs

define USBMOUNT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/usbmount $(TARGET_DIR)/usr/share/usbmount/usbmount
	$(INSTALL) -m 0644 -D $(@D)/usbmount.rules $(TARGET_DIR)/lib/udev/rules.d/usbmount.rules
	@if [ ! -f $(TARGET_DIR)/etc/usbmount/usbmount.conf ]; then \
	        $(INSTALL) -m 0644 -D $(@D)/usbmount.conf $(TARGET_DIR)/etc/usbmount/usbmount.conf; \
	fi
endef

define USBMOUNT_UNINSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/etc/usbmount \
	       $(TARGET_DIR)/usr/share/usbmount/usbmount \
	       $(TARGET_DIR)/lib/udev/rules.d/usbmount.rules
endef

$(eval $(call GENTARGETS,package,usbmount))
