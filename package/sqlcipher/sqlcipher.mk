################################################################################
#
# sqlcipher
#
################################################################################

SQLCIPHER_VERSION = 4.3.0
SQLCIPHER_SITE = $(call github,sqlcipher,sqlcipher,v$(SQLCIPHER_VERSION))
SQLCIPHER_LICENSE = BSD-3-Clause
SQLCIPHER_LICENSE_FILES = LICENSE
SQLCIPHER_DEPENDENCIES = host-pkgconf openssl host-tcl
SQLCIPHER_INSTALL_STAGING = YES

SQLCIPHER_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) $(SQLCIPHER_CFLAGS)" \
	TCLSH_CMD=$(HOST_DIR)/bin/tclsh$(TCL_VERSION_MAJOR)

SQLCIPHER_CONF_OPTS = \
	--enable-threadsafe \
	--disable-tcl

SQLCIPHER_CFLAGS += -DSQLITE_HAS_CODEC # Required according to the README
SQLCIPHER_CONF_ENV += LIBS=`$(PKG_CONFIG_HOST_BINARY) --libs openssl`

ifeq ($(BR2_PACKAGE_SQLCIPHER_STAT3),y)
SQLCIPHER_CFLAGS += -DSQLITE_ENABLE_STAT3
endif

ifeq ($(BR2_PACKAGE_SQLCIPHER_READLINE),y)
SQLCIPHER_DEPENDENCIES += ncurses readline
SQLCIPHER_CONF_OPTS += --with-readline-inc="-I$(STAGING_DIR)/usr/include"
else
SQLCIPHER_CONF_OPTS += --disable-readline
endif

ifeq ($(BR2_STATIC_LIBS),y)
SQLCIPHER_CONF_OPTS += --disable-load-extension
else
SQLCIPHER_CONF_OPTS += --enable-load-extension
endif

$(eval $(autotools-package))
