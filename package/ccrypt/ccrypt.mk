################################################################################
#
# ccrypt
#
################################################################################

CCRYPT_VERSION = 1.11
CCRYPT_SITE = http://ccrypt.sourceforge.net/download/$(CCRYPT_VERSION)

CCRYPT_LICENSE = GPL-2.0+
CCRYPT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
