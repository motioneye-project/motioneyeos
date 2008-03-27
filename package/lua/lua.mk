#############################################################
#
# lua
#
#############################################################

LUA_VERSION=5.1.2

LUA_SOURCE=lua-$(LUA_VERSION).tar.gz
LUA_CAT:=$(ZCAT)
LUA_SITE=http://www.lua.org/ftp

LUA_DIR=$(BUILD_DIR)/lua-$(LUA_VERSION)

LUA_CFLAGS=-DLUA_USE_LINUX
LUA_MYLIBS="-Wl,-E -ldl -lreadline -lhistory -lncurses"

$(DL_DIR)/$(LUA_SOURCE):
	$(WGET) -P $(DL_DIR) $(LUA_SITE)/$(LUA_SOURCE)

$(LUA_DIR)/.unpacked: $(DL_DIR)/$(LUA_SOURCE)
	$(LUA_CAT) $(DL_DIR)/$(LUA_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(LUA_DIR)/.unpacked

$(LUA_DIR)/src/lua: $(LUA_DIR)/.unpacked
	rm -f $@
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		MYCFLAGS=$(LUA_CFLAGS) \
		MYLIBS=$(LUA_MYLIBS) \
		AR="$(TARGET_CROSS)ar rcu" \
		-C $(LUA_DIR)/src all

$(LUA_DIR)/src/luac: $(LUA_DIR)/src/lua

$(LUA_DIR)/src/liblua.a: $(LUA_DIR)/src/lua

$(STAGING_DIR)/usr/lib/liblua.a: $(LUA_DIR)/src/liblua.a
	cp -dpf $(LUA_DIR)/src/liblua.a $(STAGING_DIR)/usr/lib/liblua.a

$(STAGING_DIR)/usr/bin/lua: $(LUA_DIR)/src/lua
	cp -dpf $(LUA_DIR)/src/lua $(STAGING_DIR)/usr/bin/lua

$(STAGING_DIR)/usr/bin/luac: $(LUA_DIR)/src/luac
	cp -dpf $(LUA_DIR)/src/luac $(STAGING_DIR)/usr/bin/luac

$(TARGET_DIR)/usr/lib/liblua.a: $(STAGING_DIR)/usr/lib/liblua.a
	cp -dpf $(STAGING_DIR)/usr/lib/liblua.a $(TARGET_DIR)/usr/lib/liblua.a

$(TARGET_DIR)/usr/bin/lua: $(STAGING_DIR)/usr/bin/lua
	cp -dpf $(STAGING_DIR)/usr/bin/lua $(TARGET_DIR)/usr/bin/lua

$(TARGET_DIR)/usr/bin/luac: $(STAGING_DIR)/usr/bin/luac
	cp -dpf $(STAGING_DIR)/usr/bin/luac $(TARGET_DIR)/usr/bin/luac


lua-bins:	$(TARGET_DIR)/usr/bin/lua $(TARGET_DIR)/usr/bin/luac

lua-libs:	$(TARGET_DIR)/usr/lib/liblua.a

lua: uclibc readline ncurses lua-bins lua-libs

lua-source: $(DL_DIR)/$(LUA_SOURCE)

lua-clean:
	rm -f $(STAGING_DIR)/usr/bin/lua $(TARGET_DIR)/usr/bin/luac
	rm -f $(STAGING_DIR)/usr/lib/liblua.a
	rm -f $(TARGET_DIR)/usr/bin/lua $(TARGET_DIR)/usr/bin/luac
	rm -f $(TARGET_DIR)/usr/lib/liblua.a
	-$(MAKE) -C $(LUA_DIR) clean

lua-dirclean:
	rm -rf $(LUA_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LUA)),y)
TARGETS+=lua
endif
