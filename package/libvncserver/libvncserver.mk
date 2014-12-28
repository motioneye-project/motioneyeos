################################################################################
#
# libvncserver
#
################################################################################

LIBVNCSERVER_VERSION = 0.9.10
LIBVNCSERVER_SOURCE = LibVNCServer-$(LIBVNCSERVER_VERSION).tar.gz
LIBVNCSERVER_SITE = https://github.com/LibVNC/libvncserver/archive
LIBVNCSERVER_LICENSE = GPLv2+
LIBVNCSERVER_LICENSE_FILES = COPYING
LIBVNCSERVER_INSTALL_STAGING = YES
LIBVNCSERVER_CONFIG_SCRIPTS = libvncserver-config
LIBVNCSERVER_DEPENDENCIES = host-pkgconf

# Upstream decided to remove generated autotools files from the
# tarball, so we need to generate them.
LIBVNCSERVER_AUTORECONF = YES

# libvncserver does not get along with newer libva versions
# https://github.com/LibVNC/libvncserver/issues/11
LIBVNCSERVER_CONF_OPTS += --without-libva

# only used for examples
LIBVNCSERVER_CONF_OPTS += --with-sdl-config=/bin/false

ifneq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
LIBVNCSERVER_CONF_OPTS += --without-pthread
endif

ifneq ($(BR2_INET_IPV6),y)
LIBVNCSERVER_CONF_OPTS += --without-ipv6
endif

# openssl supports needs NPTL thread support
ifeq ($(BR2_PACKAGE_OPENSSL)$(BR2_TOOLCHAIN_HAS_THREADS_NPTL),yy)
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

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LIBVNCSERVER_DEPENDENCIES += libpng
else
LIBVNCSERVER_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBVNCSERVER_DEPENDENCIES += zlib
else
LIBVNCSERVER_CONF_OPTS += --without-zlib
endif

$(eval $(autotools-package))
