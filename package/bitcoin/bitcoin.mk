################################################################################
#
# bitcoin
#
################################################################################

BITCOIN_VERSION = 0.19.0.1
BITCOIN_SITE = https://bitcoincore.org/bin/bitcoin-core-$(BITCOIN_VERSION)
BITCOIN_AUTORECONF = YES
BITCOIN_LICENSE = MIT
BITCOIN_LICENSE_FILES = COPYING
BITCOIN_DEPENDENCIES = host-pkgconf boost openssl libevent
BITCOIN_CONF_OPTS = \
	--disable-bench \
	--disable-wallet \
	--disable-tests \
	--with-boost-libdir=$(STAGING_DIR)/usr/lib/ \
	--disable-hardening \
	--without-gui

ifeq ($(BR2_PACKAGE_LIBMINIUPNPC),y)
BITCOIN_DEPENDENCIES += libminiupnpc
BITCOIN_CONF_OPTS += --with-miniupnpc
else
BITCOIN_CONF_OPTS += --without-miniupnpc
endif

ifeq ($(BR2_PACKAGE_ZEROMQ),y)
BITCOIN_DEPENDENCIES += zeromq
BITCOIN_CONF_OPTS += --with-zmq
else
BITCOIN_CONF_OPTS += --without-zmq
endif

$(eval $(autotools-package))
