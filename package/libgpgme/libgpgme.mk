################################################################################
#
# libgpgme
#
################################################################################

LIBGPGME_VERSION = 1.4.2
LIBGPGME_SITE = ftp://ftp.gnupg.org/gcrypt/gpgme/
LIBGPGME_SOURCE = gpgme-$(LIBGPGME_VERSION).tar.bz2
LIBGPGME_LICENSE = LGPLv2.1+
LIBGPGME_LICENSE_FILES = COPYING.LESSER
LIBGPGME_INSTALL_STAGING = YES

# libgpgme, needs to know the gpg binary path on the target.
LIBGPGME_CONF_OPT = --with-gpg=/usr/bin/gpg \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr \
	--with-libassuan-prefix=$(STAGING_DIR)/usr \
	--without-gpgsm \
	--without-gpgconf \
	--without-g13
LIBGPGME_DEPENDENCIES = libassuan libgpg-error

$(eval $(autotools-package))
