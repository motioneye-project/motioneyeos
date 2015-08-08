################################################################################
#
# scrypt
#
################################################################################

SCRYPT_VERSION = 1.1.6
SCRYPT_SOURCE = scrypt-$(SCRYPT_VERSION).tgz
SCRYPT_SITE = http://www.tarsnap.com/scrypt
SCRYPT_LICENSE = BSD2
SCRYPT_INSTALL_STAGING = YES

$(eval $(autotools-package))
