#############################################################
#
# libgcrypt
#
#############################################################

LIBGCRYPT_VERSION = 1.5.0
LIBGCRYPT_SOURCE = libgcrypt-$(LIBGCRYPT_VERSION).tar.bz2
LIBGCRYPT_LICENSE = LGPLv2.1+
LIBGCRYPT_LICENSE_FILES = COPYING.LIB
LIBGCRYPT_SITE = ftp://ftp.gnupg.org/gcrypt/libgcrypt
LIBGCRYPT_INSTALL_STAGING = YES
LIBGCRYPT_DEPENDENCIES = libgpg-error

LIBGCRYPT_CONF_ENV = \
	ac_cv_sys_symbol_underscore=no
LIBGCRYPT_CONF_OPT = \
	--disable-optimization \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr

# Tests use fork()
define LIBGCRYPT_DISABLE_TESTS
	$(SED) 's/ tests//' $(@D)/Makefile.in
endef

LIBGCRYPT_POST_PATCH_HOOKS += LIBGCRYPT_DISABLE_TESTS

define LIBGCRYPT_STAGING_LIBGCRYPT_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		$(STAGING_DIR)/usr/bin/libgcrypt-config
endef

LIBGCRYPT_POST_INSTALL_STAGING_HOOKS += LIBGCRYPT_STAGING_LIBGCRYPT_CONFIG_FIXUP


$(eval $(autotools-package))
