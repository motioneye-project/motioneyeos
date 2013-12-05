################################################################################
#
# eeprog
#
################################################################################

EEPROG_VERSION = 0.7.6
EEPROG_SITE = http://www.codesink.org/download

define EEPROG_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define EEPROG_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/eeprog $(TARGET_DIR)/usr/bin/eeprog
endef

$(eval $(generic-package))
