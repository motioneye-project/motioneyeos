################################################################################
#
# libvncserver
#
################################################################################

LIBVNCSERVER_VERSION = 0.9.9
LIBVNCSERVER_SOURCE = LibVNCServer-$(LIBVNCSERVER_VERSION).tar.gz
LIBVNCSERVER_SITE = http://downloads.sourceforge.net/project/libvncserver/libvncserver/$(LIBVNCSERVER_VERSION)
LIBVNCSERVER_LICENSE = GPLv2+
LIBVNCSERVER_LICENSE_FILES = COPYING
LIBVNCSERVER_INSTALL_STAGING = YES
LIBVNCSERVER_CONFIG_SCRIPTS = libvncserver-config

# only used for examples
LIBVNCSERVER_CONF_OPTS += --with-sdl-config=/bin/false

ifneq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
LIBVNCSERVER_CONF_OPTS += --without-pthread
endif

ifneq ($(BR2_INET_IPV6),y)
LIBVNCSERVER_CONF_OPTS += --without-ipv6
endif

# openssl supports needs pthread
ifeq ($(BR2_PACKAGE_OPENSSL)$(BR2_TOOLCHAIN_HAS_THREADS),yy)
LIBVNCSERVER_DEPENDENCIES += openssl
else
LIBVNCSERVER_CONF_OPTS += --without-crypto --without-ssl
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBVNCSERVER_CONF_ENV += LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config
LIBVNCSERVER_DEPENDENCIES += libgcrypt
else
LIBVNCSERVER_CONF_OPTS += --without-gcrypt
endif

ifeq ($(BR2_PACKAGE_GNUTLS)$(BR2_PACKAGE_LIBGCRYPT),yy)
LIBVNCSERVER_DEPENDENCIES += gnutls host-pkgconf
else
LIBVNCSERVER_CONF_OPTS += --without-gnutls
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBVNCSERVER_DEPENDENCIES += jpeg
else
LIBVNCSERVER_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBVNCSERVER_DEPENDENCIES += zlib
else
LIBVNCSERVER_CONF_OPTS += --without-zlib
endif

$(eval $(autotools-package))
