################################################################################
#
# luasec
#
################################################################################

LUASEC_VERSION_UPSTREAM = 0.4.1
LUASEC_VERSION = $(LUASEC_VERSION_UPSTREAM)-2
LUASEC_SUBDIR  = luasec-luasec-$(LUASEC_VERSION_UPSTREAM)
LUASEC_LICENSE = MIT
LUASEC_LICENSE_FILES = $(LUASEC_SUBDIR)/LICENSE
LUASEC_DEPENDENCIES = openssl

$(eval $(luarocks-package))
