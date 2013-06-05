################################################################################
#
# linknx
#
################################################################################

LINKNX_VERSION = 0.0.1.30
LINKNX_SITE = http://downloads.sourceforge.net/project/linknx/linknx/linknx-$(LINKNX_VERSION)
LINKNX_LICENSE = GPLv2+
LINKNX_INSTALL_STAGING = YES
LINKNX_CONF_OPT = --without-lua --without-log4cpp --without-pth-test \
		  --with-pth=$(STAGING_DIR)/usr --disable-smtp

LINKNX_DEPENDENCIES = libpthsem

ifeq ($(BR2_PACKAGE_MYSQL_CLIENT),y)
LINKNX_CONF_OPT += --with-mysql=$(STAGING_DIR)/usr/bin/mysql_config
LINKNX_DEPENDENCIES += mysql_client
else
LINKNX_CONF_OPT += --without-mysql
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
LINKNX_CONF_OPT += --with-libcurl=$(STAGING_DIR)/usr/bin/curl-config
LINKNX_DEPENDENCIES += libcurl
else
LINKNX_CONF_OPT += --without-libcurl
endif

$(eval $(autotools-package))
