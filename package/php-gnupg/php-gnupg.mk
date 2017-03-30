################################################################################
#
# php-gnupg
#
################################################################################

PHP_GNUPG_VERSION = 30fab6eaf9eb61c65b3b46987442be058cbd7823
PHP_GNUPG_SITE = $(call github,Sean-Der,pecl-encryption-gnupg,$(PHP_GNUPG_VERSION))
# phpize does the autoconf magic
PHP_GNUPG_DEPENDENCIES = php libgpgme host-autoconf host-pkgconf
PHP_GNUPG_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-gnupg=$(STAGING_DIR)/usr/include --with-gpg=/usr/bin/gpg
PHP_GNUPG_LICENSE = BSD-2-Clause
PHP_GNUPG_LICENSE_FILES = LICENSE

define PHP_GNUPG_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_GNUPG_PRE_CONFIGURE_HOOKS += PHP_GNUPG_PHPIZE

$(eval $(autotools-package))
