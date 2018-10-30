################################################################################
#
# wolfssl
#
################################################################################

WOLFSSL_VERSION = 3.14.0
WOLFSSL_SITE = https://github.com/wolfSSL/wolfssl/archive
WOLFSSL_SOURCE = v$(WOLFSSL_VERSION)-stable.tar.gz
WOLFSSL_INSTALL_STAGING = YES

WOLFSSL_LICENSE = GPL-2.0
WOLFSSL_LICENSE_FILES = COPYING LICENSING

WOLFSSL_DEPENDENCIES = host-pkgconf

# wolfssl's source code is released without a configure
# script, so we need autoreconf
WOLFSSL_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_WOLFSSL_ALL),y)
WOLFSSL_CONF_OPTS += --enable-all
else
WOLFSSL_CONF_OPTS += --disable-all
endif

ifeq ($(BR2_PACKAGE_WOLFSSL_SSLV3),y)
WOLFSSL_CONF_OPTS += --enable-sslv3
else
WOLFSSL_CONF_OPTS += --disable-sslv3
endif

# build fails when ARMv8 hardware acceleration is enabled
WOLFSSL_CONF_OPTS += --disable-armasm

$(eval $(autotools-package))
