################################################################################
#
# bats-core
#
################################################################################

BATS_CORE_VERSION = 1.1.0
BATS_CORE_SITE = $(call github,bats-core,bats-core,v$(BATS_CORE_VERSION))
BATS_CORE_LICENSE = MIT
BATS_CORE_LICENSE_FILES = LICENSE.md

define BATS_CORE_INSTALL_TARGET_CMDS
	$(@D)/install.sh $(TARGET_DIR)/usr
endef

$(eval $(generic-package))
