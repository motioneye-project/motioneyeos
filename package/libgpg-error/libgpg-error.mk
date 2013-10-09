################################################################################
#
# libgpg-error
#
################################################################################

LIBGPG_ERROR_VERSION = 1.12
LIBGPG_ERROR_SITE = ftp://ftp.gnupg.org/gcrypt/libgpg-error
LIBGPG_ERROR_LICENSE = LGPLv2.1+
LIBGPG_ERROR_LICENSE_FILES = COPYING.LIB
LIBGPG_ERROR_INSTALL_STAGING = YES
LIBGPG_ERROR_CONFIG_SCRIPTS = gpg-error-config

$(eval $(autotools-package))
