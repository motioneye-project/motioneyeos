################################################################################
#
# libgcrypt
#
################################################################################

LIBGCRYPT_VERSION = 1.8.2
LIBGCRYPT_SOURCE = libgcrypt-$(LIBGCRYPT_VERSION).tar.bz2
LIBGCRYPT_LICENSE = LGPL-2.1+
LIBGCRYPT_LICENSE_FILES = COPYING.LIB
LIBGCRYPT_SITE = https://gnupg.org/ftp/gcrypt/libgcrypt
LIBGCRYPT_INSTALL_STAGING = YES
LIBGCRYPT_DEPENDENCIES = libgpg-error
LIBGCRYPT_CONFIG_SCRIPTS = libgcrypt-config

LIBGCRYPT_CONF_ENV = \
	ac_cv_sys_symbol_underscore=no
LIBGCRYPT_CONF_OPTS = \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr

# Libgcrypt doesn't support assembly for coldfire
ifeq ($(BR2_m68k_cf),y)
LIBGCRYPT_CONF_OPTS += --disable-asm
endif

# Code doesn't build in thumb mode
ifeq ($(BR2_arm),y)
LIBGCRYPT_CONF_ENV += CFLAGS="$(patsubst -mthumb,,$(TARGET_CFLAGS))"
endif

# Tests use fork()
define LIBGCRYPT_DISABLE_TESTS
	$(SED) 's/ tests//' $(@D)/Makefile.in
endef

LIBGCRYPT_POST_PATCH_HOOKS += LIBGCRYPT_DISABLE_TESTS

$(eval $(autotools-package))
