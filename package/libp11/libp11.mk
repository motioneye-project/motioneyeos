################################################################################
#
# libp11
#
################################################################################

LIBP11_VERSION = 0.4.10
LIBP11_SITE = https://github.com/OpenSC/libp11/releases/download/libp11-$(LIBP11_VERSION)
LIBP11_DEPENDENCIES = openssl host-pkgconf
LIBP11_INSTALL_STAGING = YES
LIBP11_LICENSE = LGPL-2.1+
LIBP11_LICENSE_FILES = COPYING

# pkg-config returns a libcrypto enginesdir prefixed with the sysroot,
# so let's rip it out.
LIBP11_CONF_OPTS = \
	--with-enginesdir=`$(PKG_CONFIG_HOST_BINARY) --variable enginesdir libcrypto | xargs readlink -f | sed 's%^$(STAGING_DIR)%%'`

ifeq ($(BR2_PACKAGE_P11_KIT),y)
LIBP11_CONF_OPTS += --with-pkcs11-module=/usr/lib/p11-kit-proxy.so
endif

HOST_LIBP11_DEPENDENCIES = host-pkgconf host-openssl

$(eval $(autotools-package))
$(eval $(host-autotools-package))
