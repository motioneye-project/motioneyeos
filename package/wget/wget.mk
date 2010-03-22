#############################################################
#
# wget
#
#############################################################

WGET_VERSION = 1.12
WGET_SITE = $(BR2_GNU_MIRROR)/wget

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	WGET_CONF_OPT += --with-ssl --with-libssl-prefix=$(STAGING_DIR)
	WGET_DEPENDENCIES += openssl
endif

$(eval $(call AUTOTARGETS,package,wget))
