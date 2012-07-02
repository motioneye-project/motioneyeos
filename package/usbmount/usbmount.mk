#############################################################
#
# usbmount
#
#############################################################
USBMOUNT_VERSION = 0.0.22
USBMOUNT_SOURCE = usbmount_$(USBMOUNT_VERSION).tar.gz
USBMOUNT_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/u/usbmount
USBMOUNT_DEPENDENCIES = udev lockfile-progs util-linux

define USBMOUNT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/usbmount $(TARGET_DIR)/usr/share/usbmount/usbmount

	$(INSTALL) -m 0755 -D $(@D)/00_create_model_symlink 	\
		$(TARGET_DIR)/etc/usbmount/usbmount.d/00_create_model_symlink
	$(INSTALL) -m 0755 -D $(@D)/00_remove_model_symlink 	\
		$(TARGET_DIR)/etc/usbmount/usbmount.d/00_remove_model_symlink

	$(INSTALL) -m 0644 -D $(@D)/usbmount.rules $(TARGET_DIR)/lib/udev/rules.d/usbmount.rules
	@if [ ! -f $(TARGET_DIR)/etc/usbmount/usbmount.conf ]; then \
	        $(INSTALL) -m 0644 -D $(@D)/usbmount.conf $(TARGET_DIR)/etc/usbmount/usbmount.conf; \
	fi

	mkdir -p $(addprefix $(TARGET_DIR)/media/usb,0 1 2 3 4 5 6 7)
endef

define USBMOUNT_UNINSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/etc/usbmount			\
		$(TARGET_DIR)/usr/share/usbmount/usbmount	\
		$(TARGET_DIR)/lib/udev/rules.d/usbmount.rules	\
		$(TARGET_DIR)/media/usb?
endef

$(eval $(generic-package))
