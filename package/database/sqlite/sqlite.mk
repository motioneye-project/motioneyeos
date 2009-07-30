#############################################################
#
# sqlite
#
#############################################################

SQLITE_VERSION = 3.6.16
SQLITE_SOURCE = sqlite-amalgamation-$(SQLITE_VERSION).tar.gz
SQLITE_SITE = http://www.sqlite.org
SQLITE_INSTALL_STAGING = YES
SQLITE_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
SQLITE_LIBTOOL_PATCH = NO
SQLITE_DEPENDENCIES = uclibc

SQLITE_CONF_OPT =	--enable-shared \
			--enable-static \
			--enable-tempstore=yes \
			--enable-threadsafe \
			--enable-releasemode \
			--disable-tcl \
			--localstatedir=/var

ifeq ($(BR2_PACKAGE_SQLITE_READLINE),y)
SQLITE_DEPENDENCIES += ncurses readline
SQLITE_CONF_OPT += --with-readline-inc="-I$(STAGING_DIR)/usr/include"
else
SQLITE_CONF_OPT += --disable-readline
endif

$(eval $(call AUTOTARGETS,package,sqlite))

$(SQLITE_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/bin/sqlite3
	rm -f $(TARGET_DIR)/usr/lib/libsqlite3*
	rm -f $(STAGING_DIR)/usr/bin/sqlite3
	rm -f $(STAGING_DIR)/usr/lib/libsqlite3*
	rm -f $(STAGING_DIR)/usr/lib/pkgconfig/sqlite3.pc
	rm -f $(STAGING_DIR)/usr/include/sqlite3*.h
	rm -f $(SQLITE_TARGET_INSTALL_TARGET) $(SQLITE_HOOK_POST_INSTALL)

