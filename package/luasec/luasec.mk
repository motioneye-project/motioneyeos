################################################################################
#
# luasec
#
################################################################################

LUASEC_VERSION = 0.4.1
LUASEC_SITE = http://www.inf.puc-rio.br/~brunoos/luasec/download/
LUASEC_LICENSE = MIT
LUASEC_LICENSE_FILES = LICENSE
LUASEC_DEPENDENCIES = lua openssl

define LUASEC_BUILD_CMDS
	$(MAKE) -C $(@D) CC="$(TARGET_CC)" LD="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -fPIC" \
		LDFLAGS="$(TARGET_LDFLAGS) -shared" linux
endef

define LUASEC_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/lua
	mkdir -p $(TARGET_DIR)/usr/lib/lua
	$(MAKE) -C $(@D) \
		LUAPATH="$(TARGET_DIR)/usr/share/lua" \
		LUACPATH="$(TARGET_DIR)/usr/lib/lua" install
endef

define LUASEC_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/lib/lua/ssl.so
	rm -rf $(TARGET_DIR)/usr/share/lua/ssl
	rm -f $(TARGET_DIR)/usr/share/lua/ssl.lua
endef

$(eval $(generic-package))
