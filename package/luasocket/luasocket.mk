################################################################################
#
# luasocket
#
################################################################################

LUASOCKET_VERSION = 2.0.2
LUASOCKET_SITE = http://luaforge.net/frs/download.php/2664
LUASOCKET_DEPENDENCIES = lua
LUASOCKET_LICENSE = MIT
LUASOCKET_LICENSE_FILES = LICENSE

define LUASOCKET_BUILD_CMDS
	$(MAKE) -C $(@D) -f makefile \
		CC="$(TARGET_CC)" LD="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -fPIC"
endef

define LUASOCKET_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) -f makefile \
		INSTALL_TOP_SHARE="$(TARGET_DIR)/usr/share/lua" \
		INSTALL_TOP_LIB="$(TARGET_DIR)/usr/lib/lua" install
endef

$(eval $(generic-package))
