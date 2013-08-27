################################################################################
#
# orc
#
################################################################################

ORC_VERSION = 0.4.18
ORC_SITE = http://code.entropywave.com/download/orc/
ORC_LICENSE = BSD-2c, BSD-3c
ORC_LICENSE_FILES = COPYING
ORC_INSTALL_STAGING = YES
ORC_DEPENDENCIES = host-orc

define ORC_REMOVE_BUGREPORT
	rm -f $(TARGET_DIR)/usr/bin/orc-bugreport
endef

define ORC_REMOVE_DEVFILES
	rm -f $(TARGET_DIR)/usr/bin/orcc
endef

ORC_POST_INSTALL_TARGET_HOOKS += ORC_REMOVE_BUGREPORT
ORC_POST_INSTALL_TARGET_HOOKS += ORC_REMOVE_DEVFILES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
