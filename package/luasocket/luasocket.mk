################################################################################
#
# luasocket
#
################################################################################

LUASOCKET_VERSION = 3.0rc1-1
LUASOCKET_SUBDIR = luasocket-3.0-rc1
LUASOCKET_LICENSE = MIT
LUASOCKET_LICENSE_FILES = $(LUASOCKET_SUBDIR)/LICENSE

$(eval $(luarocks-package))
