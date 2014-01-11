################################################################################
#
# luacjson
#
################################################################################

LUACJSON_VERSION       = 2.1.0
LUACJSON_SOURCE        = lua-cjson-$(LUACJSON_VERSION).tar.gz
LUACJSON_SITE          = http://www.kyne.com.au/~mark/software/download
LUACJSON_DEPENDENCIES  = luainterpreter
LUACJSON_LICENSE       = MIT
LUACJSON_LICENSE_FILES = LICENSE

define LUACJSON_BUILD_CMDS
	$(MAKE) -C $(@D) \
		CFLAGS="$(TARGET_CFLAGS)"   \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		CC="$(TARGET_CC)"           \
		LD="$(TARGET_LD)"           \
		PREFIX=$(STAGING_DIR)/usr
endef

define LUACJSON_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR="$(TARGET_DIR)" PREFIX="/usr" -C $(@D) install
endef

$(eval $(generic-package))
