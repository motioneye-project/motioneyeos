################################################################################
#
# luacrypto
#
################################################################################

LUACRYPTO_VERSION = 0.3.2
LUACRYPTO_SITE = $(call github,mkottman,luacrypto,$(LUACRYPTO_VERSION))
LUACRYPTO_LICENSE = MIT
LUACRYPTO_LICENSE_FILES = COPYING
LUACRYPTO_DEPENDENCIES = lua openssl host-pkgconf
LUACRYPTO_AUTORECONF = YES

$(eval $(autotools-package))
