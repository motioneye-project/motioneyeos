################################################################################
#
# odhcp6c
#
################################################################################

ODHCP6C_VERSION = 8d9b60fb496000988f3633951f2e30380fc2de50
ODHCP6C_SITE = $(call github,sbyx,odhcp6c,$(ODHCP6C_VERSION))
ODHCP6C_LICENSE = GPLv2
ODHCP6C_LICENSE_FILES = COPYING

define ODHCP6C_INSTALL_SCRIPT
	$(INSTALL) -m 0755 -D $(@D)/odhcp6c-example-script.sh \
		$(TARGET_DIR)/usr/sbin/odhcp6c-update
endef

ODHCP6C_POST_INSTALL_TARGET_HOOKS += ODHCP6C_INSTALL_SCRIPT

$(eval $(cmake-package))
