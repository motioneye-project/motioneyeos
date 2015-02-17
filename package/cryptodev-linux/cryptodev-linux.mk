################################################################################
#
# cryptodev-linux
#
################################################################################

CRYPTODEV_LINUX_VERSION = 1.7
CRYPTODEV_LINUX_SITE = http://download.gna.org/cryptodev-linux
CRYPTODEV_LINUX_DEPENDENCIES = linux
CRYPTODEV_LINUX_INSTALL_STAGING = YES
CRYPTODEV_LINUX_LICENSE = GPLv2+
CRYPTODEV_LINUX_LICENSE_FILES = COPYING

define CRYPTODEV_LINUX_BUILD_CMDS
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) KERNEL_DIR=$(LINUX_DIR)
endef

define CRYPTODEV_LINUX_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) KERNEL_DIR=$(LINUX_DIR) \
		PREFIX=$(TARGET_DIR) modules_install
endef

define CRYPTODEV_LINUX_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/crypto/cryptodev.h \
		$(STAGING_DIR)/usr/include/crypto/cryptodev.h
endef

$(eval $(generic-package))
