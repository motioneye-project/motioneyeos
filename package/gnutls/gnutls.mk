#############################################################
#
# gnutls
#
#############################################################

GNUTLS_VERSION = 2.12.20
GNUTLS_SOURCE = gnutls-$(GNUTLS_VERSION).tar.bz2
GNUTLS_SITE = $(BR2_GNU_MIRROR)/gnutls
GNUTLS_LICENSE = GPLv3+ LGPLv2.1+
GNUTLS_LICENSE_FILES = COPYING lib/COPYING
GNUTLS_DEPENDENCIES = host-pkgconf libgcrypt $(if $(BR2_PACKAGE_ZLIB),zlib)
GNUTLS_CONF_ENV = acl_cv_rpath=no
GNUTLS_CONF_OPT = --with-libgcrypt --without-libgcrypt-prefix \
		--without-p11-kit --disable-rpath
GNUTLS_INSTALL_STAGING = YES

$(eval $(autotools-package))
