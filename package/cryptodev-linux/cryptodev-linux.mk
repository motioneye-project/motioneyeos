################################################################################
#
# cryptodev-linux
#
################################################################################

CRYPTODEV_LINUX_VERSION = 1.7
CRYPTODEV_LINUX_SITE = http://download.gna.org/cryptodev-linux
CRYPTODEV_LINUX_INSTALL_STAGING = YES
CRYPTODEV_LINUX_LICENSE = GPLv2+
CRYPTODEV_LINUX_LICENSE_FILES = COPYING

define CRYPTODEV_LINUX_MODULE_GEN_VERSION_H
	$(MAKE) -C $(@D) version.h
endef
CRYPTODEV_LINUX_PRE_BUILD_HOOKS += CRYPTODEV_LINUX_MODULE_GEN_VERSION_H

define CRYPTODEV_LINUX_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/crypto/cryptodev.h \
		$(STAGING_DIR)/usr/include/crypto/cryptodev.h
endef

$(eval $(kernel-module))
$(eval $(generic-package))
