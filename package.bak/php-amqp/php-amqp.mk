################################################################################
#
# php-amqp
#
################################################################################

PHP_AMQP_VERSION = 1.7.1
PHP_AMQP_SOURCE = amqp-$(PHP_AMQP_VERSION).tgz
PHP_AMQP_SITE = https://pecl.php.net/get
PHP_AMQP_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-amqp=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_AMQP_DEPENDENCIES = rabbitmq-c php host-autoconf
PHP_AMQP_LICENSE = PHP
PHP_AMQP_LICENSE_FILES = LICENSE

define PHP_AMQP_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/usr/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/usr/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_AMQP_PRE_CONFIGURE_HOOKS += PHP_AMQP_PHPIZE

$(eval $(autotools-package))
