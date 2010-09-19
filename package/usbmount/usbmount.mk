#############################################################
#
# usbmount
#
#############################################################
USBMOUNT_VERSION=0.0.14.1
USBMOUNT_SOURCE:=usbmount_$(USBMOUNT_VERSION).tar.gz
USBMOUNT_SITE:=http://usbmount.alioth.debian.org/package/
USBMOUNT_DEPENDENCIES = udev lockfile-progs

define USBMOUNT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/usbmount $(TARGET_DIR)/sbin/usbmount
	@if [ ! -f $(TARGET_DIR)/etc/usbmount/usbmount.conf ]; then \
	        $(INSTALL) -m 0644 -D $(@D)/usbmount.conf $(TARGET_DIR)/etc/usbmount/usbmount.conf; \
	fi
endef

define USBMOUNT_UNINSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/etc/usbmount $(TARGET_DIR)/sbin/usbmount
endef

$(eval $(call GENTARGETS,package,usbmount))
