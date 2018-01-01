################################################################################
#
# luajson
#
################################################################################

LUAJSON_VERSION = 1.3.4-1
LUAJSON_SUBDIR = luajson
LUAJSON_LICENSE = MIT
LUAJSON_LICENSE_FILES = $(LUAJSON_SUBDIR)/LICENSE

$(eval $(luarocks-package))
