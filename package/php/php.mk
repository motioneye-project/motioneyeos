#############################################################
#
# php
#
#############################################################

PHP_VERSION = 5.2.17
PHP_SOURCE = php-$(PHP_VERSION).tar.bz2
PHP_SITE = http://www.php.net/distributions
PHP_INSTALL_STAGING = YES
PHP_INSTALL_STAGING_OPT = INSTALL_ROOT=$(STAGING_DIR) install
PHP_INSTALL_TARGET_OPT = INSTALL_ROOT=$(TARGET_DIR) install
PHP_LIBTOOL_PATCH = NO
PHP_CONF_OPT =  --mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--disable-all \
		--without-pear \
		--with-config-file-path=/etc \
		--localstatedir=/var \

PHP_CFLAGS = $(TARGET_CFLAGS)

ifneq ($(BR2_PACKAGE_PHP_CLI),y)
	PHP_CONF_OPT += --disable-cli
else
	PHP_CONF_OPT += --enable-cli
endif

ifneq ($(BR2_PACKAGE_PHP_CGI),y)
	PHP_CONF_OPT += --disable-cgi
else
	PHP_CONF_OPT += --enable-cgi
	ifeq ($(BR2_PACKAGE_PHP_FASTCGI),y)
		PHP_CONF_OPT += --enable-fastcgi
	endif
endif

### Extensions
ifeq ($(BR2_PACKAGE_PHP_EXT_SOCKETS),y)
	PHP_CONF_OPT += --enable-sockets
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_POSIX),y)
	PHP_CONF_OPT += --enable-posix
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_SPL),y)
	PHP_CONF_OPT += --enable-spl
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_SESSION),y)
	PHP_CONF_OPT += --enable-session
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_OPENSSL),y)
	PHP_CONF_OPT += --with-openssl=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += openssl
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_LIBXML2),y)
	PHP_CONF_OPT += --enable-libxml \
		--with-libxml-dir=${STAGING_DIR}/usr \
		 --enable-xml \
		 --enable-xmlreader \
		 --enable-xmlwriter
	PHP_DEPENDENCIES += libxml2
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_SIMPLEXML),y)
	PHP_CONF_OPT += --enable-simplexml
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_ZLIB),y)
	PHP_CONF_OPT += --with-zlib=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += zlib
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_EXIF),y)
	PHP_CONF_OPT += --enable-exif
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_FTP),y)
	PHP_CONF_OPT += --enable-ftp
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_GETTEXT),y)
	PHP_CONF_OPT += --with-gettext=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += $(if $(BR2_NEEDS_GETTEXT),gettext)
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_GMP),y)
	PHP_CONF_OPT += --with-gmp=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += gmp
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_JSON),y)
	PHP_CONF_OPT += --enable-json
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_READLINE),y)
	PHP_CONF_OPT += --with-readline=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += readline
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_NCURSES),y)
	PHP_CONF_OPT += --with-ncurses=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += ncurses
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_PCNTL),y)
	PHP_CONF_OPT += --enable-pcntl
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_SYSVMSG),y)
	PHP_CONF_OPT += --enable-sysvmsg
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_SYSVSEM),y)
	PHP_CONF_OPT += --enable-sysvsem
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_SYSVSHM),y)
	PHP_CONF_OPT += --enable-sysvshm
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_ZIP),y)
	PHP_CONF_OPT += --enable-zip
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_FILTER),y)
	PHP_CONF_OPT += --enable-filter
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_CALENDAR),y)
	PHP_CONF_OPT += --enable-calendar
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_PCRE),y)
	PHP_CONF_OPT += --with-pcre-regex
endif

### Legacy sqlite2 support
ifeq ($(BR2_PACKAGE_PHP_EXT_SQLITE),y)
	PHP_CONF_OPT += --with-sqlite
ifneq ($(BR2_LARGEFILE),y)
	PHP_CFLAGS += -DSQLITE_DISABLE_LFS
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_SQLITE_UTF8),y)
	PHP_CONF_OPT += --enable-sqlite-utf8
endif
endif

### PDO
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO),y)
	PHP_CONF_OPT += --enable-pdo
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO_SQLITE),y)
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO_SQLITE_EXTERNAL),y)
	PHP_CONF_OPT += --with-pdo-sqlite=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += sqlite
else
	PHP_CONF_OPT += --with-pdo-sqlite
endif
	PHP_CFLAGS += -DSQLITE_OMIT_LOAD_EXTENSION
ifneq ($(BR2_LARGEFILE),y)
	PHP_CFLAGS += -DSQLITE_DISABLE_LFS
endif
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO_MYSQL),y)
	PHP_CONF_OPT += --with-pdo-mysql=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += mysql_client
endif
endif

define PHP_INSTALL_FIXUP
	rm -rf $(TARGET_DIR)/usr/lib/php
	rm -f $(TARGET_DIR)/usr/bin/phpize
	rm -f $(TARGET_DIR)/usr/bin/php-config
	if [ ! -f $(TARGET_DIR)/etc/php.ini ]; then \
		$(INSTALL) -m 0755 $(BR2_PACKAGE_PHP_CONFIG) $(TARGET_DIR)/etc/php.ini; fi
endef

PHP_POST_INSTALL_TARGET_HOOKS += PHP_INSTALL_FIXUP

define PHP_UNINSTALL_STAGING_CMDS
	rm -rf $(STAGING_DIR)/usr/include/php
	rm -rf $(STAGING_DIR)/usr/lib/php
	rm -f $(STAGING_DIR)/usr/bin/php*
	rm -f $(STAGING_DIR)/usr/share/man/man1/php*.1
endef

define PHP_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/etc/php.ini
	rm -f $(TARGET_DIR)/usr/bin/php*
endef

PHP_CONF_ENV += CFLAGS="$(PHP_CFLAGS)"

$(eval $(call AUTOTARGETS,package,php))
