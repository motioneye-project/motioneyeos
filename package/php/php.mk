#############################################################
#
# php
#
#############################################################
PHP_VER:=5.2.7
PHP_SOURCE:=php-$(PHP_VER).tar.bz2
PHP_SITE:=http://us.php.net/get/${PHP_SOURCE}/from/us2.php.net/mirror
PHP_DIR:=$(BUILD_DIR)/php-$(PHP_VER)
PHP_CAT=$(BZCAT)
PHP_DEPS=
PHP_TARGET_DEPS=
PHP_CONFIGURE = $(ENABLE_DEBUG)

ifneq ($(BR2_PACKAGE_PHP_CLI),y)
	PHP_CONFIGURE+=--disable-cli
else
	PHP_CONFIGURE+=--enable-cli
	PHP_TARGET_DEPS+=$(TARGET_DIR)/usr/bin/php
endif

ifneq ($(BR2_PACKAGE_PHP_CGI),y)
	PHP_CONFIGURE+=--disable-cgi
else
	PHP_CONFIGURE=--enable-cgi
	PHP_TARGET_DEPS+=$(TARGET_DIR)/usr/bin/php-cgi
	ifeq ($(BR2_PACKAGE_PHP_FASTCGI),y)
		PHP_CONFIGURE+=--enable-fastcgi
	endif
endif

ifneq ($(BR2_INET_IPV6),y)
	PHP_CONFIGURE+=--disable-ipv6
endif

### Extensions
ifeq ($(BR2_PACKAGE_PHP_EXT_SOCKETS),y)
	PHP_CONFIGURE+=--enable-sockets
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_POSIX),y)
	PHP_CONFIGURE+=--enable-posix
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_SPL),y)
	PHP_CONFIGURE+=--enable-spl
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_SESSION),y)
	PHP_CONFIGURE+=--enable-session
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_OPENSSL),y)
	PHP_CONFIGURE+=--with-openssl=$(STAGING_DIR)/usr
	PHP_DEPS+=openssl
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_LIBXML2),y)
	PHP_CONFIGURE+=--enable-libxml \
		--with-libxml-dir=${STAGING_DIR}/usr \
		 --enable-xml \
		 --enable-xmlreader \
		 --enable-xmlwriter
	PHP_DEPS+=libxml2
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_SIMPLEXML),y)
	PHP_CONFIGURE+=--enable-simplexml
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_ZLIB),y)
	PHP_CONFIGURE+=--with-zlib=$(STAGING_DIR)/usr
	PHP_DEPS+=zlib
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_EXIF),y)
	PHP_CONFIGURE+=--enable-exif
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_FTP),y)
	PHP_CONFIGURE+=--enable-ftp
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_GETTEXT),y)
	PHP_CONFIGURE+=--with-gettext=$(STAGING_DIR)/usr
	PHP_DEPS+=gettext
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_GMP),y)
	PHP_CONFIGURE+=--with-gmp=$(STAGING_DIR)/usr
	PHP_DEPS+=libgmp
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_JSON),y)
	PHP_CONFIGURE+=--enable-json
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_READLINE),y)
	PHP_CONFIGURE+=--with-readline=$(STAGING_DIR)/usr
	PHP_DEPS+=readline
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_NCURSES),y)
	PHP_CONFIGURE+=--with-ncurses=$(STATING_DIR)/usr
	PHP_DEPS+=ncurses
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_SYSVMSG),y)
	PHP_CONFIGURE+=--enable-sysvmsg
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_SYSVSEM),y)
	PHP_CONFIGURE+=--enable-sysvsem
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_SYSVSHM),y)
	PHP_CONFIGURE+=--enable-sysvshm
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_ZIP),y)
	PHP_CONFIGURE+=--enable-zip
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_FILTER),y)
	PHP_CONFIGURE+=--enable-filter
endif

### Database extensions
ifeq ($(BR2_PACKAGE_PHP_EXT_SQLITE),y)
	PHP_CONFIGURE+=--with-sqlite
	PHP_DEPS+=sqlite
ifeq ($(BR2_PACKAGE_PHP_EXT_SQLITE_UTF8),y)
	PHP_CONFIGURE+=--enable-sqlite-utf8
endif
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO),y)
	PHP_CONFIGURE+=--enable-pdo
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO_SQLITE),y)
	PHP_CONFIGURE+=--with-pdo-sqlite
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO_MYSQL),y)
	PHP_CONFIGURE+=--with-pdo-mysql=$(STAGING_DIR)/usr
	PHP_DEPS+=mysql_client
endif
endif

$(DL_DIR)/$(PHP_SOURCE):
	 $(WGET) -P $(DL_DIR) $(PHP_SITE)

php-source: $(DL_DIR)/$(PHP_SOURCE)

$(PHP_DIR)/.unpacked: $(DL_DIR)/$(PHP_SOURCE)
	$(PHP_CAT) $(DL_DIR)/$(PHP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(PHP_DIR)/.configured: $(PHP_DIR)/.unpacked
	(cd $(PHP_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CC=$(TARGET_CC) \
		./configure $(DISABLE_NLS) \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/ \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--with-config-file-path=/etc \
		--datadir=/usr/share/misc \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-all \
		--with-pcre-regex \
		--without-pear \
		$(PHP_CONFIGURE) \
	)
	touch $@

$(PHP_DIR)/.built: $(PHP_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(PHP_DIR)
	touch $@

$(PHP_DIR)/.staged: $(PHP_DIR)/.built
	$(MAKE) DESTDIR=$(STAGING_DIR) INSTALL_ROOT=$(STAGING_DIR) CC=$(TARGET_CC) -C $(PHP_DIR) install
	touch $@

$(TARGET_DIR)/usr/bin/php: $(PHP_DIR)/.staged
	cp -dpf $(STAGING_DIR)/usr/bin/php $(TARGET_DIR)/usr/bin/php
	chmod 755 $(TARGET_DIR)/usr/bin/php
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/php

$(TARGET_DIR)/usr/bin/php-cgi: $(PHP_DIR)/.staged
	cp -dpf $(STAGING_DIR)/usr/bin/php-cgi $(TARGET_DIR)/usr/bin/php-cgi
	chmod 755 $(TARGET_DIR)/usr/bin/php-cgi
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/php-cgi

$(TARGET_DIR)/etc/php.ini: $(PHP_DIR)/.staged
	cp -f $(PHP_DIR)/php.ini-dist $(TARGET_DIR)/etc/php.ini

php: uclibc $(PHP_DEPS) $(PHP_TARGET_DEPS) $(TARGET_DIR)/etc/php.ini

php-clean:
	rm -f $(PHP_DIR)/.configured $(PHP_DIR)/.built $(PHP_DIR)/.staged
	rm -f $(PHP_TARGET_DEPS)
	rm -f $(STAGING_DIR)/usr/bin/php* $(STAGING_DIR)/usr/man/man1/php*
	rm -rf $(STAGING_DIR)/usr/include/php
	-$(MAKE) -C $(PHP_DIR) clean

php-dirclean:
	rm -rf $(PHP_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_PHP),y)
TARGETS+=php
endif
