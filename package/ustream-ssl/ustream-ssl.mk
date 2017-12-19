################################################################################
#
# ustream-ssl
#
################################################################################

USTREAM_SSL_VERSION = 45ac93088bc6f2d8ef3b0512d8e1ddfd9c4ee9e5
USTREAM_SSL_SITE = git://git.openwrt.org/project/ustream-ssl.git
USTREAM_SSL_LICENSE = ISC
USTREAM_SSL_LICENSE_FILES = ustream-ssl.h
USTREAM_SSL_INSTALL_STAGING = YES
USTREAM_SSL_DEPENDENCIES = libubox

ifeq ($(BR2_PACKAGE_MBEDTLS),y)
USTREAM_SSL_DEPENDENCIES += mbedtls
USTREAM_SSL_CONF_OPTS += -DMBEDTLS=ON
else
USTREAM_SSL_DEPENDENCIES += openssl
endif

$(eval $(cmake-package))
