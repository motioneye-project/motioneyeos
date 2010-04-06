#############################################################
#
# usb_modeswitch
#
#############################################################

USB_MODESWITCH_VERSION = 1.0.7
USB_MODESWITCH_SOURCE = usb_modeswitch-$(USB_MODESWITCH_VERSION).tar.bz2
USB_MODESWITCH_SITE = http://www.draisberghof.de/usb_modeswitch
USB_MODESWITCH_DEPENDENCIES = libusb-compat

define USB_MODESWITCH_BUILD_CMDS
 rm $(@D)/usb_modeswitch
 $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define USB_MODESWITCH_INSTALL_TARGET_CMDS
 $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define USB_MODESWITCH_CLEAN_CMDS
 rm -f $(TARGET_DIR)/usr/sbin/usb_modeswitch
 rm -f $(TARGET_DIR)/etc/usb_modeswitch.conf
endef

$(eval $(call GENTARGETS,package,usb_modeswitch))
