################################################################################
#
# lua-markdown
#
################################################################################

LUA_MARKDOWN_VERSION = 0.33-1
LUA_MARKDOWN_NAME_UPSTREAM = Markdown
LUA_MARKDOWN_SUBDIR = markdown
LUA_MARKDOWN_LICENSE = MIT
LUA_MARKDOWN_LICENSE_FILES = $(LUA_MARKDOWN_SUBDIR)/LICENSE

$(eval $(luarocks-package))
