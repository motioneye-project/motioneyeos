################################################################################
#
# libldns
#
################################################################################

LIBLDNS_VERSION = 1.7.0
LIBLDNS_SOURCE = ldns-$(LIBLDNS_VERSION).tar.gz
LIBLDNS_SITE = http://www.nlnetlabs.nl/downloads/ldns
LIBLDNS_LICENSE = BSD-3-Clause
LIBLDNS_LICENSE_FILES = LICENSE
LIBLDNS_INSTALL_STAGING = YES
LIBLDNS_DEPENDENCIES = openssl
# --disable-dane-verify can be removed after openssl bump to 1.1.x
LIBLDNS_CONF_OPTS = \
	--with-ssl=$(STAGING_DIR)/usr \
	--enable-dane \
	--disable-dane-verify \
	--enable-ecdsa \
	--enable-gost \
	--enable-sha2 \
	--without-examples \
	--without-p5-dns-ldns \
	--without-pyldns \
	--without-pyldnsx

ifeq ($(BR2_STATIC_LIBS),y)
LIBLDNS_DEPENDENCIES += host-pkgconf
# missing -lz breaks configure, add it using pkgconf
LIBLDNS_CONF_ENV += LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs openssl`"
endif

# the linktest make target fails with static linking, and we are only
# interested in the lib target anyway
LIBLDNS_MAKE_OPTS = lib

$(eval $(autotools-package))
