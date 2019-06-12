################################################################################
#
# libsrtp
#
################################################################################

LIBSRTP_VERSION = 2.2.0
LIBSRTP_SITE = $(call github,cisco,libsrtp,v$(LIBSRTP_VERSION))
LIBSRTP_INSTALL_STAGING = YES
LIBSRTP_LICENSE = BSD-3-Clause
LIBSRTP_LICENSE_FILES = LICENSE

ifeq ($(BR2_STATIC_LIBS),y)
LIBSRTP_MAKE_OPTS = libsrtp2.a
else ifeq ($(BR2_SHARED_LIBS),y)
LIBSRTP_MAKE_OPTS = shared_library
else
LIBSRTP_MAKE_OPTS = libsrtp2.a shared_library
endif

# While libsrtp is not using pkg-config itself, it checks if
# pkg-config is available to determine whether it should install
# libsrtp.pc. Since installing it seems useful, let's depend on
# host-pkgconf to make sure pkg-config is installed.
LIBSRTP_DEPENDENCIES = host-pkgconf

# openssl handling needs libdl support
ifeq ($(BR2_PACKAGE_OPENSSL)x$(BR2_STATIC_LIBS),yx)
LIBSRTP_DEPENDENCIES += openssl
LIBSRTP_CONF_OPTS += --enable-openssl
else
LIBSRTP_CONF_OPTS += --disable-openssl
endif

$(eval $(autotools-package))
