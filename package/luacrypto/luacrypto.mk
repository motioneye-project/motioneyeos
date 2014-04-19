################################################################################
#
# luacrypto
#
################################################################################

LUACRYPTO_VERSION_UPSTREAM = 0.3.2
LUACRYPTO_VERSION = $(LUACRYPTO_VERSION_UPSTREAM)-1
LUACRYPTO_SUBDIR = luacrypto-$(LUACRYPTO_VERSION_UPSTREAM)
LUACRYPTO_LICENSE = MIT
LUACRYPTO_LICENSE_FILES = $(LUACRYPTO_SUBDIR)/COPYING
LUACRYPTO_DEPENDENCIES = luainterpreter openssl

$(eval $(luarocks-package))
