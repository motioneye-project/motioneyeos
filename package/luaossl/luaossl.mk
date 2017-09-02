################################################################################
#
# luaossl
#
################################################################################

LUAOSSL_VERSION_UPSTREAM = 20170901
LUAOSSL_VERSION = $(LUAOSSL_VERSION_UPSTREAM)-0
LUAOSSL_SUBDIR = luaossl-rel-$(LUAOSSL_VERSION_UPSTREAM)
LUAOSSL_LICENSE = MIT
LUAOSSL_LICENSE_FILES = $(LUAOSSL_SUBDIR)/LICENSE
LUAOSSL_DEPENDENCIES = openssl

$(eval $(luarocks-package))
