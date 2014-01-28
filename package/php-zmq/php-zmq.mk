################################################################################
#
# php-zmq
#
################################################################################

PHP_ZMQ_VERSION = 1.1.2
PHP_ZMQ_SOURCE = zmq-$(PHP_ZMQ_VERSION).tgz
PHP_ZMQ_SITE = http://pecl.php.net/get
# phpize does the autoconf magic
PHP_ZMQ_DEPENDENCIES = php zeromq host-autoconf host-pkgconf
PHP_ZMQ_CONF_OPT = --with-php-config=$(STAGING_DIR)/usr/bin/php-config
PHP_ZMQ_LICENSE = BSD-3c
PHP_ZMQ_LICENSE_FILES = LICENSE

define PHP_ZMQ_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_ZMQ_PRE_CONFIGURE_HOOKS += PHP_ZMQ_PHPIZE

$(eval $(autotools-package))
