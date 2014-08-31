################################################################################
#
# php-geoip
#
################################################################################

PHP_GEOIP_VERSION = 1.1.0
PHP_GEOIP_SOURCE = geoip-$(PHP_GEOIP_VERSION).tgz
# pecl.php.net returns html with db connect failed
PHP_GEOIP_SITE = http://sources.buildroot.net
PHP_GEOIP_CONF_OPT = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-geoip=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_GEOIP_DEPENDENCIES = geoip php host-autoconf
PHP_GEOIP_LICENSE = PHP
PHP_GEOIP_LICENSE_FILES = LICENSE

define PHP_GEOIP_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_GEOIP_PRE_CONFIGURE_HOOKS += PHP_GEOIP_PHPIZE

$(eval $(autotools-package))
