################################################################################
#
# flashrom
#
################################################################################

FLASHROM_VERSION = 1.0
FLASHROM_SOURCE = flashrom-$(FLASHROM_VERSION).tar.bz2
FLASHROM_SITE = https://download.flashrom.org/releases
FLASHROM_DEPENDENCIES = pciutils libusb libusb-compat libftdi host-pkgconf
FLASHROM_LICENSE = GPL-2.0+
FLASHROM_LICENSE_FILES = COPYING

define FLASHROM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -DHAVE_STRNLEN" -C $(@D)
endef

define FLASHROM_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/flashrom $(TARGET_DIR)/usr/sbin/flashrom
endef

$(eval $(generic-package))
