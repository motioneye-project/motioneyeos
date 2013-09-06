################################################################################
#
# usbutils
#
################################################################################

USBUTILS_VERSION = 007
USBUTILS_SOURCE = usbutils-$(USBUTILS_VERSION).tar.xz
USBUTILS_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/usb/usbutils
USBUTILS_DEPENDENCIES = host-pkgconf libusb
USBUTILS_INSTALL_STAGING = YES
USBUTILS_LICENSE = GPLv2+
USBUTILS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_USBUTILS_ZLIB),y)
	USBUTILS_DEPENDENCIES += zlib
else
	USBUTILS_CONF_OPT = --disable-zlib
endif

# Build after busybox since it's got a lightweight lsusb
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
	USBUTILS_DEPENDENCIES += busybox
endif

# Nice lsusb.py script only if there's python
ifeq ($(BR2_PACKAGE_PYTHON),)
define USBUTILS_REMOVE_PYTHON
	rm -f $(TARGET_DIR)/usr/bin/lsusb.py
endef

USBUTILS_POST_INSTALL_TARGET_HOOKS += USBUTILS_REMOVE_PYTHON
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

USBUTILS_POST_INSTALL_TARGET_HOOKS += USBUTILS_REMOVE_DEVFILES

$(eval $(autotools-package))
