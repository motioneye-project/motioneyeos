################################################################################
#
# orbit
#
################################################################################

ORBIT_VERSION = 2.2.0
ORBIT_SITE = http://github.com/downloads/keplerproject/orbit
ORBIT_LICENSE = MIT
ORBIT_LICENSE_FILES = doc/us/license.md

define ORBIT_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) \
		LUA_DIR=$(TARGET_DIR)/usr/share/lua/ \
		BIN_DIR=$(TARGET_DIR)/usr/bin \
		install
endef

$(eval $(generic-package))
