################################################################################
#
# sqlite
#
################################################################################

SQLITE_VERSION = 3080100
SQLITE_SOURCE = sqlite-autoconf-$(SQLITE_VERSION).tar.gz
SQLITE_SITE = http://www.sqlite.org/2013
SQLITE_LICENSE = Public domain
SQLITE_INSTALL_STAGING = YES

ifneq ($(BR2_LARGEFILE),y)
# the sqlite configure script fails to define SQLITE_DISABLE_LFS when
# --disable-largefile is passed, breaking the build. Work around it by
# simply adding it to CFLAGS for configure instead
SQLITE_CFLAGS += -DSQLITE_DISABLE_LFS
endif

ifeq ($(BR2_PACKAGE_SQLITE_STAT3),y)
SQLITE_CFLAGS += -DSQLITE_ENABLE_STAT3
endif

ifeq ($(BR2_PACKAGE_SQLITE_ENABLE_FTS3),y)
SQLITE_CFLAGS += -DSQLITE_ENABLE_FTS3
endif

ifeq ($(BR2_PACKAGE_SQLITE_ENABLE_UNLOCK_NOTIFY),y)
SQLITE_CFLAGS += -DSQLITE_ENABLE_UNLOCK_NOTIFY
endif

ifeq ($(BR2_PACKAGE_SQLITE_SECURE_DELETE),y)
SQLITE_CFLAGS += -DSQLITE_SECURE_DELETE
endif

ifeq ($(BR2_xtensa),y)
SQLITE_CFLAGS += -mtext-section-literals
endif

SQLITE_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) $(SQLITE_CFLAGS)"

SQLITE_CONF_OPT = \
	--localstatedir=/var

ifeq ($(BR2_PREFER_STATIC_LIB),y)
SQLITE_CONF_OPT += --enable-dynamic-extensions=no
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
SQLITE_CONF_OPT += --enable-threadsafe
else
SQLITE_CONF_OPT += --disable-threadsafe
endif

ifeq ($(BR2_PACKAGE_SQLITE_READLINE),y)
SQLITE_DEPENDENCIES += ncurses readline
SQLITE_CONF_OPT += --with-readline-inc="-I$(STAGING_DIR)/usr/include"
else
SQLITE_CONF_OPT += --disable-readline
endif

$(eval $(autotools-package))
