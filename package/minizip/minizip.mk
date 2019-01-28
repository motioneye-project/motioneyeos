################################################################################
#
# minizip
#
################################################################################

MINIZIP_VERSION = 2.8.2
MINIZIP_SITE = $(call github,nmoinvaz,minizip,$(MINIZIP_VERSION))
MINIZIP_DEPENDENCIES = \
	host-pkgconf \
	$(if $(BR2_PACKAGE_LIBBSD),libbsd) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)
MINIZIP_INSTALL_STAGING = YES
MINIZIP_CONF_OPTS = \
	$(if $(BR2_PACKAGE_MINIZIP_DEMOS),-DBUILD_TEST=ON) \
	-DUSE_COMPAT=OFF
MINIZIP_LICENSE = Zlib
MINIZIP_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_BZIP2),y)
MINIZIP_DEPENDENCIES += bzip2
MINIZIP_CONF_OPTS += -DUSE_BZIP2=ON
else
MINIZIP_CONF_OPTS += -DUSE_BZIP2=OFF
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MINIZIP_DEPENDENCIES += openssl
MINIZIP_CONF_OPTS += -DUSE_OPENSSL=ON
else
MINIZIP_CONF_OPTS += -DUSE_OPENSSL=OFF
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
MINIZIP_DEPENDENCIES += zlib
MINIZIP_CONF_OPTS += -DUSE_ZLIB=ON
else
MINIZIP_CONF_OPTS += -DUSE_ZLIB=OFF
endif

$(eval $(cmake-package))
