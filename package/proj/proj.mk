################################################################################
#
# proj
#
################################################################################

PROJ_VERSION = 7.0.1
PROJ_SITE = http://download.osgeo.org/proj
PROJ_LICENSE = MIT
PROJ_LICENSE_FILES = COPYING
PROJ_INSTALL_STAGING = YES
PROJ_DEPENDENCIES = host-pkgconf host-sqlite sqlite

PROJ_CFLAGS = $(TARGET_CFLAGS)
PROJ_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
PROJ_CFLAGS += -O0
PROJ_CXXFLAGS += -O0
endif

PROJ_CONF_ENV = \
	CFLAGS="$(PROJ_CFLAGS)" \
	CXXFLAGS="$(PROJ_CXXFLAGS)"

ifeq ($(BR2_PACKAGE_LIBCURL),y)
PROJ_DEPENDENCIES += libcurl
PROJ_CONF_OPTS += --with-curl=$(STAGING_DIR)/usr/bin/curl-config
else
PROJ_CONF_OPTS += --without-curl
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
PROJ_DEPENDENCIES += tiff
PROJ_CONF_OPTS += --enable-tiff
else
PROJ_CONF_OPTS += --disable-tiff
endif

$(eval $(autotools-package))
