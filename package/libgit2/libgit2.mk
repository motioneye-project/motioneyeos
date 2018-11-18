################################################################################
#
# libgit2
#
################################################################################

LIBGIT2_VERSION = v0.27.4
LIBGIT2_SITE = $(call github,libgit2,libgit2,$(LIBGIT2_VERSION))
LIBGIT2_LICENSE = GPL-2.0 with linking exception
LIBGIT2_LICENSE_FILES = COPYING
LIBGIT2_INSTALL_STAGING = YES

LIBGIT2_CONF_OPTS = \
	-DUSE_GSSAPI=OFF \
	-DBUILD_CLAR=OFF \
	-DUSE_ICONV=ON \
	-DTHREADSAFE=$(if $(BR2_TOOLCHAIN_HAS_THREADS),ON,OFF)

LIBGIT2_DEPENDENCIES = zlib

# If libiconv is available (for !locale toolchains), then we can use
# it for iconv support. Note that USE_ICONV=ON is still correct even
# without libiconv because (1) most toolchain have iconv support
# without libiconv and (2) even if USE_ICONV=ON but iconv support is
# not available, libgit2 simply avoids using iconv.
ifeq ($(BR2_PACKAGE_LIBICONV),y)
LIBGIT2_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_LIBSSH2),y)
LIBGIT2_DEPENDENCIES += libssh2
LIBGIT2_CONF_OPTS += -DUSE_SSH=ON
else
LIBGIT2_CONF_OPTS += -DUSE_SSH=OFF
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBGIT2_DEPENDENCIES += openssl
LIBGIT2_CONF_OPTS += -DUSE_HTTPS=OpenSSL
else
LIBGIT2_CONF_OPTS += -DUSE_HTTPS=OFF
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
LIBGIT2_DEPENDENCIES += libcurl
LIBGIT2_CONF_OPTS += -DCURL=ON
else
LIBGIT2_CONF_OPTS += -DCURL=OFF
endif

$(eval $(cmake-package))
