################################################################################
#
# libgpgme
#
################################################################################

LIBGPGME_VERSION = 1.5.1
LIBGPGME_SITE = ftp://ftp.gnupg.org/gcrypt/gpgme
LIBGPGME_SOURCE = gpgme-$(LIBGPGME_VERSION).tar.bz2
LIBGPGME_LICENSE = LGPLv2.1+
LIBGPGME_LICENSE_FILES = COPYING.LESSER
LIBGPGME_INSTALL_STAGING = YES
LIBGPGME_DEPENDENCIES = libassuan libgpg-error

# libgpgme, needs to know the gpg binary path on the target.
LIBGPGME_CONF_OPT = --with-gpg=/usr/bin/gpg \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr \
	--with-libassuan-prefix=$(STAGING_DIR)/usr \
	--disable-gpgsm-test \
	--disable-gpgconf-test \
	--disable-g13-test \
	--disable-gpg-test

# Handle argp-standalone or it errors out during build
ifeq ($(BR2_PACKAGE_ARGP_STANDALONE)$(BR2_TOOLCHAIN_USES_UCLIBC),yy)
LIBGPGME_CONF_ENV += LIBS="-largp"
LIBGPGME_DEPENDENCIES += argp-standalone
endif

$(eval $(autotools-package))
