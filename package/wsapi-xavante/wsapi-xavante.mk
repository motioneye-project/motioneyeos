################################################################################
#
# wsapi-xavante
#
################################################################################

WSAPI_XAVANTE_VERSION_MAJOR = 1.6.1
WSAPI_XAVANTE_VERSION = $(WSAPI_XAVANTE_VERSION_MAJOR)-1
WSAPI_XAVANTE_SUBDIR = wsapi-$(WSAPI_XAVANTE_VERSION_MAJOR)
WSAPI_XAVANTE_LICENSE = MIT

$(eval $(luarocks-package))
