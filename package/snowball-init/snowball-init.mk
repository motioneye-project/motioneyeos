################################################################################
#
# snowball-init
#
################################################################################

SNOWBALL_INIT_VERSION = b064be21de25729039e5e54037bbdd2e25cfd5b7
SNOWBALL_INIT_SITE = https://github.com/igloocommunity/snowball-init
SNOWBALL_INIT_LICENSE = BSD-4c
SNOWBALL_INIT_LICENSE_FILES = debian/copyright

define SNOWBALL_INIT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/snowball $(TARGET_DIR)/etc/init.d/S50snowball
endef

$(eval $(generic-package))
