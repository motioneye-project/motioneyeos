################################################################################
#
# unixodbc
#
################################################################################

UNIXODBC_VERSION = 2.3.7
UNIXODBC_SOURCE = unixODBC-$(UNIXODBC_VERSION).tar.gz
UNIXODBC_SITE = ftp://ftp.unixodbc.org/pub/unixODBC
UNIXODBC_INSTALL_STAGING = YES
UNIXODBC_LICENSE = LGPL-2.1+ (library), GPL-2.0+ (programs)
UNIXODBC_LICENSE_FILES = COPYING exe/COPYING

UNIXODBC_CONF_OPTS = --enable-drivers --enable-driver-conf

ifeq ($(BR2_PACKAGE_LIBICONV),y)
UNIXODBC_CONF_OPTS += --enable-iconv
UNIXODBC_DEPENDENCIES += libiconv
else
UNIXODBC_CONF_OPTS += --disable-iconv
endif

ifeq ($(BR2_PACKAGE_LIBTOOL),y)
UNIXODBC_CONF_OPTS += --without-included-ltdl
UNIXODBC_DEPENDENCIES += libtool
else
UNIXODBC_CONF_OPTS += --with-included-ltdl
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
UNIXODBC_CONF_OPTS += --enable-readline
UNIXODBC_DEPENDENCIES += readline
else
UNIXODBC_CONF_OPTS += --disable-readline
endif

$(eval $(autotools-package))
