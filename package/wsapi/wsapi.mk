################################################################################
#
# wsapi
#
################################################################################

WSAPI_VERSION = 1.6.1-1
WSAPI_LICENSE = MIT
WSAPI_LICENSE_FILES = $(WSAPI_SUBDIR)/doc/us/license.html

$(eval $(luarocks-package))
