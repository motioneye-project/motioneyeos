################################################################################
#
# libxml2
#
################################################################################

LIBXML2_VERSION = 2.9.3
LIBXML2_SITE = ftp://xmlsoft.org/libxml2
LIBXML2_INSTALL_STAGING = YES
LIBXML2_AUTORECONF = YES
LIBXML2_LICENSE = MIT
LIBXML2_LICENSE_FILES = COPYING
LIBXML2_CONFIG_SCRIPTS = xml2-config

LIBXML2_CONF_OPTS = --with-gnu-ld --without-python --without-debug

HOST_LIBXML2_DEPENDENCIES = host-pkgconf
LIBXML2_DEPENDENCIES = host-pkgconf

HOST_LIBXML2_CONF_OPTS = --without-zlib --without-lzma --without-python

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBXML2_DEPENDENCIES += zlib
LIBXML2_CONF_OPTS += --with-zlib=$(STAGING_DIR)/usr
else
LIBXML2_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_XZ),y)
LIBXML2_DEPENDENCIES += xz
LIBXML2_CONF_OPTS += --with-lzma
else
LIBXML2_CONF_OPTS += --without-lzma
endif

LIBXML2_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_ENABLE_LOCALE)$(BR2_PACKAGE_LIBICONV),y)
LIBXML2_CONF_OPTS += --with-iconv
else
LIBXML2_CONF_OPTS += --without-iconv
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# libxml2 for the host
LIBXML2_HOST_BINARY = $(HOST_DIR)/usr/bin/xmllint
