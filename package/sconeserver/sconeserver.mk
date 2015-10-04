################################################################################
#
# sconeserver
#
################################################################################

# Release 0.6.0 doesn't build cleanly, so use a recent
# Git commit.
SCONESERVER_VERSION = 3b886c3dda6eda39bcb27472d29ed7fd3185ba1d
SCONESERVER_SITE = $(call github,sconemad,sconeserver,$(SCONESERVER_VERSION))
SCONESERVER_LICENSE = GPLv2+
SCONESERVER_LICENSE_FILES = COPYING

SCONESERVER_AUTORECONF = YES
SCONESERVER_DEPENDENCIES += pcre
SCONESERVER_CONF_OPTS += --with-ip --with-local --with-ip6

# Sconeserver configure script fails to find the libxml2 headers.
ifeq ($(BR2_PACKAGE_LIBXML2),y)
SCONESERVER_CONF_OPTS += \
	--with-xml2-config="$(STAGING_DIR)/usr/bin/xml2-config"
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
SCONESERVER_DEPENDENCIES += openssl
SCONESERVER_CONF_OPTS += --with-ssl
ifeq ($(BR2_STATIC_LIBS),y)
SCONESERVER_CONF_ENV += SSL_LIBADD=-lz
endif
else
SCONESERVER_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_EXAMPLES),y)
SCONESERVER_CONF_OPTS += --with-examples
else
SCONESERVER_CONF_OPTS += --without-examples
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_HTTP_SCONESITE),y)
SCONESERVER_DEPENDENCIES += libxml2
SCONESERVER_CONF_OPTS += --with-sconesite
else
SCONESERVER_CONF_OPTS += --without-sconesite
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_HTTP_SCONESITE_IMAGE),y)
SCONESERVER_DEPENDENCIES += imagemagick host-pkgconf
SCONESERVER_CONF_OPTS += \
	--with-sconesite-image \
	--with-Magick++-config="$(STAGING_DIR)/usr/bin/Magick++-config"
else
SCONESERVER_CONF_OPTS += --without-sconesite-image
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_MYSQL),y)
SCONESERVER_DEPENDENCIES += mysql
SCONESERVER_CONF_OPTS += \
	--with-mysql \
	--with-mysql_config="$(STAGING_DIR)/usr/bin/mysql_config" \
	LDFLAGS="$(TARGET_LDFLAGS) -L$(STAGING_DIR)/usr/lib/mysql"
else
SCONESERVER_CONF_OPTS += --without-mysql
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_BLUETOOTH),y)
SCONESERVER_DEPENDENCIES += bluez_utils
SCONESERVER_CONF_OPTS += --with-bluetooth
else
SCONESERVER_CONF_OPTS += --without-bluetooth
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_RSS),y)
SCONESERVER_DEPENDENCIES += libxml2
SCONESERVER_CONF_OPTS += --with-rss
else
SCONESERVER_CONF_OPTS += --without-rss
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_LOCATION),y)
SCONESERVER_DEPENDENCIES += gpsd
SCONESERVER_CONF_OPTS += --with-location
else
SCONESERVER_CONF_OPTS += --without-location
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_LETTUCE),y)
SCONESERVER_CONF_OPTS += --with-lettuce
else
SCONESERVER_CONF_OPTS += --without-lettuce
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_MATHS),y)
SCONESERVER_DEPENDENCIES += mpfr
SCONESERVER_CONF_OPTS += --with-maths
else
SCONESERVER_CONF_OPTS += --without-maths
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_TESTBUILDER),y)
SCONESERVER_CONF_OPTS += --with-testbuilder
else
SCONESERVER_CONF_OPTS += --without-testbuilder
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_UI),y)
SCONESERVER_DEPENDENCIES += xlib_libX11
SCONESERVER_CONF_OPTS += --with-ui
else
SCONESERVER_CONF_OPTS += --without-ui
endif

$(eval $(autotools-package))
