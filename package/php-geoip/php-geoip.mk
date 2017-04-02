################################################################################
#
# php-geoip
#
################################################################################

PHP_GEOIP_VERSION = ebb68228ad94298a305710f701b2ade9acff985d
PHP_GEOIP_SITE = $(call github,php7-extensions,ext-php7-geoip,$(PHP_GEOIP_VERSION))
PHP_GEOIP_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-geoip=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_GEOIP_DEPENDENCIES = geoip php host-autoconf
PHP_GEOIP_LICENSE = PHP-3.01
PHP_GEOIP_LICENSE_FILES = geoip.c

define PHP_GEOIP_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_GEOIP_PRE_CONFIGURE_HOOKS += PHP_GEOIP_PHPIZE

$(eval $(autotools-package))
