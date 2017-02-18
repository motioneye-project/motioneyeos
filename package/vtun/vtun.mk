################################################################################
#
# vtun
#
################################################################################

VTUN_VERSION = 3.0.3
VTUN_SITE = http://downloads.sourceforge.net/project/vtun/vtun/$(VTUN_VERSION)
VTUN_LICENSE = GPLv2+ with OpenSSL exception
VTUN_LICENSE_FILES = README.OpenSSL
VTUN_DEPENDENCIES = host-bison host-flex zlib lzo openssl
VTUN_AUTORECONF = YES

VTUN_CONF_OPTS = \
	--with-ssl-headers=$(STAGING_DIR)/usr/include/openssl \
	--with-lzo-headers=$(STAGING_DIR)/usr/include/lzo \
	--with-lzo-lib=$(STAGING_DIR)/usr/lib

# Assumes old-style gcc inline symbol visibility rules
VTUN_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -std=gnu89"

$(eval $(autotools-package))
