################################################################################
#
# wsapi
#
################################################################################

WSAPI_VERSION = 1.7-1
WSAPI_SUBDIR = wsapi
WSAPI_LICENSE = MIT
WSAPI_LICENSE_FILES = \
	$(WSAPI_SUBDIR)/doc/us/license.html \
	$(WSAPI_SUBDIR)/doc/us/license.md

$(eval $(luarocks-package))
