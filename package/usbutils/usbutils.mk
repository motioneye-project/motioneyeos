#############################################################
#
# usbutils
#
#############################################################

USBUTILS_VERSION = 0.86
USBUTILS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/linux-usb/
USBUTILS_DEPENDENCIES = host-pkg-config

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
	touch $@
