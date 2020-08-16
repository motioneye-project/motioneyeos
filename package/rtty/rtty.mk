################################################################################
#
# rtty
#
################################################################################

RTTY_VERSION = 7.1.3
RTTY_SITE = https://github.com/zhaojh329/rtty/releases/download/v$(RTTY_VERSION)
RTTY_LICENSE = MIT
RTTY_LICENSE_FILES = LICENSE
RTTY_DEPENDENCIES = libev

ifeq ($(BR2_PACKAGE_MBEDTLS),y)
RTTY_DEPENDENCIES += mbedtls
RTTY_CONF_OPTS += \
	-DRTTY_SSL_SUPPORT=ON \
	-DRTTY_USE_MBEDTLS=ON \
	-DRTTY_USE_OPENSSL=OFF \
	-DRTTY_USE_WOLFSSL=OFF
else ifeq ($(BR2_PACKAGE_OPENSSL),y)
RTTY_DEPENDENCIES += host-pkgconf openssl
RTTY_CONF_OPTS += \
	-DRTTY_SSL_SUPPORT=ON \
	-DRTTY_USE_MBEDTLS=OFF \
	-DRTTY_USE_OPENSSL=ON \
	-DRTTY_USE_WOLFSSL=OFF
else ifeq ($(BR2_PACKAGE_WOLFSSL),y)
RTTY_DEPENDENCIES += wolfssl
RTTY_CONF_OPTS += \
	-DRTTY_SSL_SUPPORT=ON \
	-DRTTY_USE_MBEDTLS=OFF \
	-DRTTY_USE_OPENSSL=OFF \
	-DRTTY_USE_WOLFSSL=ON
else
RTTY_CONF_OPTS += -DRTTY_SSL_SUPPORT=OFF
endif

$(eval $(cmake-package))
