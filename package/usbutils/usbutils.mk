#############################################################
#
# usbutils
#
#############################################################

USBUTILS_VERSION = 006
USBUTILS_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/usb/usbutils/
USBUTILS_SOURCE = usbutils-$(USBUTILS_VERSION).tar.gz
USBUTILS_DEPENDENCIES = host-pkg-config libusb
USBUTILS_INSTALL_STAGING = YES
# no configure in tarball
USBUTILS_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_USBUTILS_ZLIB),y)
	USBUTILS_DEPENDENCIES += zlib
else
	USBUTILS_CONF_OPT = --disable-zlib
endif

# Build after busybox since it's got a lightweight lsusb
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
	USBUTILS_DEPENDENCIES += busybox
endif

define USBUTILS_TARGET_CLEANUP
	rm -f $(TARGET_DIR)/usr/bin/usb-devices
	rm -f $(TARGET_DIR)/usr/sbin/update-usbids.sh
	rm -f $(TARGET_DIR)/usr/share/pkgconfig/usbutils.pc
endef

USBUTILS_POST_INSTALL_TARGET_HOOKS += USBUTILS_TARGET_CLEANUP

define USBUTILS_REMOVE_UNCOMPRESSED_IDS
	rm -f $(TARGET_DIR)/usr/share/usb.ids
endef

define USBUTILS_REMOVE_COMPRESSED_IDS
	rm -f $(TARGET_DIR)/usr/share/usb.ids.gz
endef

ifeq ($(BR2_PACKAGE_USBUTILS_ZLIB),y)
USBUTILS_POST_INSTALL_TARGET_HOOKS += USBUTILS_REMOVE_UNCOMPRESSED_IDS
else
USBUTILS_POST_INSTALL_TARGET_HOOKS += USBUTILS_REMOVE_COMPRESSED_IDS
endif

define USBUTILS_REMOVE_DEVFILES
	rm -f $(TARGET_DIR)/usr/bin/libusb-config
endef

ifneq ($(BR2_HAVE_DEVFILES),y)
USBUTILS_POST_INSTALL_TARGET_HOOKS += USBUTILS_REMOVE_DEVFILES
endif

$(eval $(autotools-package))
