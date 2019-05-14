################################################################################
#
# monkey
#
################################################################################

MONKEY_VERSION_MAJOR = 1.6
MONKEY_VERSION = $(MONKEY_VERSION_MAJOR).9
MONKEY_SITE = http://monkey-project.com/releases/$(MONKEY_VERSION_MAJOR)
MONKEY_LICENSE = Apache-2.0
MONKEY_LICENSE_FILES = LICENSE

# This package has a configure script, but it's not using
# autoconf/automake, so we're using the generic-package
# infrastructure.

MONKEY_CONF_OPTS = \
	-DINSTALL_SYSCONFDIR=/etc/monkey \
	-DINSTALL_WEBROOTDIR=/var/www \
	-DWITH_SYSTEM_MALLOC=1

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
MONKEY_CONF_OPTS += -DWITH_UCLIB=1 -DWITH_BACKTRACE=0
endif

ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
MONKEY_CONF_OPTS += -DWITH_MUSL=1 -DWITH_BACKTRACE=0
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
MONKEY_CONF_OPTS += -DWITH_DEBUG=1
endif

ifeq ($(BR2_PACKAGE_MONKEY_SSL),y)
MONKEY_CONF_OPTS += -DWITH_PLUGINS=tls -DWITH_MBEDTLS_SHARED=1
MONKEY_DEPENDENCIES += mbedtls
endif

$(eval $(cmake-package))
