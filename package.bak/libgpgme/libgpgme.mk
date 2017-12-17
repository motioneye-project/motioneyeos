################################################################################
#
# libgpgme
#
################################################################################

LIBGPGME_VERSION = 1.7.1
LIBGPGME_SITE = ftp://ftp.gnupg.org/gcrypt/gpgme
LIBGPGME_SOURCE = gpgme-$(LIBGPGME_VERSION).tar.bz2
LIBGPGME_LICENSE = LGPLv2.1+
LIBGPGME_LICENSE_FILES = COPYING.LESSER
LIBGPGME_INSTALL_STAGING = YES
LIBGPGME_DEPENDENCIES = libassuan libgpg-error
LIBGPGME_LANGUAGE_BINDINGS = cl

# libgpgme, needs to know the gpg binary path on the target.
LIBGPGME_CONF_OPTS = --with-gpg=/usr/bin/gpg \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr \
	--with-libassuan-prefix=$(STAGING_DIR)/usr \
	--disable-gpgsm-test \
	--disable-gpgconf-test \
	--disable-g13-test \
	--disable-gpg-test \
	--enable-languages=$(LIBGPGME_LANGUAGE_BINDINGS)

# C++ bindings require a C++11 capable gcc
ifeq ($(BR2_INSTALL_LIBSTDCPP)$(BR2_TOOLCHAIN_GCC_AT_LEAST_4_8),yy)
LIBGPGME_LANGUAGE_BINDINGS := $(LIBGPGME_LANGUAGE_BINDINGS),cpp
endif

# Handle argp-standalone or it errors out during build
ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
# musl libc does not define error_t in errno.h, but argp.h does.
# Assume we have error_t to avoid collision with the argp.h error_t.
LIBGPGME_CONF_ENV += LIBS="-largp" ac_cv_type_error_t=yes
LIBGPGME_DEPENDENCIES += argp-standalone
endif

$(eval $(autotools-package))
