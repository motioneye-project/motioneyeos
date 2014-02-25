################################################################################
#
# php-gnupg
#
################################################################################

PHP_GNUPG_VERSION = 1.3.3
PHP_GNUPG_SOURCE = gnupg-$(PHP_GNUPG_VERSION).tgz
PHP_GNUPG_SITE = http://pecl.php.net/get
# phpize does the autoconf magic
PHP_GNUPG_DEPENDENCIES = php libgpgme host-autoconf host-pkgconf
PHP_GNUPG_CONF_OPT = --with-php-config=$(STAGING_DIR)/usr/bin/php-config
PHP_GNUPG_LICENSE = BSD-2c
PHP_GNUPG_LICENSE_FILES = LICENSE

define PHP_GNUPG_PHPIZE
	(cd $(@D); \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_GNUPG_PRE_CONFIGURE_HOOKS += PHP_GNUPG_PHPIZE

$(eval $(autotools-package))
