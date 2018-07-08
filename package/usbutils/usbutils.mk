################################################################################
#
# usbutils
#
################################################################################

USBUTILS_VERSION = 010
USBUTILS_SOURCE = usbutils-$(USBUTILS_VERSION).tar.xz
USBUTILS_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/usb/usbutils
USBUTILS_DEPENDENCIES = host-pkgconf libusb udev
USBUTILS_LICENSE = GPL-2.0+ (utils) GPL-2.0 or GPL-3.0 (lsusb.py)
USBUTILS_LICENSE_FILES = LICENSES/GPL-2.0.txt LICENSES/GPL-3.0.txt

# Nice lsusb.py script only if there's python 3.x
ifeq ($(BR2_PACKAGE_PYTHON3),)
define USBUTILS_REMOVE_PYTHON
	rm -f $(TARGET_DIR)/usr/bin/lsusb.py
endef

USBUTILS_POST_INSTALL_TARGET_HOOKS += USBUTILS_REMOVE_PYTHON
endif

define USBUTILS_TARGET_CLEANUP
	rm -f $(TARGET_DIR)/usr/bin/usb-devices
endef

USBUTILS_POST_INSTALL_TARGET_HOOKS += USBUTILS_TARGET_CLEANUP

$(eval $(autotools-package))
