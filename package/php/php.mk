################################################################################
#
# php
#
################################################################################

PHP_VERSION = 5.5.19
PHP_SITE = http://www.php.net/distributions
PHP_SOURCE = php-$(PHP_VERSION).tar.xz
PHP_INSTALL_STAGING = YES
PHP_INSTALL_STAGING_OPTS = INSTALL_ROOT=$(STAGING_DIR) install
PHP_INSTALL_TARGET_OPTS = INSTALL_ROOT=$(TARGET_DIR) install
PHP_DEPENDENCIES = host-pkgconf
PHP_LICENSE = PHP
PHP_LICENSE_FILES = LICENSE
PHP_CONF_OPTS = --mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--disable-all \
		--without-pear \
		--with-config-file-path=/etc \
		--disable-rpath
PHP_CONF_ENV = EXTRA_LIBS="$(PHP_EXTRA_LIBS)"

ifeq ($(BR2_ENDIAN),"BIG")
PHP_CONF_ENV += ac_cv_c_bigendian_php=yes
else
PHP_CONF_ENV += ac_cv_c_bigendian_php=no
endif
PHP_CONFIG_SCRIPTS = php-config

PHP_CFLAGS = $(TARGET_CFLAGS)

# We need to force dl "detection"
ifeq ($(BR2_PREFER_STATIC_LIB),)
PHP_CONF_ENV += ac_cv_func_dlopen=yes ac_cv_lib_dl_dlopen=yes
PHP_EXTRA_LIBS += -ldl
else
PHP_CONF_ENV += ac_cv_func_dlopen=no ac_cv_lib_dl_dlopen=no
endif

# Workaround for non-IPv6 uClibc toolchain
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
ifneq ($(BR2_INET_IPV6),y)
	PHP_CFLAGS += -DHAVE_DEPRECATED_DNS_FUNCS
endif
endif

PHP_CONF_OPTS += $(if $(BR2_PACKAGE_PHP_CLI),,--disable-cli)
PHP_CONF_OPTS += $(if $(BR2_PACKAGE_PHP_CGI),,--disable-cgi)
PHP_CONF_OPTS += $(if $(BR2_PACKAGE_PHP_FPM),--enable-fpm,--disable-fpm)

### Extensions
PHP_CONF_OPTS += $(if $(BR2_PACKAGE_PHP_EXT_SOCKETS),--enable-sockets) \
		$(if $(BR2_PACKAGE_PHP_EXT_POSIX),--enable-posix) \
		$(if $(BR2_PACKAGE_PHP_EXT_SESSION),--enable-session) \
		$(if $(BR2_PACKAGE_PHP_EXT_HASH),--enable-hash) \
		$(if $(BR2_PACKAGE_PHP_EXT_DOM),--enable-dom) \
		$(if $(BR2_PACKAGE_PHP_EXT_SIMPLEXML),--enable-simplexml) \
		$(if $(BR2_PACKAGE_PHP_EXT_SOAP),--enable-soap) \
		$(if $(BR2_PACKAGE_PHP_EXT_XML),--enable-xml) \
		$(if $(BR2_PACKAGE_PHP_EXT_XMLREADER),--enable-xmlreader) \
		$(if $(BR2_PACKAGE_PHP_EXT_XMLWRITER),--enable-xmlwriter) \
		$(if $(BR2_PACKAGE_PHP_EXT_EXIF),--enable-exif) \
		$(if $(BR2_PACKAGE_PHP_EXT_FTP),--enable-ftp) \
		$(if $(BR2_PACKAGE_PHP_EXT_JSON),--enable-json) \
		$(if $(BR2_PACKAGE_PHP_EXT_TOKENIZER),--enable-tokenizer) \
		$(if $(BR2_PACKAGE_PHP_EXT_PCNTL),--enable-pcntl) \
		$(if $(BR2_PACKAGE_PHP_EXT_SHMOP),--enable-shmop) \
		$(if $(BR2_PACKAGE_PHP_EXT_SYSVMSG),--enable-sysvmsg) \
		$(if $(BR2_PACKAGE_PHP_EXT_SYSVSEM),--enable-sysvsem) \
		$(if $(BR2_PACKAGE_PHP_EXT_SYSVSHM),--enable-sysvshm) \
		$(if $(BR2_PACKAGE_PHP_EXT_ZIP),--enable-zip) \
		$(if $(BR2_PACKAGE_PHP_EXT_CTYPE),--enable-ctype) \
		$(if $(BR2_PACKAGE_PHP_EXT_FILTER),--enable-filter) \
		$(if $(BR2_PACKAGE_PHP_EXT_CALENDAR),--enable-calendar) \
		$(if $(BR2_PACKAGE_PHP_EXT_FILEINFO),--enable-fileinfo) \
		$(if $(BR2_PACKAGE_PHP_EXT_BCMATH),--enable-bcmath) \
		$(if $(BR2_PACKAGE_PHP_EXT_MBSTRING),--enable-mbstring) \
		$(if $(BR2_PACKAGE_PHP_EXT_PHAR),--enable-phar)

ifeq ($(BR2_PACKAGE_PHP_EXT_MCRYPT),y)
	PHP_CONF_OPTS += --with-mcrypt=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += libmcrypt
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_OPENSSL),y)
	PHP_CONF_OPTS += --with-openssl=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += openssl
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_LIBXML2),y)
	PHP_CONF_ENV += php_cv_libxml_build_works=yes
	PHP_CONF_OPTS += --enable-libxml --with-libxml-dir=${STAGING_DIR}/usr
	PHP_DEPENDENCIES += libxml2
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_WDDX),y)
	PHP_CONF_OPTS += --enable-wddx --with-libexpat-dir=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += expat
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_XMLRPC),y)
	PHP_CONF_OPTS += --with-xmlrpc \
		$(if $(BR2_PACKAGE_LIBICONV),--with-iconv-dir=$(STAGING_DIR)/usr)
	PHP_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)
endif

ifneq ($(BR2_PACKAGE_PHP_EXT_ZLIB)$(BR2_PACKAGE_PHP_EXT_ZIP),)
	PHP_CONF_OPTS += --with-zlib=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += zlib
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_GETTEXT),y)
	PHP_CONF_OPTS += --with-gettext=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += $(if $(BR2_NEEDS_GETTEXT),gettext)
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_ICONV),y)
ifeq ($(BR2_PACKAGE_LIBICONV),y)
	PHP_CONF_OPTS += --with-iconv=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += libiconv
else
	PHP_CONF_OPTS += --with-iconv
endif
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_INTL),y)
	PHP_CONF_OPTS += --enable-intl --with-icu-dir=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += icu
	# The intl module is implemented in C++, but PHP fails to use
	# g++ as the compiler for the final link. As a workaround,
	# tell it to link libstdc++.
	PHP_EXTRA_LIBS += -lstdc++
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_GMP),y)
	PHP_CONF_OPTS += --with-gmp=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += gmp
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_READLINE),y)
	PHP_CONF_OPTS += --with-readline=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += readline
endif

### Native MySQL extensions
ifeq ($(BR2_PACKAGE_PHP_EXT_MYSQL),y)
	PHP_CONF_OPTS += --with-mysql=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += mysql
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_MYSQLI),y)
	PHP_CONF_OPTS += --with-mysqli=$(STAGING_DIR)/usr/bin/mysql_config
	PHP_DEPENDENCIES += mysql
endif

### PDO
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO),y)
	PHP_CONF_OPTS += --enable-pdo
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO_SQLITE),y)
	PHP_CONF_OPTS += --with-pdo-sqlite=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += sqlite
	PHP_CFLAGS += -DSQLITE_OMIT_LOAD_EXTENSION
ifneq ($(BR2_LARGEFILE),y)
	PHP_CFLAGS += -DSQLITE_DISABLE_LFS
endif
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO_MYSQL),y)
	PHP_CONF_OPTS += --with-pdo-mysql=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += mysql
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO_POSTGRESQL),y)
	PHP_CONF_OPTS += --with-pdo-pgsql=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += postgresql
endif
endif

### Use external PCRE if it's available
ifeq ($(BR2_PACKAGE_PCRE),y)
	PHP_CONF_OPTS += --with-pcre-regex=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += pcre
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_CURL),y)
	PHP_CONF_OPTS += --with-curl=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += libcurl
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_XSL),y)
	PHP_CONF_OPTS += --with-xsl=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += libxslt
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_BZIP2),y)
	PHP_CONF_OPTS += --with-bz2=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += bzip2
endif

### DBA
ifeq ($(BR2_PACKAGE_PHP_EXT_DBA),y)
	PHP_CONF_OPTS += --enable-dba
ifneq ($(BR2_PACKAGE_PHP_EXT_DBA_CDB),y)
	PHP_CONF_OPTS += --without-cdb
endif
ifneq ($(BR2_PACKAGE_PHP_EXT_DBA_FLAT),y)
	PHP_CONF_OPTS += --without-flatfile
endif
ifneq ($(BR2_PACKAGE_PHP_EXT_DBA_INI),y)
	PHP_CONF_OPTS += --without-inifile
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_DBA_DB4),y)
	PHP_CONF_OPTS += --with-db4=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += berkeleydb
endif
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_SNMP),y)
	PHP_CONF_OPTS += --with-snmp=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += netsnmp
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_GD),y)
	PHP_CONF_OPTS += --with-gd --with-jpeg-dir=$(STAGING_DIR)/usr \
		--with-png-dir=$(STAGING_DIR)/usr \
		--with-zlib-dir=$(STAGING_DIR)/usr \
		--with-freetype-dir=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += jpeg libpng freetype
endif

define PHP_EXTENSIONS_FIXUP
	$(SED) "/prefix/ s:/usr:$(STAGING_DIR)/usr:" \
		$(STAGING_DIR)/usr/bin/phpize
	$(SED) "/extension_dir/ s:/usr:$(TARGET_DIR)/usr:" \
		$(STAGING_DIR)/usr/bin/php-config
endef

PHP_POST_INSTALL_TARGET_HOOKS += PHP_EXTENSIONS_FIXUP

define PHP_INSTALL_FIXUP
	rm -rf $(TARGET_DIR)/usr/lib/php
	rm -f $(TARGET_DIR)/usr/bin/phpize
	if [ ! -f $(TARGET_DIR)/etc/php.ini ]; then \
		$(INSTALL) -m 0755  $(PHP_DIR)/php.ini-production \
			$(TARGET_DIR)/etc/php.ini; \
	fi
endef

PHP_POST_INSTALL_TARGET_HOOKS += PHP_INSTALL_FIXUP

PHP_CONF_ENV += CFLAGS="$(PHP_CFLAGS)"

$(eval $(autotools-package))
