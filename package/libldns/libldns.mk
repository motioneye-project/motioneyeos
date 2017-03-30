################################################################################
#
# libldns
#
################################################################################

LIBLDNS_VERSION = 1.6.17
LIBLDNS_SOURCE = ldns-$(LIBLDNS_VERSION).tar.gz
LIBLDNS_SITE = http://www.nlnetlabs.nl/downloads/ldns
LIBLDNS_LICENSE = BSD-3-Clause
LIBLDNS_LICENSE_FILES = LICENSE
LIBLDNS_INSTALL_STAGING = YES
LIBLDNS_CONF_OPTS = \
	--without-examples \
	--without-p5-dns-ldns \
	--without-pyldns \
	--without-pyldnsx

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBLDNS_DEPENDENCIES += openssl
LIBLDNS_CONF_OPTS += \
	--with-ssl=$(STAGING_DIR)/usr \
	--enable-dane \
	--enable-ecdsa \
	--enable-gost \
	--enable-sha2

ifeq ($(BR2_STATIC_LIBS),y)
LIBLDNS_DEPENDENCIES += host-pkgconf
# missing -lz breaks configure, add it using pkgconf
LIBLDNS_CONF_ENV += LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs openssl`"
endif

else
LIBLDNS_CONF_OPTS += \
	--without-ssl \
	--disable-dane \
	--disable-ecdsa \
	--disable-gost \
	--disable-sha2
endif

# the linktest make target fails with static linking, and we are only
# interested in the lib target anyway
LIBLDNS_MAKE_OPTS = lib

$(eval $(autotools-package))
