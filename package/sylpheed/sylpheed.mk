#############################################################
#
# sylpheed
#
#############################################################
SYLPHEED_VERSION_MAJOR = 3.1
SYLPHEED_VERSION_MINOR = 0
SYLPHEED_VERSION = $(SYLPHEED_VERSION_MAJOR).$(SYLPHEED_VERSION_MINOR)
SYLPHEED_SOURCE = sylpheed-$(SYLPHEED_VERSION).tar.bz2
SYLPHEED_SITE = http://sylpheed.sraoss.jp/sylpheed/v$(SYLPHEED_VERSION_MAJOR)

SYLPHEED_CONF_OPT = --disable-gtkspell \
                    --includedir=$(STAGING_DIR)/usr/include

SYLPHEED_DEPENDENCIES = host-pkg-config libgtk2

ifeq ($(BR2_PACKAGE_OPENSSL),y)
SYLPHEED_DEPENDENCIES += openssl
SYLPHEED_CONF_OPT += --enable-ssl
else
SYLPHEED_CONF_OPT += --disable-ssl
endif

$(eval $(autotools-package))
