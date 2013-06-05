################################################################################
#
# vtun
#
################################################################################

VTUN_VERSION = 3.0.3
VTUN_SOURCE = vtun-$(VTUN_VERSION).tar.gz
VTUN_SITE = http://downloads.sourceforge.net/project/vtun/vtun/$(VTUN_VERSION)
VTUN_DEPENDENCIES = host-bison host-flex zlib lzo openssl
VTUN_AUTORECONF = YES

VTUN_CONF_OPT = \
		--with-ssl-headers=$(STAGING_DIR)/usr/include/openssl \
		--with-lzo-headers=$(STAGING_DIR)/usr/include/lzo \
		--with-lzo-lib=$(STAGING_DIR)/usr/lib

$(eval $(autotools-package))
