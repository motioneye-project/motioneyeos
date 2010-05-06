#############################################################
#
# usbutils
#
#############################################################

USBUTILS_VERSION = 0.87
USBUTILS_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/usb/usbutils
USBUTILS_DEPENDENCIES = host-pkg-config libusb-compat

ifeq ($(BR2_PACKAGE_USBUTILS_ZLIB),y)
	USBUTILS_DEPENDENCIES += zlib
else
	USBUTILS_CONF_OPT = --disable-zlib
endif

$(eval $(call AUTOTARGETS,package,usbutils))

$(USBUTILS_HOOK_POST_INSTALL):
	rm -f $(TARGET_DIR)/usr/bin/usb-devices
	rm -f $(TARGET_DIR)/usr/sbin/update-usbids.sh
	rm -f $(TARGET_DIR)/usr/share/pkgconfig/usbutils.pc
ifeq ($(BR2_PACKAGE_USBUTILS_ZLIB),y)
	rm -f $(TARGET_DIR)/usr/share/usb.ids
else
	rm -f $(TARGET_DIR)/usr/share/usb.ids.gz
endif
ifneq ($(BR2_HAVE_DEVFILES),y)
	rm -f $(TARGET_DIR)/usr/bin/libusb-config
endif
	touch $@
