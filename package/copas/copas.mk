#############################################################
#
# copas
#
#############################################################

COPAS_VERSION = 1.1.6
COPAS_SITE = http://github.com/downloads/keplerproject/copas
COPAS_DEPENDENCIES = lua coxpcall luasocket
COPAS_LICENSE = MIT

define COPAS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/src/copas/copas.lua \
		$(TARGET_DIR)/usr/share/lua/copas.lua
endef

define COPAS_UNINSTALL_TARGET_CMDS
	rm -f "$(TARGET_DIR)/usr/share/lua/copas.lua"
endef

$(eval $(generic-package))
