################################################################################
#
# sconeserver
#
################################################################################

# Release 0.6.0 doesn't build cleanly, so use a recent
# Git commit.
SCONESERVER_VERSION = d58f2de88c681939554089f786e360042a30c8f8
SCONESERVER_SITE = git://github.com/sconemad/sconeserver.git
SCONESERVER_LICENSE = GPLv2+
SCONESERVER_LICENSE_FILES = COPYING

SCONESERVER_AUTORECONF = YES
SCONESERVER_DEPENDENCIES += pcre
SCONESERVER_CONF_OPT += --with-ip --with-local

# Sconeserver configure script fails to find the libxml2 headers.
ifeq ($(BR2_PACKAGE_LIBXML2),y)
	SCONESERVER_CONF_OPT += \
		--with-xml2-config="$(STAGING_DIR)/usr/bin/xml2-config"
endif

ifeq ($(BR2_INET_IPV6),y)
	SCONESERVER_CONF_OPT += --with-ip6
else
	SCONESERVER_CONF_OPT += --without-ip6
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	SCONESERVER_DEPENDENCIES += openssl
	SCONESERVER_CONF_OPT += --with-ssl
else
	SCONESERVER_CONF_OPT += --without-ssl
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_EXAMPLES),y)
	SCONESERVER_CONF_OPT += --with-examples
else
	SCONESERVER_CONF_OPT += --without-examples
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_HTTP_SCONESITE),y)
	SCONESERVER_DEPENDENCIES += libxml2
	SCONESERVER_CONF_OPT += --with-sconesite
else
	SCONESERVER_CONF_OPT += --without-sconesite
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_HTTP_SCONESITE_IMAGE),y)
	SCONESERVER_DEPENDENCIES += imagemagick host-pkgconf
	SCONESERVER_CONF_OPT += \
		--with-sconesite-image \
		--with-Magick++-config="$(STAGING_DIR)/usr/bin/Magick++-config"
else
	SCONESERVER_CONF_OPT += --without-sconesite-image
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_MYSQL),y)
	SCONESERVER_DEPENDENCIES += mysql_client
	SCONESERVER_CONF_OPT += --with-mysql \
		--with-mysql_config="$(STAGING_DIR)/usr/bin/mysql_config" \
		LDFLAGS="$(TARGET_LDFLAGS) -L$(STAGING_DIR)/usr/lib/mysql"
else
	SCONESERVER_CONF_OPT += --without-mysql
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_BLUETOOTH),y)
	SCONESERVER_DEPENDENCIES += bluez_utils
	SCONESERVER_CONF_OPT += --with-bluetooth
else
	SCONESERVER_CONF_OPT += --without-bluetooth
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_RSS),y)
	SCONESERVER_DEPENDENCIES += libxml2
	SCONESERVER_CONF_OPT += --with-rss
else
	SCONESERVER_CONF_OPT += --without-rss
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_LOCATION),y)
	SCONESERVER_DEPENDENCIES += gpsd
	SCONESERVER_CONF_OPT += --with-location
else
	SCONESERVER_CONF_OPT += --without-location
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_LETTUCE),y)
	SCONESERVER_CONF_OPT += --with-lettuce
else
	SCONESERVER_CONF_OPT += --without-lettuce
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_MATHS),y)
	SCONESERVER_DEPENDENCIES += mpfr
	SCONESERVER_CONF_OPT += --with-maths
else
	SCONESERVER_CONF_OPT += --without-maths
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_TESTBUILDER),y)
	SCONESERVER_CONF_OPT += --with-testbuilder
else
	SCONESERVER_CONF_OPT += --without-testbuilder
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_UI),y)
	SCONESERVER_DEPENDENCIES += xlib_libX11
	SCONESERVER_CONF_OPT += --with-ui
else
	SCONESERVER_CONF_OPT += --without-ui
endif

$(eval $(autotools-package))
