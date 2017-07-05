################################################################################
#
# php-memcached
#
################################################################################

PHP_MEMCACHED_VERSION = 3.0.3
PHP_MEMCACHED_SOURCE = memcached-$(PHP_MEMCACHED_VERSION).tgz
PHP_MEMCACHED_SITE = https://pecl.php.net/get
PHP_MEMCACHED_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--disable-memcached-sasl \
	--with-libmemcached-dir=$(STAGING_DIR)/usr \
	--with-zlib-dir=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_MEMCACHED_DEPENDENCIES = libmemcached php zlib host-autoconf host-pkgconf
PHP_MEMCACHED_LICENSE = PHP-3.01, MIT (fastlz), ISC-like (g_fmt.c, g_fmt.h)
PHP_MEMCACHED_LICENSE_FILES = LICENSE fastlz/LICENSE g_fmt.h

define PHP_MEMCACHED_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_MEMCACHED_PRE_CONFIGURE_HOOKS += PHP_MEMCACHED_PHPIZE

$(eval $(autotools-package))
