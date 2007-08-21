#############################################################
#
# php
#
#############################################################
PHP_VER:=5.2.3
PHP_SOURCE:=php-$(PHP_VER).tar.bz2
PHP_SITE:=http://us.php.net/get/${PHP_SOURCE}/from/us2.php.net/mirror
PHP_DIR:=$(BUILD_DIR)/php-$(PHP_VER)
PHP_CAT=bzcat
PHP_DEPS=
PHP_TARGET_DEPS=

ifneq ($(BR2_PACKAGE_PHP_CLI),y)
	PHP_CLI="--disable-cli"
else
	PHP_CLI="--enable-cli"
	PHP_TARGET_DEPS+=$(TARGET_DIR)/usr/bin/php
endif

ifneq ($(BR2_PACKAGE_PHP_CGI),y)
	PHP_CGI=--disable-cgi
else
	PHP_CGI=--enable-cgi
	PHP_TARGET_DEPS+=$(TARGET_DIR)/usr/bin/php-cgi
	ifeq ($(BR2_PACKAGE_PHP_FASTCGI),y)
		PHP_CGI+=--enable-fastcgi
	endif
endif

ifeq ($(BR2_PACKAGE_PHP_OPENSSL),y)
	PHP_OPENSSL="--with-openssl=$(STAGING_DIR)/usr"
	PHP_DEPS+=openssl
endif

ifeq ($(BR2_PACKAGE_PHP_XML2),y)
	PHP_XML=--enable-libxml \
		--with-libxml-dir=${STAGING_DIR}/usr \
		 --enable-xml \
		 --enable-xmlreader \
		 --enable-xmlwriter
	PHP_DEPS+=libxml2
endif

ifeq ($(BR2_PACKAGE_PHP_ZLIB),y)
	PHP_ZLIB="--with-zlib=$(STAGING_DIR)/usr"
	PHP_DEPS+=zlib
endif


$(DL_DIR)/$(PHP_SOURCE):
	 $(WGET) -P $(DL_DIR) $(PHP_SITE)

php-source: $(DL_DIR)/$(PHP_SOURCE)

$(PHP_DIR)/.unpacked: $(DL_DIR)/$(PHP_SOURCE)
	$(PHP_CAT) $(DL_DIR)/$(PHP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(PHP_DIR)/.unpacked

$(PHP_DIR)/.configured: $(PHP_DIR)/.unpacked
	(cd $(PHP_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CC=$(TARGET_CC) \
		./configure \
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
		--enable-spl \
		--enable-session \
		--enable-sockets \
		--enable-posix \
		--with-pcre-regex \
		--without-pear \
		--disable-ipv6 \
		$(DISABLE_NLS) \
		$(PHP_OPENSSL) \
		$(PHP_XML) \
		$(PHP_CLI) \
		$(PHP_CGI) \
		$(PHP_ZLIB) \
	)
	touch $(PHP_DIR)/.configured

$(PHP_DIR)/.built: $(PHP_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(PHP_DIR)
	touch $(PHP_DIR)/.built

$(PHP_DIR)/.staged: $(PHP_DIR)/.built
	$(MAKE) DESTDIR=$(STAGING_DIR) INSTALL_ROOT=$(STAGING_DIR) CC=$(TARGET_CC) -C $(PHP_DIR) install
	touch $(PHP_DIR)/.staged

$(TARGET_DIR)/usr/bin/php: $(PHP_DIR)/.staged
	cp -dpf $(STAGING_DIR)/usr/bin/php $(TARGET_DIR)/usr/bin/php
	chmod 755 $(TARGET_DIR)/usr/bin/php
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/php

$(TARGET_DIR)/usr/bin/php-cgi: $(PHP_DIR)/.staged
	cp -dpf $(STAGING_DIR)/usr/bin/php-cgi $(TARGET_DIR)/usr/bin/php-cgi
	chmod 755 $(TARGET_DIR)/usr/bin/php-cgi
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/php-cgi

$(TARGET_DIR)/etc/php.ini: $(PHP_DIR)/.staged
	cp $(PHP_DIR)/php.ini-dist $(TARGET_DIR)/etc/php.ini

php: uclibc $(PHP_DEPS) $(PHP_TARGET_DEPS) $(TARGET_DIR)/etc/php.ini

php-clean:
	rm -f $(PHP_DIR)/.configured $(PHP_DIR)/.built $(PHP_DIR)/.staged
	rm -f $(TARGET_DIR)/usr/bin/php $(TARGET_DIR)/usr/bin/php-cgi
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
ifeq ($(strip $(BR2_PACKAGE_PHP)),y)
TARGETS+=php
endif
