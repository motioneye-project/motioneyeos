################################################################################
#
# lua-lpeg-patterns
#
################################################################################

LUA_LPEG_PATTERNS_VERSION = 0.4-0
LUA_LPEG_PATTERNS_NAME_UPSTREAM = lpeg_patterns
LUA_LPEG_PATTERNS_ROCKSPEC = $(LUA_LPEG_PATTERNS_NAME_UPSTREAM)-$(LUA_LPEG_PATTERNS_VERSION).rockspec
LUA_LPEG_PATTERNS_SOURCE = $(LUA_LPEG_PATTERNS_NAME_UPSTREAM)-$(LUA_LPEG_PATTERNS_VERSION).src.rock
LUA_LPEG_PATTERNS_LICENSE = MIT
LUA_LPEG_PATTERNS_LICENSE_FILES = $(LUA_LPEG_PATTERNS_SUBDIR)/LICENSE.md

$(eval $(luarocks-package))
