################################################################################
#
# libssh
#
################################################################################

LIBSSH_VERSION_MAJOR = 0.9
LIBSSH_VERSION = $(LIBSSH_VERSION_MAJOR).4
LIBSSH_SOURCE = libssh-$(LIBSSH_VERSION).tar.xz
LIBSSH_SITE = https://www.libssh.org/files/$(LIBSSH_VERSION_MAJOR)
LIBSSH_LICENSE = LGPL-2.1
LIBSSH_LICENSE_FILES = COPYING
LIBSSH_INSTALL_STAGING = YES
LIBSSH_SUPPORTS_IN_SOURCE_BUILD = NO
LIBSSH_CONF_OPTS = \
	-DWITH_STACK_PROTECTOR=OFF \
	-DWITH_EXAMPLES=OFF

# cmake older than 3.10 require this to avoid try_run() in FindThreads
LIBSSH_CONF_OPTS += -DTHREADS_PTHREAD_ARG=OFF

ifeq ($(BR2_PACKAGE_LIBSSH_SERVER),y)
LIBSSH_CONF_OPTS += -DWITH_SERVER=ON
else
LIBSSH_CONF_OPTS += -DWITH_SERVER=OFF
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBSSH_CONF_OPTS += -DWITH_ZLIB=ON
LIBSSH_DEPENDENCIES += zlib
else
LIBSSH_CONF_OPTS += -DWITH_ZLIB=OFF
endif

ifeq ($(BR2_PACKAGE_LIBSSH_MBEDTLS),y)
LIBSSH_CONF_OPTS += -DWITH_MBEDTLS=ON
LIBSSH_DEPENDENCIES += mbedtls
else ifeq ($(BR2_PACKAGE_LIBSSH_LIBGCRYPT),y)
LIBSSH_CONF_OPTS += -DWITH_GCRYPT=ON
LIBSSH_DEPENDENCIES += libgcrypt
else ifeq ($(BR2_PACKAGE_LIBSSH_OPENSSL),y)
LIBSSH_DEPENDENCIES += openssl
endif

$(eval $(cmake-package))
