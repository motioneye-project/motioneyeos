################################################################################
#
# linknx
#
################################################################################

LINKNX_VERSION = 0.0.1.37
LINKNX_SITE = $(call github,linknx,linknx,$(LINKNX_VERSION))
LINKNX_LICENSE = GPL-2.0+
LINKNX_LICENSE_FILES = LICENSE
LINKNX_INSTALL_STAGING = YES
# We're patching configure.ac
LINKNX_AUTORECONF = YES
LINKNX_CONF_OPTS = \
	--without-cppunit \
	--without-pth-test \
	--with-pth=$(STAGING_DIR)/usr \
	--disable-smtp

LINKNX_DEPENDENCIES = \
	host-pkgconf \
	libpthsem \
	$(if $(BR2_PACKAGE_ARGP_STANDALONE),argp-standalone) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_LIBCURL),y)
LINKNX_CONF_OPTS += --with-libcurl=$(STAGING_DIR)/usr
LINKNX_DEPENDENCIES += libcurl
else
LINKNX_CONF_OPTS += --without-libcurl
endif

ifeq ($(BR2_PACKAGE_LOG4CPP),y)
LINKNX_CONF_OPTS += --with-log4cpp
LINKNX_DEPENDENCIES += log4cpp
else
LINKNX_CONF_OPTS += --without-log4cpp
endif

ifeq ($(BR2_PACKAGE_LUA),y)
LINKNX_CONF_OPTS += --with-lua
LINKNX_DEPENDENCIES += lua
else
LINKNX_CONF_OPTS += --without-lua
endif

ifeq ($(BR2_PACKAGE_MYSQL),y)
LINKNX_CONF_OPTS += --with-mysql=$(STAGING_DIR)/usr
LINKNX_DEPENDENCIES += mysql
else
LINKNX_CONF_OPTS += --without-mysql
endif

$(eval $(autotools-package))
