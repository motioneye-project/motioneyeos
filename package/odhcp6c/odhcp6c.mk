################################################################################
#
# odhcp6c
#
################################################################################

ODHCP6C_VERSION = 7533a6243dc3ac5a747cf6ccbc4d0539dafd3e07
ODHCP6C_SITE = $(call github,sbyx,odhcp6c,$(ODHCP6C_VERSION))
ODHCP6C_LICENSE = GPL-2.0
ODHCP6C_LICENSE_FILES = COPYING

define ODHCP6C_INSTALL_SCRIPT
	$(INSTALL) -m 0755 -D $(@D)/odhcp6c-example-script.sh \
		$(TARGET_DIR)/usr/sbin/odhcp6c-update
endef

ODHCP6C_POST_INSTALL_TARGET_HOOKS += ODHCP6C_INSTALL_SCRIPT

$(eval $(cmake-package))
