################################################################################
#
# bluez5_utils-headers
#
################################################################################

# Keep the version and patches in sync with bluez5_utils
BLUEZ5_UTILS_HEADERS_VERSION = 5.50
BLUEZ5_UTILS_HEADERS_SOURCE = bluez-$(BLUEZ5_UTILS_VERSION).tar.xz
BLUEZ5_UTILS_HEADERS_SITE = $(BR2_KERNEL_MIRROR)/linux/bluetooth
BLUEZ5_UTILS_HEADERS_DL_SUBDIR = bluez5_utils
BLUEZ5_UTILS_HEADERS_LICENSE = GPL-2.0+, LGPL-2.1+
BLUEZ5_UTILS_HEADERS_LICENSE_FILES = COPYING COPYING.LIB

BLUEZ5_UTILS_HEADERS_INSTALL_STAGING = YES
BLUEZ5_UTILS_HEADERS_INSTALL_TARGET = NO

define BLUEZ5_UTILS_HEADERS_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/usr/include/bluetooth/
	$(INSTALL) -m 644 $(@D)/lib/*.h $(STAGING_DIR)/usr/include/bluetooth/
endef

$(eval $(generic-package))
