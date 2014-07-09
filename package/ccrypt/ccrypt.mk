################################################################################
#
# ccrypt
#
################################################################################

CCRYPT_VERSION = 1.10
CCRYPT_SITE = http://ccrypt.sourceforge.net/download/

CCRYPT_LICENSE = GPLv2+
CCRYPT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
