################################################################################
#
# lua-iconv
#
################################################################################

LUA_ICONV_VERSION = 7-1
LUA_ICONV_LICENSE = MIT
LUA_ICONV_LICENSE_FILES = $(LUA_ICONV_SUBDIR)/COPYING
LUA_ICONV_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)

$(eval $(luarocks-package))
