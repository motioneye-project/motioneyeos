#############################################################
#
# wsapi
#
#############################################################

WSAPI_VERSION = 1.3.4
WSAPI_SITE = http://github.com/downloads/keplerproject/wsapi
WSAPI_DEPENDENCIES = coxpcall luafilesystem rings

define WSAPI_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/lua/wsapi
	$(INSTALL) -m 0644 -D $(@D)/src/wsapi/*.lua \
		$(TARGET_DIR)/usr/share/lua/wsapi
endef

define WSAPI_UNINSTALL_TARGET_CMDS
	rm -rf "$(TARGET_DIR)/usr/share/lua/wsapi"
endef

$(eval $(call GENTARGETS,package,wsapi))
