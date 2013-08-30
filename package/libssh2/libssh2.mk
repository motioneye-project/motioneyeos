################################################################################
#
# libssh2
#
################################################################################

LIBSSH2_VERSION = 1.4.3
LIBSSH2_SITE = http://www.libssh2.org/download/
LIBSSH2_LICENSE = BSD
LIBSSH2_LICENSE_FILES = COPYING
LIBSSH2_INSTALL_STAGING = YES
LIBSSH2_CONF_OPT = --disable-examples-build

# libssh2 must use either libgcrypt or OpenSSL
# Only select openssl if libgcrypt is not selected
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBSSH2_DEPENDENCIES += libgcrypt
LIBSSH2_CONF_OPT += --with-libgcrypt --without-openssl
else
LIBSSH2_DEPENDENCIES += openssl
LIBSSH2_CONF_OPT += --with-openssl --without-libgcrypt
endif

# Add zlib support if enabled
ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBSSH2_DEPENDENCIES += zlib
LIBSSH2_CONF_OPT += --with-libz
else
LIBSSH2_CONF_OPT += --without-libz
endif

$(eval $(autotools-package))
