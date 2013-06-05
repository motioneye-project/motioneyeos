################################################################################
#
# luacjson
#
################################################################################

LUACJSON_VERSION       = 2.1.0
LUACJSON_SOURCE        = lua-cjson-$(LUACJSON_VERSION).tar.gz
LUACJSON_SITE          = http://www.kyne.com.au/~mark/software/download
LUACJSON_DEPENDENCIES  = lua
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
	install -D -m 0644 $(@D)/cjson.so $(TARGET_DIR)/usr/lib/lua/cjson.so
endef

define LUACJSON_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

define LUACJSON_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/lib/lua/cjson.so
endef

$(eval $(generic-package))
