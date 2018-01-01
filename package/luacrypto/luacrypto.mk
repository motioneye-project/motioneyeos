################################################################################
#
# luacrypto
#
################################################################################

LUACRYPTO_VERSION = 0.3.2-1
LUACRYPTO_LICENSE = MIT
LUACRYPTO_LICENSE_FILES = $(LUACRYPTO_SUBDIR)/COPYING
LUACRYPTO_DEPENDENCIES = openssl

$(eval $(luarocks-package))
