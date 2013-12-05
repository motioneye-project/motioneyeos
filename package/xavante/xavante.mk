################################################################################
#
# xavante
#
################################################################################

XAVANTE_VERSION = 2.2.1
XAVANTE_SITE = http://github.com/downloads/keplerproject/xavante
XAVANTE_LICENSE = MIT

define XAVANTE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) PREFIX=/usr \
		LUA_DIR="$(TARGET_DIR)/usr/share/lua" \
		LUA_LIBDIR="$(TARGET_DIR)/usr/lib/lua" install
endef

$(eval $(generic-package))
