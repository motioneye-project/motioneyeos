#############################################################
#
# libxml2
#
#############################################################

LIBXML2_VERSION = 2.9.0
LIBXML2_SITE = ftp://xmlsoft.org/libxml2
LIBXML2_INSTALL_STAGING = YES
LIBXML2_AUTORECONF = YES
LIBXML2_LICENSE = MIT
LIBXML2_LICENSE_FILES = COPYING
LIBXML2_CONFIG_SCRIPTS = xml2-config

ifneq ($(BR2_LARGEFILE),y)
LIBXML2_CONF_ENV = CC="$(TARGET_CC) $(TARGET_CFLAGS) -DNO_LARGEFILE_SOURCE"
endif

LIBXML2_CONF_OPT = --with-gnu-ld --without-python --without-debug

HOST_LIBXML2_DEPENDENCIES = host-pkgconf

# mesa3d uses functions that are only available with debug
ifeq ($(BR2_PACKAGE_MESA3D),y)
HOST_LIBXML2_CONF_OPT = --with-debug
else
HOST_LIBXML2_CONF_OPT = --without-debug
endif

ifeq ($(BR2_PACKAGE_HOST_LIBXML2_PYTHON),y)
HOST_LIBXML2_DEPENDENCIES += host-python
HOST_LIBXML2_CONF_OPT += --with-python=$(HOST_DIR)/usr
else
HOST_LIBXML2_CONF_OPT += --without-python
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# libxml2 for the host
LIBXML2_HOST_BINARY = $(HOST_DIR)/usr/bin/xmllint
