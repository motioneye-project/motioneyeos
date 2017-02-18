################################################################################
#
# libmcrypt
#
################################################################################

LIBMCRYPT_VERSION = 2.5.8
LIBMCRYPT_SITE = http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/$(LIBMCRYPT_VERSION)
LIBMCRYPT_AUTORECONF = YES
LIBMCRYPT_INSTALL_STAGING = YES
LIBMCRYPT_LICENSE = LGPLv2.1
LIBMCRYPT_LICENSE_FILES = COPYING.LIB
LIBMCRYPT_CONFIG_SCRIPTS = libmcrypt-config

$(eval $(autotools-package))
