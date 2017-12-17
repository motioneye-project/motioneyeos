################################################################################
#
# php-yaml
#
################################################################################

PHP_YAML_VERSION = 2.0.2
PHP_YAML_SOURCE = yaml-$(PHP_YAML_VERSION).tgz
PHP_YAML_SITE = https://pecl.php.net/get
PHP_YAML_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-yaml=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_YAML_DEPENDENCIES = libyaml php host-autoconf
PHP_YAML_LICENSE = MIT
PHP_YAML_LICENSE_FILES = LICENSE

define PHP_YAML_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_YAML_PRE_CONFIGURE_HOOKS += PHP_YAML_PHPIZE

$(eval $(autotools-package))
