#############################################################
#
# libgpg-error
#
#############################################################

LIBGPG_ERROR_VERSION = 1.10
LIBGPG_ERROR_SITE = ftp://ftp.gnupg.org/gcrypt/libgpg-error
LIBGPG_ERROR_INSTALL_STAGING = YES

$(eval $(autotools-package))
