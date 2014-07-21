################################################################################
#
# php-memcached
#
################################################################################

PHP_MEMCACHED_VERSION = 2.2.0
PHP_MEMCACHED_SOURCE = memcached-$(PHP_MEMCACHED_VERSION).tgz
PHP_MEMCACHED_SITE = http://pecl.php.net/get
PHP_MEMCACHED_CONF_OPT = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--disable-memcached-sasl \
	--with-libmemcached-dir=$(STAGING_DIR)/usr \
	--with-zlib-dir=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_MEMCACHED_DEPENDENCIES = libmemcached php zlib host-autoconf host-pkgconf
PHP_MEMCACHED_LICENSE = MIT
PHP_MEMCACHED_LICENSE_FILES = LICENSE

define PHP_MEMCACHED_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_MEMCACHED_PRE_CONFIGURE_HOOKS += PHP_MEMCACHED_PHPIZE

$(eval $(autotools-package))
