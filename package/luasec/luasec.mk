################################################################################
#
# luasec
#
################################################################################

LUASEC_VERSION_UPSTREAM = 0.7
LUASEC_VERSION = $(LUASEC_VERSION_UPSTREAM)-1
LUASEC_SUBDIR = luasec-luasec-$(LUASEC_VERSION_UPSTREAM)
LUASEC_LICENSE = MIT
LUASEC_LICENSE_FILES = $(LUASEC_SUBDIR)/LICENSE
LUASEC_DEPENDENCIES = openssl

$(eval $(luarocks-package))
