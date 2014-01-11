################################################################################
#
# copas
#
################################################################################

COPAS_VERSION = 1.1.6
COPAS_SITE = http://github.com/downloads/keplerproject/copas
COPAS_LICENSE = MIT

define COPAS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/src/copas/copas.lua \
		$(TARGET_DIR)/usr/share/lua/5.1/copas.lua
endef

$(eval $(generic-package))
