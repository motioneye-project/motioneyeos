################################################################################
#
# libgpg-error
#
################################################################################

LIBGPG_ERROR_VERSION = 1.33
LIBGPG_ERROR_SITE = https://www.gnupg.org/ftp/gcrypt/libgpg-error
LIBGPG_ERROR_SOURCE = libgpg-error-$(LIBGPG_ERROR_VERSION).tar.bz2
LIBGPG_ERROR_LICENSE = GPL-2.0+, LGPL-2.1+
LIBGPG_ERROR_LICENSE_FILES = COPYING COPYING.LIB
LIBGPG_ERROR_INSTALL_STAGING = YES
LIBGPG_ERROR_CONFIG_SCRIPTS = gpg-error-config
LIBGPG_ERROR_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)
LIBGPG_ERROR_CONF_OPTS = --disable-tests \
		--host=$(BR2_PACKAGE_LIBGPG_ERROR_SYSCFG)

$(eval $(autotools-package))
