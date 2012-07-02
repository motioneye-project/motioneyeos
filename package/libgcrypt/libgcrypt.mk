#############################################################
#
# libgcrypt
#
#############################################################

LIBGCRYPT_VERSION = 1.5.0
LIBGCRYPT_SOURCE = libgcrypt-$(LIBGCRYPT_VERSION).tar.bz2
LIBGCRYPT_SITE = ftp://ftp.gnupg.org/gcrypt/libgcrypt
LIBGCRYPT_INSTALL_STAGING = YES

LIBGCRYPT_CONF_ENV = \
	ac_cv_sys_symbol_underscore=no
LIBGCRYPT_CONF_OPT = \
	--disable-optimization \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr

LIBGCRYPT_DEPENDENCIES = libgpg-error

$(eval $(autotools-package))
