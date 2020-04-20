################################################################################
#
# gerbera
#
################################################################################

GERBERA_VERSION = 1.4.0
GERBERA_SITE = $(call github,gerbera,gerbera,v$(GERBERA_VERSION))
GERBERA_LICENSE = GPL-2.0
GERBERA_LICENSE_FILES = LICENSE.md
GERBERA_DEPENDENCIES = \
	expat \
	host-pkgconf \
	libupnp18 \
	sqlite \
	util-linux \
	zlib
GERBERA_CONF_OPTS = \
	-DWITH_DEBUG=OFF \
	-DWITH_JS=OFF

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
GERBERA_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -latomic"
endif

ifeq ($(BR2_PACKAGE_EXIV2),y)
GERBERA_DEPENDENCIES += exiv2
GERBERA_CONF_OPTS += -DWITH_EXIV2=ON
else
GERBERA_CONF_OPTS += -DWITH_EXIV2=OFF
endif

ifeq ($(BR2_PACKAGE_FFMPEG),y)
GERBERA_DEPENDENCIES += ffmpeg
GERBERA_CONF_OPTS += -DWITH_AVCODEC=ON
else
GERBERA_CONF_OPTS += -DWITH_AVCODEC=OFF
endif

ifeq ($(BR2_PACKAGE_FILE),y)
GERBERA_DEPENDENCIES += file
GERBERA_CONF_OPTS += -DWITH_MAGIC=ON
else
GERBERA_CONF_OPTS += -DWITH_MAGIC=OFF
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
GERBERA_DEPENDENCIES += libcurl
GERBERA_CONF_OPTS += -DWITH_CURL=ON
else
GERBERA_CONF_OPTS += -DWITH_CURL=OFF
endif

ifeq ($(BR2_PACKAGE_LIBEXIF),y)
GERBERA_DEPENDENCIES += libexif
GERBERA_CONF_OPTS += -DWITH_EXIF=ON
else
GERBERA_CONF_OPTS += -DWITH_EXIF=OFF
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
GERBERA_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_LIBMATROSKA),y)
GERBERA_DEPENDENCIES += libmatroska
GERBERA_CONF_OPTS += -DWITH_MATROSKA=ON
else
GERBERA_CONF_OPTS += -DWITH_MATROSKA=OFF
endif

ifeq ($(BR2_PACKAGE_MYSQL),y)
GERBERA_DEPENDENCIES += mysql
GERBERA_CONF_OPTS += -DWITH_MYSQL=ON
else
GERBERA_CONF_OPTS += -DWITH_MYSQL=OFF
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
GERBERA_DEPENDENCIES += systemd
GERBERA_CONF_OPTS += -DWITH_SYSTEMD=ON
else
GERBERA_CONF_OPTS += -DWITH_SYSTEMD=OFF
endif

ifeq ($(BR2_PACKAGE_TAGLIB),y)
GERBERA_DEPENDENCIES += taglib
GERBERA_CONF_OPTS += -DWITH_TAGLIB=ON
else
GERBERA_CONF_OPTS += -DWITH_TAGLIB=OFF
endif

# gerbera does not provide a default configuration file, it can be
# created during run time through --create-config:
# http://docs.gerbera.io/en/latest/config-overview.html#generating-configuration
# However, to have a correct home directory and UDN, install it ourself
define GERBERA_INSTALL_CONFIGURATION
	$(INSTALL) -D -m 0644 package/gerbera/config.xml \
		$(TARGET_DIR)/etc/gerbera/config.xml
endef

GERBERA_POST_INSTALL_TARGET_HOOKS += GERBERA_INSTALL_CONFIGURATION

define GERBERA_USERS
	gerbera -1 gerbera -1 * /var/lib/gerbera - - Gerbera user
endef

define GERBERA_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/gerbera/S99gerbera \
		$(TARGET_DIR)/etc/init.d/S99gerbera
endef

$(eval $(cmake-package))
