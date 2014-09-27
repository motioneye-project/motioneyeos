################################################################################
#
# php-gnupg
#
################################################################################

PHP_GNUPG_VERSION = 1.3.3
PHP_GNUPG_SOURCE = gnupg-$(PHP_GNUPG_VERSION).tgz
# pecl.php.net returns html with db connect failed
PHP_GNUPG_SITE = http://sources.buildroot.net
# phpize does the autoconf magic
PHP_GNUPG_DEPENDENCIES = php libgpgme host-autoconf host-pkgconf
PHP_GNUPG_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-gnupg=$(STAGING_DIR)/usr/include --with-gpg=/usr/bin/gpg
PHP_GNUPG_LICENSE = BSD-2c
PHP_GNUPG_LICENSE_FILES = LICENSE

define PHP_GNUPG_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_GNUPG_PRE_CONFIGURE_HOOKS += PHP_GNUPG_PHPIZE

$(eval $(autotools-package))
