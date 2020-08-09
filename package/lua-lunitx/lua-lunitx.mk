################################################################################
#
# lua-lunitx
#
################################################################################

LUA_LUNITX_VERSION = 0.8-1
LUA_LUNITX_NAME_UPSTREAM = lunitx
LUA_LUNITX_SUBDIR = lunit
LUA_LUNITX_LICENSE = MIT
LUA_LUNITX_LICENSE_FILES = $(LUA_LUNITX_SUBDIR)/LICENSE

$(eval $(luarocks-package))
