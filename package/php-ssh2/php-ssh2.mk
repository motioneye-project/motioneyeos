################################################################################
#
# php-ssh2
#
################################################################################

PHP_SSH2_VERSION = 0.12
PHP_SSH2_SOURCE = ssh2-$(PHP_SSH2_VERSION).tgz
PHP_SSH2_SITE = http://pecl.php.net/get
PHP_SSH2_CONF_OPT = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-ssh2=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_SSH2_DEPENDENCIES = libssh2 php host-autoconf
PHP_SSH2_LICENSE = PHP
PHP_SSH2_LICENSE_FILES = LICENSE

define PHP_SSH2_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_SSH2_PRE_CONFIGURE_HOOKS += PHP_SSH2_PHPIZE

$(eval $(autotools-package))
