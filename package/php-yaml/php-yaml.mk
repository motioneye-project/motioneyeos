################################################################################
#
# php-yaml
#
################################################################################

PHP_YAML_VERSION = 1.1.1
PHP_YAML_SOURCE = yaml-$(PHP_YAML_VERSION).tgz
# pecl.php.net returns html with db connect failed
PHP_YAML_SITE = http://sources.buildroot.net
PHP_YAML_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-yaml=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_YAML_DEPENDENCIES = libyaml php host-autoconf
PHP_YAML_LICENSE = MIT
PHP_YAML_LICENSE_FILES = LICENSE

define PHP_YAML_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_YAML_PRE_CONFIGURE_HOOKS += PHP_YAML_PHPIZE

$(eval $(autotools-package))
