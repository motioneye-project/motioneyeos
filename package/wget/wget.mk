################################################################################
#
# wget
#
################################################################################

WGET_VERSION = 1.19.1
WGET_SOURCE = wget-$(WGET_VERSION).tar.xz
WGET_SITE = $(BR2_GNU_MIRROR)/wget
WGET_DEPENDENCIES = host-pkgconf
WGET_LICENSE = GPL-3.0+
WGET_LICENSE_FILES = COPYING

# Prefer full-blown wget over busybox
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
WGET_DEPENDENCIES += busybox
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
WGET_CONF_OPTS += --with-ssl=gnutls
WGET_DEPENDENCIES += gnutls
else ifeq ($(BR2_PACKAGE_OPENSSL),y)
WGET_CONF_OPTS += --with-ssl=openssl
WGET_DEPENDENCIES += openssl
else
WGET_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
WGET_DEPENDENCIES += util-linux
endif

$(eval $(autotools-package))
