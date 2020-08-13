################################################################################
#
# libcoap
#
################################################################################

LIBCOAP_VERSION = 4.2.0
LIBCOAP_SITE = $(call github,obgm,libcoap,v$(LIBCOAP_VERSION))
LIBCOAP_INSTALL_STAGING = YES
LIBCOAP_LICENSE = BSD-2-Clause
LIBCOAP_LICENSE_FILES = COPYING LICENSE
LIBCOAP_DEPENDENCIES = host-pkgconf
LIBCOAP_CONF_OPTS = --disable-examples --without-tinydtls
LIBCOAP_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_GNUTLS),y)
LIBCOAP_DEPENDENCIES += gnutls
LIBCOAP_CONF_OPTS += --enable-dtls --with-gnutls --without-openssl
else ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBCOAP_DEPENDENCIES += openssl
LIBCOAP_CONF_OPTS += --enable-dtls --without-gnutls --with-openssl
else
LIBCOAP_CONF_OPTS += --disable-dtls
endif

$(eval $(autotools-package))
