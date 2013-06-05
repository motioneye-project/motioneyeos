################################################################################
#
# sqlcipher
#
################################################################################

SQLCIPHER_VERSION = 1.1.9
SQLCIPHER_SITE = http://github.com/sjlombardo/sqlcipher/tarball/v$(SQLCIPHER_VERSION)
SQLCIPHER_DEPENDENCIES = openssl host-tcl
SQLCIPHER_INSTALL_STAGING = YES

SQLCIPHER_CONF_ENV = \
	CFLAGS+=" $(SQLCIPHER_CFLAGS)" \
	LDFLAGS+=" $(SQLCIPHER_LDFLAGS)" \
	TCLSH_CMD=$(HOST_DIR)/usr/bin/tclsh$(TCL_VERSION_MAJOR)

SQLCIPHER_CONF_OPT = \
	--enable-threadsafe \
	--localstatedir=/var

SQLCIPHER_CFLAGS += -DSQLITE_HAS_CODEC # Required according to the README
SQLCIPHER_LDFLAGS += -lcrypto

ifneq ($(BR2_LARGEFILE),y)
# the sqlite configure script fails to define SQLITE_DISABLE_LFS when
# --disable-largefile is passed, breaking the build. Work around it by
# simply adding it to CFLAGS for configure instead
SQLCIPHER_CFLAGS += -DSQLITE_DISABLE_LFS
endif

ifeq ($(BR2_PACKAGE_SQLCIPHER_STAT3),y)
SQLCIPHER_CFLAGS += -DSQLITE_ENABLE_STAT3
endif

ifeq ($(BR2_PACKAGE_SQLCIPHER_READLINE),y)
SQLCIPHER_DEPENDENCIES += ncurses readline
SQLCIPHER_CONF_OPT += --with-readline-inc="-I$(STAGING_DIR)/usr/include"
else
SQLCIPHER_CONF_OPT += --disable-readline
endif

define SQLCIPHER_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/sqlite3
	rm -f $(TARGET_DIR)/usr/lib/libsqlite3*
	rm -f $(TARGET_DIR)/usr/lib/pkgconfig/sqlite3.pc
	rm -f $(TARGET_DIR)/usr/include/sqlite3*.h
endef

define SQLCIPHER_UNINSTALL_STAGING_CMDS
	rm -f $(STAGING_DIR)/usr/bin/sqlite3
	rm -f $(STAGING_DIR)/usr/lib/libsqlite3*
	rm -f $(STAGING_DIR)/usr/lib/pkgconfig/sqlite3.pc
	rm -f $(STAGING_DIR)/usr/include/sqlite3*.h
endef

$(eval $(autotools-package))
