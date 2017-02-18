################################################################################
#
# scrypt
#
################################################################################

SCRYPT_VERSION = 1.2.0
SCRYPT_SOURCE = scrypt-$(SCRYPT_VERSION).tgz
SCRYPT_SITE = http://www.tarsnap.com/scrypt
SCRYPT_LICENSE = BSD-2c
SCRYPT_LICENSE_FILES = main.c
SCRYPT_DEPENDENCIES = openssl
SCRYPT_INSTALL_STAGING = YES

$(eval $(autotools-package))
