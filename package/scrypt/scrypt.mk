################################################################################
#
# scrypt
#
################################################################################

SCRYPT_VERSION = 1.3.0
SCRYPT_SOURCE = scrypt-$(SCRYPT_VERSION).tgz
SCRYPT_SITE = http://www.tarsnap.com/scrypt
SCRYPT_LICENSE = BSD-2-Clause
SCRYPT_LICENSE_FILES = COPYRIGHT
SCRYPT_DEPENDENCIES = openssl
SCRYPT_INSTALL_STAGING = YES

$(eval $(autotools-package))
