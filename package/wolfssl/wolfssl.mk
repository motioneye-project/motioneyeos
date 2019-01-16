################################################################################
#
# wolfssl
#
################################################################################

WOLFSSL_VERSION = 3.15.7
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

# enable ARMv8 hardware acceleration
ifeq ($(BR2_ARM_CPU_ARMV8A),y)
WOLFSSL_CONF_OPTS += --enable-armasm
# the flag -mstrict-align is needed to prevent build errors caused by
# some inline assembly in parts of the AES structure using the "m"
# constraint
ifeq ($(BR2_aarch64),y)
WOLFSSL_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) -mstrict-align"
endif
else
WOLFSSL_CONF_OPTS += --disable-armasm
endif

$(eval $(autotools-package))
