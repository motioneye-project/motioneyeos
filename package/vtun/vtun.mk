################################################################################
#
# vtun
#
################################################################################

VTUN_VERSION = 3.0.4
VTUN_SITE = http://downloads.sourceforge.net/project/vtun/vtun/$(VTUN_VERSION)
VTUN_LICENSE = GPL-2.0+ with OpenSSL exception
VTUN_LICENSE_FILES = README.OpenSSL
VTUN_DEPENDENCIES = host-bison host-flex host-pkgconf zlib lzo openssl
VTUN_AUTORECONF = YES

VTUN_CONF_OPTS = \
	--with-ssl-headers=$(STAGING_DIR)/usr/include/openssl \
	--with-lzo-headers=$(STAGING_DIR)/usr/include/lzo \
	--with-lzo-lib=$(STAGING_DIR)/usr/lib

# Assumes old-style gcc inline symbol visibility rules
VTUN_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -std=gnu89"

# configure.in forgets to link to dependent libraries of openssl breaking static
# linking
VTUN_CONF_ENV += LIBS=`$(PKG_CONFIG_HOST_BINARY) --libs openssl`

$(eval $(autotools-package))
