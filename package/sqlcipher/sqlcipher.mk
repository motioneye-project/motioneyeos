################################################################################
#
# sqlcipher
#
################################################################################

SQLCIPHER_VERSION = v3.2.0
SQLCIPHER_SITE = $(call github,sqlcipher,sqlcipher,$(SQLCIPHER_VERSION))
SQLCIPHER_DEPENDENCIES = openssl host-tcl
SQLCIPHER_INSTALL_STAGING = YES

SQLCIPHER_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) $(SQLCIPHER_CFLAGS)" \
	TCLSH_CMD=$(HOST_DIR)/usr/bin/tclsh$(TCL_VERSION_MAJOR)

SQLCIPHER_CONF_OPTS = \
	--enable-threadsafe

SQLCIPHER_CFLAGS += -DSQLITE_HAS_CODEC # Required according to the README
SQLCIPHER_CONF_ENV += LIBS="-lcrypto -lz"

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
SQLCIPHER_CONF_OPTS += --with-readline-inc="-I$(STAGING_DIR)/usr/include"
else
SQLCIPHER_CONF_OPTS += --disable-readline
endif

$(eval $(autotools-package))
