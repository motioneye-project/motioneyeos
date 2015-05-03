################################################################################
#
# linknx
#
################################################################################

LINKNX_VERSION = 0.0.1.32
LINKNX_SITE = http://downloads.sourceforge.net/project/linknx/linknx/linknx-$(LINKNX_VERSION)
LINKNX_LICENSE = GPLv2+
LINKNX_INSTALL_STAGING = YES
LINKNX_CONF_OPTS = \
	--without-lua \
	--without-log4cpp \
	--without-pth-test \
	--with-pth=$(STAGING_DIR)/usr \
	--disable-smtp

LINKNX_DEPENDENCIES = libpthsem $(if $(BR2_PACKAGE_ARGP_STANDALONE),argp-standalone)

ifeq ($(BR2_PACKAGE_MYSQL),y)
LINKNX_CONF_OPTS += --with-mysql=$(STAGING_DIR)/usr/bin/mysql_config
LINKNX_DEPENDENCIES += mysql
else
LINKNX_CONF_OPTS += --without-mysql
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
LINKNX_CONF_OPTS += --with-libcurl=$(STAGING_DIR)/usr/bin/curl-config
LINKNX_DEPENDENCIES += libcurl
else
LINKNX_CONF_OPTS += --without-libcurl
endif

$(eval $(autotools-package))
