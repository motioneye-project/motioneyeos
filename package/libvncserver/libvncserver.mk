#############################################################
#
# libvncserver
#
#############################################################

LIBVNCSERVER_VERSION = 0.9.8.2
LIBVNCSERVER_SOURCE = LibVNCServer-$(LIBVNCSERVER_VERSION).tar.gz
LIBVNCSERVER_SITE = http://downloads.sourceforge.net/project/libvncserver/libvncserver/$(LIBVNCSERVER_VERSION)

LIBVNCSERVER_INSTALL_STAGING = YES

# only used for examples
LIBVNCSERVER_CONF_OPT += --with-sdl-config=/bin/false

ifneq ($(BR2_INET_IPV6),y)
LIBVNCSERVER_CONF_OPT += --without-ipv6
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBVNCSERVER_DEPENDENCIES += openssl
else
LIBVNCSERVER_CONF_OPT += --without-crypto
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBVNCSERVER_CONF_ENV += LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config
LIBVNCSERVER_DEPENDENCIES += libgcrypt
else
LIBVNCSERVER_CONF_OPT += --without-gcrypt
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
LIBVNCSERVER_DEPENDENCIES += gnutls host-pkg-config
else
LIBVNCSERVER_CONF_OPT += --without-gnutls
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBVNCSERVER_DEPENDENCIES += jpeg
else
LIBVNCSERVER_CONF_OPT += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBVNCSERVER_DEPENDENCIES += zlib
else
LIBVNCSERVER_CONF_OPT += --without-zlib
endif

$(eval $(autotools-package))
