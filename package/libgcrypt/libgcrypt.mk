################################################################################
#
# libgcrypt
#
################################################################################

LIBGCRYPT_VERSION = 1.6.1
LIBGCRYPT_SOURCE = libgcrypt-$(LIBGCRYPT_VERSION).tar.bz2
LIBGCRYPT_LICENSE = LGPLv2.1+
LIBGCRYPT_LICENSE_FILES = COPYING.LIB
LIBGCRYPT_SITE = ftp://ftp.gnupg.org/gcrypt/libgcrypt
LIBGCRYPT_INSTALL_STAGING = YES
LIBGCRYPT_DEPENDENCIES = libgpg-error
LIBGCRYPT_CONFIG_SCRIPTS = libgcrypt-config

LIBGCRYPT_CONF_ENV = \
	ac_cv_sys_symbol_underscore=no
LIBGCRYPT_CONF_OPT = \
	--disable-optimization \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr

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
