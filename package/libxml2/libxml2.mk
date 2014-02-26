################################################################################
#
# libxml2
#
################################################################################

LIBXML2_VERSION = 2.9.1
LIBXML2_SITE = ftp://xmlsoft.org/libxml2
LIBXML2_INSTALL_STAGING = YES
LIBXML2_AUTORECONF = YES
LIBXML2_LICENSE = MIT
LIBXML2_LICENSE_FILES = COPYING
LIBXML2_CONFIG_SCRIPTS = xml2-config

ifneq ($(BR2_LARGEFILE),y)
LIBXML2_CONF_ENV = CC="$(TARGET_CC) $(TARGET_CFLAGS) -DNO_LARGEFILE_SOURCE"
endif

LIBXML2_CONF_OPT = --with-gnu-ld --without-python --without-debug --without-lzma

HOST_LIBXML2_DEPENDENCIES = host-pkgconf

HOST_LIBXML2_CONF_OPT = --without-zlib --without-lzma

# mesa3d uses functions that are only available with debug
ifeq ($(BR2_PACKAGE_MESA3D),y)
HOST_LIBXML2_CONF_OPT += --with-debug
else
HOST_LIBXML2_CONF_OPT += --without-debug
endif

ifeq ($(BR2_PACKAGE_HOST_LIBXML2_PYTHON),y)
HOST_LIBXML2_DEPENDENCIES += host-python
HOST_LIBXML2_CONF_OPT += --with-python=$(HOST_DIR)/usr
else
HOST_LIBXML2_CONF_OPT += --without-python
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBXML2_DEPENDENCIES += zlib
LIBXML2_CONF_OPT += --with-zlib
else
LIBXML2_CONF_OPT += --without-zlib
endif

LIBXML2_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_ENABLE_LOCALE)$(BR2_PACKAGE_LIBICONV),y)
LIBXML2_CONF_OPT += --with-iconv
else
LIBXML2_CONF_OPT += --without-iconv
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# libxml2 for the host
LIBXML2_HOST_BINARY = $(HOST_DIR)/usr/bin/xmllint
