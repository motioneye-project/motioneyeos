################################################################################
#
# luasec
#
################################################################################

LUASEC_VERSION = 0.4.1
LUASEC_SITE = http://www.inf.puc-rio.br/~brunoos/luasec/download/
LUASEC_LICENSE = MIT
LUASEC_LICENSE_FILES = LICENSE
LUASEC_DEPENDENCIES = luainterpreter openssl

define LUASEC_BUILD_CMDS
	$(MAKE) -C $(@D) CC="$(TARGET_CC)" LD="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -fPIC" \
		LDFLAGS="$(TARGET_LDFLAGS) -shared" linux
endef

define LUASEC_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) \
		LUAPATH="$(TARGET_DIR)/usr/share/lua/5.1" \
		LUACPATH="$(TARGET_DIR)/usr/lib/lua/5.1" install
endef

$(eval $(generic-package))
