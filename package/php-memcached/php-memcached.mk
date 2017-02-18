################################################################################
#
# php-memcached
#
################################################################################

PHP_MEMCACHED_VERSION = 6ee96cad7be5caa1f13a1f3e5a4d5f900b9c04ce
PHP_MEMCACHED_SITE = $(call github,php-memcached-dev,php-memcached,$(PHP_MEMCACHED_VERSION))
PHP_MEMCACHED_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
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
