################################################################################
#
# libksba
#
################################################################################

LIBKSBA_VERSION = 1.3.5
LIBKSBA_SOURCE = libksba-$(LIBKSBA_VERSION).tar.bz2
LIBKSBA_SITE = ftp://ftp.gnupg.org/gcrypt/libksba
LIBKSBA_LICENSE = LGPL-3.0+ or GPL-2.0+ (library, headers), GPL-3.0+ (manual, tests, build system)
LIBKSBA_LICENSE_FILES = AUTHORS COPYING COPYING.GPLv2 COPYING.GPLv3 COPYING.LGPLv3
LIBKSBA_INSTALL_STAGING = YES
LIBKSBA_DEPENDENCIES = libgpg-error
LIBKSBA_CONF_OPTS = --with-gpg-error-prefix=$(STAGING_DIR)/usr

$(eval $(autotools-package))
