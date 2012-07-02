#############################################################
#
# orc
#
#############################################################
ORC_VERSION = 0.4.14
ORC_SITE = http://code.entropywave.com/download/orc/
ORC_INSTALL_STAGING = YES
ORC_DEPENDENCIES = host-orc

define ORC_REMOVE_BUGREPORT
	rm -f $(TARGET_DIR)/usr/bin/orc-bugreport
endef

define ORC_REMOVE_DEVFILES
	rm -f $(TARGET_DIR)/usr/bin/orcc
endef

ORC_POST_INSTALL_TARGET_HOOKS += ORC_REMOVE_BUGREPORT

ifneq ($(BR2_HAVE_DEVFILES),y)
ORC_POST_INSTALL_TARGET_HOOKS += ORC_REMOVE_DEVFILES
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
