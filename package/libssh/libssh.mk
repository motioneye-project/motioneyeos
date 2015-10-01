################################################################################
#
# libssh
#
################################################################################

LIBSSH_VERSION = 0.7.2
LIBSSH_SOURCE = libssh-$(LIBSSH_VERSION).tar.xz
LIBSSH_SITE = https://red.libssh.org/attachments/download/177
LIBSSH_LICENSE = LGPLv2.1
LIBSSH_LICENSE_FILES = COPYING
LIBSSH_INSTALL_STAGING = YES
LIBSSH_SUPPORTS_IN_SOURCE_BUILD = NO
LIBSSH_CONF_OPTS = \
	-DWITH_STACK_PROTECTOR=OFF \
	-DWITH_SERVER=OFF \
	-DWITH_EXAMPLES=OFF

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBSSH_CONF_OPTS += -DWITH_ZLIB=ON
LIBSSH_DEPENDENCIES += zlib
else
LIBSSH_CONF_OPTS += -DWITH_ZLIB=OFF
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBSSH_CONF_OPTS += -DWITH_GCRYPT=ON
LIBSSH_DEPENDENCIES += libgcrypt
else
LIBSSH_CONF_OPTS += -DWITH_GCRYPT=OFF
ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBSSH_DEPENDENCIES += openssl
endif
endif

$(eval $(cmake-package))
