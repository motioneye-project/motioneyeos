################################################################################
#
# bitcoin
#
################################################################################

BITCOIN_VERSION = v0.16.3
BITCOIN_SITE = $(call github,bitcoin,bitcoin,$(BITCOIN_VERSION))
BITCOIN_AUTORECONF = YES
BITCOIN_LICENSE = MIT
BITCOIN_LICENSE_FILES = COPYING
BITCOIN_DEPENDENCIES = boost openssl libevent
BITCOIN_CONF_OPTS = \
	--disable-wallet \
	--disable-tests \
	--with-boost-libdir=$(STAGING_DIR)/usr/lib/ \
	--disable-hardening

$(eval $(autotools-package))
