################################################################################
#
# linknx
#
################################################################################

LINKNX_VERSION = 0.0.1.33
LINKNX_SITE = $(call github,linknx,linknx,$(LINKNX_VERSION))
LINKNX_LICENSE = GPL-2.0+
LINKNX_INSTALL_STAGING = YES
LINKNX_CONF_OPTS = \
	--without-lua \
	--without-log4cpp \
	--without-pth-test \
	--with-pth=$(STAGING_DIR)/usr \
	--disable-smtp

LINKNX_DEPENDENCIES = libpthsem \
	$(if $(BR2_PACKAGE_ARGP_STANDALONE),argp-standalone)

ifeq ($(BR2_PACKAGE_MYSQL),y)
LINKNX_CONF_OPTS += --with-mysql=$(STAGING_DIR)/usr
LINKNX_DEPENDENCIES += mysql
else
LINKNX_CONF_OPTS += --without-mysql
endif

$(eval $(autotools-package))
