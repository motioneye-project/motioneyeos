#############################################################
#
# sconeserver
#
#############################################################
# Release 0.6.0 doesn't build cleanly, so use a recent
# Subversion trunk snapshot.
SCONESERVER_VERSION = 180
SCONESERVER_SITE = \
	https://sconeserver.svn.sourceforge.net/svnroot/sconeserver/trunk
SCONESERVER_SITE_METHOD = svn

SCONESERVER_LICENSE = GPLv2+
SCONESERVER_LICENSE_FILES = COPYING

SCONESERVER_DEPENDENCIES += pcre
SCONESERVER_CONF_OPT += --with-ip --with-local

SCONESERVER_CONF_OPT += CXXFLAGS="$(TARGET_CXXFLAGS) $(SCONESERVER_CXXFLAGS)"
SCONESERVER_CONF_OPT += LDFLAGS="$(TARGET_LDFLAGS) $(SCONESERVER_LDFLAGS)"

# Sconeserver configure script fails to find the libxml2 headers.
ifeq ($(BR2_PACKAGE_LIBXML2),y)
	SCONESERVER_CXXFLAGS += -I$(STAGING_DIR)/usr/include/libxml2
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
	SCONESERVER_DEPENDENCIES += imagemagick
	SCONESERVER_CONF_OPT += --with-sconesite-image
else
	SCONESERVER_CONF_OPT += --without-sconesite-image
endif

ifeq ($(BR2_PACKAGE_SCONESERVER_MYSQL),y)
	SCONESERVER_DEPENDENCIES += mysql_client
	SCONESERVER_CONF_OPT += --with-mysql
	SCONESERVER_CXXFLAGS += -I$(STAGING_DIR)/usr/include/mysql
	SCONESERVER_LDFLAGS += -L$(STAGING_DIR)/usr/lib/mysql
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
