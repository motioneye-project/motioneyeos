################################################################################
#
# usbredir
#
################################################################################

USBREDIR_VERSION = 0.6
USBREDIR_SOURCE = usbredir-$(USBREDIR_VERSION).tar.bz2
USBREDIR_SITE = http://spice-space.org/download/usbredir
USBREDIR_LICENSE = LGPLv2.1+
USBREDIR_LICENSE_FILES = COPYING.LIB
USBREDIR_INSTALL_STAGING = YES
USBREDIR_DEPENDENCIES = host-pkgconf libusb

ifeq ($(BR2_PACKAGE_USBREDIR_SERVER),y)

USBREDIR_LICENSE += (for the library), GPLv2+ (for the server)
USBREDIR_LICENSE_FILES += COPYING

else # BR2_PACKAGE_USBREDIR_SERVER != y

define USBREDIR_POST_INSTALL_TARGET_RM_SERVER
	rm -f $(TARGET_DIR)/usr/sbin/usbredirserver
endef
USBREDIR_POST_INSTALL_TARGET_HOOKS += USBREDIR_POST_INSTALL_TARGET_RM_SERVER

endif # BR2_PACKAGE_USBREDIR_SERVER

$(eval $(autotools-package))
