#############################################################
#
# usb_modeswitch
#
#############################################################

USB_MODESWITCH_VERSION = 1.0.7
USB_MODESWITCH_SOURCE = usb_modeswitch-$(USB_MODESWITCH_VERSION).tar.bz2
USB_MODESWITCH_SITE = http://www.draisberghof.de/usb_modeswitch
USB_MODESWITCH_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
USB_MODESWITCH_DEPENDENCIES = libusb
USB_MODESWITCH_MAKE_OPT = CC="$(TARGET_CC)" OPTS="$(TARGET_CFLAGS)"

$(eval $(call AUTOTARGETS,package,usb_modeswitch))

$(USB_MODESWITCH_TARGET_CONFIGURE):
	rm -f $(USB_MODESWITCH_DIR)/usb_modeswitch
	touch $@

$(USB_MODESWITCH_HOOK_POST_INSTALL):
	chmod a-x $(TARGET_DIR)/etc/usb_modeswitch.conf
	touch $@

$(USB_MODESWITCH_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/sbin/usb_modeswitch
	rm -f $(TARGET_DIR)/etc/usb_modeswitch.conf
	rm -f $(USB_MODESWITCH_TARGET_INSTALL_TARGET) $(USB_MODESWITCH_HOOK_POST_INSTALL)
