################################################################################
#
# php-geoip
#
################################################################################

PHP_GEOIP_VERSION = 1.1.1
PHP_GEOIP_SOURCE = geoip-$(PHP_GEOIP_VERSION).tgz
PHP_GEOIP_SITE = https://pecl.php.net/get
PHP_GEOIP_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-geoip=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_GEOIP_DEPENDENCIES = geoip php host-autoconf
PHP_GEOIP_LICENSE = PHP-3.01
PHP_GEOIP_LICENSE_FILES = geoip.c

define PHP_GEOIP_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_GEOIP_PRE_CONFIGURE_HOOKS += PHP_GEOIP_PHPIZE

$(eval $(autotools-package))
