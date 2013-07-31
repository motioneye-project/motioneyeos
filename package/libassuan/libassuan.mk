################################################################################
#
# libassuan
#
################################################################################

LIBASSUAN_VERSION = 2.1.1
LIBASSUAN_SITE = ftp://ftp.gnupg.org/gcrypt/libassuan/
LIBASSUAN_SOURCE = libassuan-$(LIBASSUAN_VERSION).tar.bz2
LIBASSUAN_LICENSE = LGPLv2.1+ (library), GPLv3 (tests, doc)
LIBASSUAN_LICENSE_FILES = COPYING.LIB COPYING
LIBASSUAN_INSTALL_STAGING = YES
LIBASSUAN_DEPENDENCIES = libgpg-error
LIBASSUAN_CONF_OPT = \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr

$(eval $(autotools-package))
