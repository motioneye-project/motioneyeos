#############################################################
#
# usb_modeswitch
#
#############################################################

USB_MODESWITCH_VERSION = 1.1.2
USB_MODESWITCH_SOURCE = usb-modeswitch-$(USB_MODESWITCH_VERSION).tar.bz2
USB_MODESWITCH_SITE = http://www.draisberghof.de/usb_modeswitch
USB_MODESWITCH_DEPENDENCIES = libusb-compat

define USB_MODESWITCH_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define USB_MODESWITCH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	$(INSTALL) -D $(@D)/usb_modeswitch.setup -m 0644 \
		$(TARGET_DIR)/etc/usb_modeswitch.setup
endef

define USB_MODESWITCH_CLEAN_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/usb_modeswitch
	rm -f $(TARGET_DIR)/etc/usb_modeswitch.setup
	rm -f $(TARGET_DIR)/usr/share/man/man1/usb_modeswitch.1
endef

$(eval $(generic-package))

